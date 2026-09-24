<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CI_Responsibility mapping
     Handles contact (responsibility) and organization information
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
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
      <!-- Resolve party reference (organisation) -->
      <xsl:if test="eCH0271_1:party[@ili:ref]">
        <xsl:variable name="partyId" select="eCH0271_1:party/@ili:ref"/>
        <xsl:variable name="partyObj" select="key('byTID', $partyId)"/>
        <xsl:if test="$partyObj/self::eCH0271_1:CHE_CI_Organisation">
          <cit:party>
            <xsl:apply-templates select="$partyObj" mode="organisation"/>
          </cit:party>
        </xsl:if>
      </xsl:if>
    </cit:CI_Responsibility>
  </xsl:template>

  <!-- ================================================================
       CHE_CI_Organisation: name, contact info, acronym
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_CI_Organisation" mode="organisation">
    <che:CHE_CI_Organisation gco:isoType="cit:CI_Organisation">
      <xsl:if test="eCH0271_1:name">
        <cit:name>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:name)"/>
          </gco:CharacterString>
        </cit:name>
      </xsl:if>
      <!-- Resolve contactInfo reference -->
      <xsl:if test="eCH0271_1:contactInfo[@ili:ref]">
        <xsl:variable name="contactId" select="eCH0271_1:contactInfo/@ili:ref"/>
        <xsl:variable name="contactObj" select="key('byTID', $contactId)"/>
        <xsl:if test="$contactObj/self::eCH0271_1:CI_Contact">
          <cit:contactInfo>
            <xsl:apply-templates select="$contactObj" mode="contact-info"/>
          </cit:contactInfo>
        </xsl:if>
      </xsl:if>
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
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Contact" mode="contact-info">
    <cit:CI_Contact>
      <!-- Resolve address reference -->
      <xsl:if test="eCH0271_1:address[@ili:ref]">
        <xsl:variable name="addressId" select="eCH0271_1:address/@ili:ref"/>
        <xsl:variable name="addressObj" select="key('byTID', $addressId)"/>
        <xsl:if test="$addressObj/self::eCH0271_1:CI_Address">
          <cit:address>
            <xsl:apply-templates select="$addressObj" mode="address"/>
          </cit:address>
        </xsl:if>
      </xsl:if>
    </cit:CI_Contact>
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
            <xsl:value-of select="normalize-space(eCH0271_1:country)"/>
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
