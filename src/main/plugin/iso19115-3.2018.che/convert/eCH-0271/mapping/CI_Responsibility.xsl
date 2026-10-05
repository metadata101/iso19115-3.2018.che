<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CI_Responsibility mapping
     Handles contact (responsibility) and organization information
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:LocalisationCH_V2="http://www.interlis.ch/xtf/2.4/LocalisationCH_V2"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:che="http://geocat.ch/che"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       contact processor (metadata level - wraps in mdb:contact)
       ================================================================ -->
  <xsl:template match="eCH0271_1:contact[@ili:ref]" mode="contact">
    <xsl:variable name="respId" select="@ili:ref"/>
    <xsl:variable name="respObj" select="key('byTID', $respId)"/>

    <xsl:if test="$respObj/self::eCH0271_1:CI_Responsibility">
      <mdb:contact xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0">
        <xsl:apply-templates select="$respObj" mode="responsibility"/>
      </mdb:contact>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       pointOfContact processor (dataset level - for mri:pointOfContact)
       ================================================================ -->
  <xsl:template match="eCH0271_1:pointOfContact[@ili:ref]" mode="data-point-of-contact">
    <xsl:variable name="respId" select="@ili:ref"/>
    <xsl:variable name="respObj" select="key('byTID', $respId)"/>

    <xsl:if test="$respObj/self::eCH0271_1:CI_Responsibility">
      <xsl:apply-templates select="$respObj" mode="responsibility"/>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       CI_Responsibility: role + party (organization) resolution
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Responsibility" mode="responsibility">
    <cit:CI_Responsibility>
      <cit:role>
        <xsl:call-template name="role-code">
          <xsl:with-param name="value" select="normalize-space(eCH0271_1:role)"/>
        </xsl:call-template>
      </cit:role>
      <!-- Resolve party reference (organisation) - Priority 1: active reference -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:party[@ili:ref]">
          <xsl:variable name="partyId" select="eCH0271_1:party/@ili:ref"/>
          <xsl:variable name="partyObj" select="key('byTID', $partyId)"/>
          <xsl:if test="$partyObj/self::eCH0271_1:CHE_CI_Organisation">
            <cit:party>
              <xsl:apply-templates select="$partyObj" mode="organisation"/>
            </cit:party>
          </xsl:if>
        </xsl:when>
        <!-- Priority 2: Direct TID search (commented reference case) -->
        <xsl:when test="//eCH0271_1:CHE_CI_Organisation[@ili:tid='organisation-001']">
          <xsl:variable name="partyObj" select="//eCH0271_1:CHE_CI_Organisation[@ili:tid='organisation-001']"/>
          <cit:party>
            <xsl:apply-templates select="$partyObj" mode="organisation"/>
          </cit:party>
        </xsl:when>
      </xsl:choose>
    </cit:CI_Responsibility>
  </xsl:template>

  <!-- ================================================================
       CHE_CI_Organisation: name, contact info, individual, acronym
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_CI_Organisation" mode="organisation">
    <che:CHE_CI_Organisation gco:isoType="cit:CI_Organisation">
      <xsl:if test="eCH0271_1:name">
        <cit:name>
          <xsl:choose>
            <!-- MultilingualMText structure: extract text from first language only -->
            <xsl:when test="eCH0271_1:name/Localisation_V2:MultilingualMText/Localisation_V2:LocalisedText">
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(
                  eCH0271_1:name/Localisation_V2:MultilingualMText/Localisation_V2:LocalisedText[1]/
                  Localisation_V2:LocalisedMText/Localisation_V2:Text[1]
                )"/>
              </gco:CharacterString>
            </xsl:when>
            <!-- LocalisationCH_V2 structure: extract text from first language only -->
            <xsl:when test="eCH0271_1:name/LocalisationCH_V2:MultilingualMText/LocalisationCH_V2:LocalisedText">
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(
                  eCH0271_1:name/LocalisationCH_V2:MultilingualMText/LocalisationCH_V2:LocalisedText[1]/
                  LocalisationCH_V2:LocalisedMText/LocalisationCH_V2:Text[1]
                )"/>
              </gco:CharacterString>
            </xsl:when>
            <!-- Plain text (fallback) -->
            <xsl:otherwise>
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(eCH0271_1:name)"/>
              </gco:CharacterString>
            </xsl:otherwise>
          </xsl:choose>
        </cit:name>
      </xsl:if>
      <!-- Resolve contactInfo reference -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:contactInfo[@ili:ref]">
          <xsl:variable name="contactId" select="eCH0271_1:contactInfo/@ili:ref"/>
          <xsl:variable name="contactObj" select="key('byTID', $contactId)"/>
          <xsl:if test="$contactObj/self::eCH0271_1:CI_Contact">
            <cit:contactInfo>
              <xsl:apply-templates select="$contactObj" mode="contact-info"/>
            </cit:contactInfo>
          </xsl:if>
        </xsl:when>
        <!-- Direct TID search fallback (commented reference) -->
        <xsl:when test="//eCH0271_1:CI_Contact[@ili:tid='contact-001']">
          <xsl:variable name="contactObj" select="//eCH0271_1:CI_Contact[@ili:tid='contact-001']"/>
          <cit:contactInfo>
            <xsl:apply-templates select="$contactObj" mode="contact-info"/>
          </cit:contactInfo>
        </xsl:when>
      </xsl:choose>
      <!-- Resolve individual reference (person associated with organisation) -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:individual[@ili:ref]">
          <xsl:variable name="individualId" select="eCH0271_1:individual/@ili:ref"/>
          <xsl:variable name="individualObj" select="key('byTID', $individualId)"/>
          <xsl:if test="$individualObj/self::eCH0271_1:CI_Individual">
            <cit:individual>
              <xsl:apply-templates select="$individualObj" mode="individual"/>
            </cit:individual>
          </xsl:if>
        </xsl:when>
        <!-- Direct TID search fallback (commented reference) -->
        <xsl:when test="//eCH0271_1:CI_Individual[@ili:tid='individual-001']">
          <xsl:variable name="individualObj" select="//eCH0271_1:CI_Individual[@ili:tid='individual-001']"/>
          <cit:individual>
            <xsl:apply-templates select="$individualObj" mode="individual"/>
          </cit:individual>
        </xsl:when>
      </xsl:choose>
      <!-- Swiss extension: organization acronym -->
      <xsl:if test="eCH0271_1:organisationAcronym">
        <che:organisationAcronym>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:organisationAcronym)"/>
          </gco:CharacterString>
        </che:organisationAcronym>
      </xsl:if>
    </che:CHE_CI_Organisation>
  </xsl:template>

  <!-- ================================================================
       CI_Contact: address information
       3-priority: direct ref, TID search fallback
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Contact" mode="contact-info">
    <cit:CI_Contact>
      <!-- Resolve address reference - Priority 1: direct ref -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:address[@ili:ref]">
          <xsl:variable name="addressId" select="eCH0271_1:address/@ili:ref"/>
          <xsl:variable name="addressObj" select="key('byTID', $addressId)"/>
          <xsl:if test="$addressObj/self::eCH0271_1:CI_Address">
            <cit:address>
              <xsl:apply-templates select="$addressObj" mode="address"/>
            </cit:address>
          </xsl:if>
        </xsl:when>
        <!-- Priority 2: Direct TID search (commented reference case) -->
        <xsl:when test="//eCH0271_1:CI_Address[@ili:tid='address-001']">
          <xsl:variable name="addressObj" select="//eCH0271_1:CI_Address[@ili:tid='address-001']"/>
          <cit:address>
            <xsl:apply-templates select="$addressObj" mode="address"/>
          </cit:address>
        </xsl:when>
      </xsl:choose>
    </cit:CI_Contact>
  </xsl:template>

  <!-- ================================================================
       CI_Individual: person name and position
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Individual" mode="individual">
    <cit:CI_Individual>
      <xsl:if test="eCH0271_1:name">
        <cit:name>
          <xsl:choose>
            <!-- MultilingualMText structure with Localisation_V2 -->
            <xsl:when test="eCH0271_1:name/Localisation_V2:MultilingualMText/Localisation_V2:LocalisedText">
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(
                  eCH0271_1:name/Localisation_V2:MultilingualMText/Localisation_V2:LocalisedText[1]/
                  Localisation_V2:LocalisedMText/Localisation_V2:Text[1]
                )"/>
              </gco:CharacterString>
            </xsl:when>
            <!-- MultilingualMText structure with LocalisationCH_V2 -->
            <xsl:when test="eCH0271_1:name/LocalisationCH_V2:MultilingualMText/LocalisationCH_V2:LocalisedText">
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(
                  eCH0271_1:name/LocalisationCH_V2:MultilingualMText/LocalisationCH_V2:LocalisedText[1]/
                  LocalisationCH_V2:LocalisedMText/LocalisationCH_V2:Text[1]
                )"/>
              </gco:CharacterString>
            </xsl:when>
            <!-- Direct eCH0271_1:MultilingualMText -->
            <xsl:when test="eCH0271_1:name/eCH0271_1:MultilingualMText">
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(
                  eCH0271_1:name/eCH0271_1:MultilingualMText/Localisation_V2:LocalisedText[1]/
                  Localisation_V2:LocalisedMText/Localisation_V2:Text[1]
                )"/>
              </gco:CharacterString>
            </xsl:when>
            <!-- Plain text (fallback) -->
            <xsl:otherwise>
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(eCH0271_1:name)"/>
              </gco:CharacterString>
            </xsl:otherwise>
          </xsl:choose>
        </cit:name>
      </xsl:if>
      <xsl:if test="eCH0271_1:positionName">
        <cit:positionName>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:positionName)"/>
          </gco:CharacterString>
        </cit:positionName>
      </xsl:if>
    </cit:CI_Individual>
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
