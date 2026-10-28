<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: CI_Responsibility mapping
     Handles contact (responsibility) and organization information
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:ech0271="urn:ech0271-functions"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:che="http://geocat.ch/che"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       CI_Responsibility: role + party
       Links are resolved with ech0271:related (any direction / association)
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Responsibility" mode="responsibility">
    <cit:CI_Responsibility>
      <cit:role>
        <xsl:call-template name="role-code">
          <xsl:with-param name="value" select="normalize-space(eCH0271_1:role)"/>
        </xsl:call-template>
      </cit:role>
      <xsl:for-each select="ech0271:related(., ('CHE_CI_Organisation', 'CI_Individual'))">
        <cit:party>
          <xsl:apply-templates select="." mode="party"/>
        </cit:party>
      </xsl:for-each>
    </cit:CI_Responsibility>
  </xsl:template>

  <!-- ================================================================
       CHE_CI_Organisation: name, contact info, individual, acronym
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_CI_Organisation" mode="party">
    <che:CHE_CI_Organisation gco:isoType="cit:CI_Organisation">
      <xsl:if test="eCH0271_1:name">
        <cit:name>
          <xsl:apply-templates select="eCH0271_1:name" mode="multilingual-text"/>
        </cit:name>
      </xsl:if>
      <xsl:apply-templates select="ech0271:related(., 'CI_Contact')" mode="contact-info"/>
      <xsl:for-each select="ech0271:related(., 'CI_Individual')">
        <cit:individual>
          <xsl:apply-templates select="." mode="party"/>
        </cit:individual>
      </xsl:for-each>
      <!-- Swiss extension: organization acronym -->
      <xsl:if test="eCH0271_1:organisationAcronym">
        <che:organisationAcronym>
          <xsl:apply-templates select="eCH0271_1:organisationAcronym" mode="multilingual-text"/>
        </che:organisationAcronym>
      </xsl:if>
    </che:CHE_CI_Organisation>
  </xsl:template>

  <!-- ================================================================
       CI_Individual: person name, contact info and position
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Individual" mode="party">
    <cit:CI_Individual>
      <xsl:if test="eCH0271_1:name">
        <cit:name>
          <xsl:apply-templates select="eCH0271_1:name" mode="multilingual-text"/>
        </cit:name>
      </xsl:if>
      <xsl:apply-templates select="ech0271:related(., 'CI_Contact')" mode="contact-info"/>
      <xsl:if test="eCH0271_1:positionName">
        <cit:positionName>
          <xsl:apply-templates select="eCH0271_1:positionName" mode="multilingual-text"/>
        </cit:positionName>
      </xsl:if>
    </cit:CI_Individual>
  </xsl:template>

  <!-- ================================================================
       CI_Contact: phone, address, online resource
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Contact" mode="contact-info">
    <cit:contactInfo>
      <cit:CI_Contact>
        <xsl:apply-templates select="ech0271:related(., 'CI_Telephone')" mode="phone"/>
        <xsl:for-each select="ech0271:related(., 'CI_Address')">
          <cit:address>
            <xsl:apply-templates select="." mode="address"/>
          </cit:address>
        </xsl:for-each>
        <xsl:for-each select="ech0271:related(., 'CI_OnlineResource')">
          <cit:onlineResource>
            <xsl:call-template name="ech0271:CI_OnlineResource">
              <xsl:with-param name="orRecord" select="."/>
            </xsl:call-template>
          </cit:onlineResource>
        </xsl:for-each>
      </cit:CI_Contact>
    </cit:contactInfo>
  </xsl:template>

  <!-- ================================================================
       CI_Telephone: number and type
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Telephone" mode="phone">
    <cit:phone>
      <cit:CI_Telephone>
        <cit:number>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:number)"/>
          </gco:CharacterString>
        </cit:number>
        <xsl:if test="normalize-space(eCH0271_1:numberType) != ''">
          <cit:numberType>
            <cit:CI_TelephoneTypeCode codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_TelephoneTypeCode" codeListValue="{normalize-space(eCH0271_1:numberType)}">
              <xsl:value-of select="normalize-space(eCH0271_1:numberType)"/>
            </cit:CI_TelephoneTypeCode>
          </cit:numberType>
        </xsl:if>
      </cit:CI_Telephone>
    </cit:phone>
  </xsl:template>

  <!-- ================================================================
       Country code converter: ISO 3166-1 alpha-3 → alpha-2
       ================================================================ -->
  <xsl:template name="country-code">
    <xsl:param name="value" as="xs:string"/>
    <xsl:variable name="countryCode">
      <xsl:choose>
        <!-- ISO 3166-1 alpha-3 to alpha-2 conversion (common countries) -->
        <xsl:when test="$value = 'CHE' or $value = 'che'">CH</xsl:when>
        <xsl:when test="$value = 'FRA' or $value = 'fra'">FR</xsl:when>
        <xsl:when test="$value = 'ITA' or $value = 'ita'">IT</xsl:when>
        <xsl:when test="$value = 'AUT' or $value = 'aut'">AT</xsl:when>
        <xsl:when test="$value = 'DEU' or $value = 'deu'">DE</xsl:when>
        <xsl:when test="$value = 'ESP' or $value = 'esp'">ES</xsl:when>
        <xsl:when test="$value = 'GBR' or $value = 'gbr'">GB</xsl:when>
        <xsl:when test="$value = 'NLD' or $value = 'nld'">NL</xsl:when>
        <xsl:when test="$value = 'BEL' or $value = 'bel'">BE</xsl:when>
        <xsl:when test="$value = 'USA' or $value = 'usa'">US</xsl:when>
        <xsl:when test="$value = 'CAN' or $value = 'can'">CA</xsl:when>
        <!-- If already 2 letters, pass through -->
        <xsl:otherwise>
          <xsl:value-of select="upper-case($value)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$countryCode"/>
  </xsl:template>

  <!-- ================================================================
       CI_Address: delivery point, city, postal code, country, email
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Address" mode="address">
    <cit:CI_Address>
      <xsl:if test="eCH0271_1:deliveryPoint">
        <cit:deliveryPoint>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:deliveryPoint)"/>
          </gco:CharacterString>
        </cit:deliveryPoint>
      </xsl:if>
      <xsl:if test="eCH0271_1:city">
        <cit:city>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:city)"/>
          </gco:CharacterString>
        </cit:city>
      </xsl:if>
      <xsl:if test="eCH0271_1:postalCode">
        <cit:postalCode>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:postalCode)"/>
          </gco:CharacterString>
        </cit:postalCode>
      </xsl:if>
      <xsl:if test="eCH0271_1:country">
        <cit:country>
          <gco:CharacterString>
            <xsl:call-template name="country-code">
              <xsl:with-param name="value" select="normalize-space(eCH0271_1:country)"/>
            </xsl:call-template>
          </gco:CharacterString>
        </cit:country>
      </xsl:if>
      <xsl:if test="eCH0271_1:electronicMailAddress">
        <cit:electronicMailAddress>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:electronicMailAddress)"/>
          </gco:CharacterString>
        </cit:electronicMailAddress>
      </xsl:if>
    </cit:CI_Address>
  </xsl:template>

</xsl:stylesheet>
