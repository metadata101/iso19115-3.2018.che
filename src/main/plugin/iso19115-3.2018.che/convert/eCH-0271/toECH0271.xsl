<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:iso19115-to-ech0271="urn:iso19115-to-ech0271-functions"
  xmlns:che="http://geocat.ch/che"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:mdq="http://standards.iso.org/iso/19115/-3/mdq/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
  xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
  xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:int="http://www.interlis.ch/INTERLIS2.3"
  xmlns:ech0271="http://www.interlis.ch/ILIGML-2.0/eCH0271_1"
  exclude-result-prefixes="xsl xs che mdb mri mrd cit gex mdq mcc lan gco mrl mrs mco ech0271 iso19115-to-ech0271">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="uuid" as="xs:string?" select="()"/>

  <xsl:template match="/">
    <TRANSFER xmlns="http://www.interlis.ch/INTERLIS2.3">
      <HEADERSECTION VERSION="2.3" SENDER="iso19115-3-to-ech0271-converter">
        <MODELS>
          <MODEL NAME="eCH0271_1" VERSION="2024-01-01"/>
        </MODELS>
      </HEADERSECTION>
      <DATASECTION>
        <eCH0271_1.eCH0271>
          <xsl:apply-templates select="//che:CHE_MD_Metadata | //mdb:MD_Metadata" mode="iso19115-to-ech0271"/>
        </eCH0271_1.eCH0271>
      </DATASECTION>
    </TRANSFER>
  </xsl:template>

  <xsl:template match="che:CHE_MD_Metadata | mdb:MD_Metadata" mode="iso19115-to-ech0271">
    <xsl:variable name="mdTID" select="generate-id(.)"/>
    <xsl:variable name="mdUUID">
      <xsl:choose>
        <xsl:when test="normalize-space($uuid) != ''">
          <xsl:value-of select="$uuid"/>
        </xsl:when>
        <xsl:when test="mdb:metadataIdentifier/*/mcc:code/*/text()">
          <xsl:value-of select="normalize-space(mdb:metadataIdentifier/*/mcc:code/*/text())"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('MD_', generate-id(.))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <eCH0271_1.eCH0271.MD_Metadata TID="MD_{$mdTID}">
      <fileIdentifier>
        <xsl:value-of select="$mdUUID"/>
      </fileIdentifier>

      <xsl:apply-templates select="mdb:defaultLocale | mdb:otherLocale" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="mdb:contact" mode="iso19115-to-ech0271"/>

      <xsl:if test="mdb:dateInfo/*/cit:date/gco:Date | mdb:dateInfo/*/cit:date/gco:DateTime">
        <dateStamp>
          <xsl:value-of select="normalize-space((mdb:dateInfo/*/cit:date/gco:Date, mdb:dateInfo/*/cit:date/gco:DateTime)[1])"/>
        </dateStamp>
      </xsl:if>

      <!-- Metadata standard -->
      <xsl:if test="mdb:metadataStandard/*/cit:title/gco:CharacterString">
        <metadataStandardName>
          <xsl:value-of select="normalize-space(mdb:metadataStandard/*/cit:title/gco:CharacterString)"/>
        </metadataStandardName>
      </xsl:if>
      <xsl:if test="mdb:metadataStandard/*/cit:edition/gco:CharacterString">
        <metadataStandardVersion>
          <xsl:value-of select="normalize-space(mdb:metadataStandard/*/cit:edition/gco:CharacterString)"/>
        </metadataStandardVersion>
      </xsl:if>

      <xsl:apply-templates select="mdb:identificationInfo" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="mdb:distributionInfo" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="mdb:dataQualityInfo" mode="iso19115-to-ech0271"/>
    </eCH0271_1.eCH0271.MD_Metadata>
  </xsl:template>

  <xsl:template match="mdb:defaultLocale | mdb:otherLocale" mode="iso19115-to-ech0271">
    <xsl:variable name="langCode" select="normalize-space(*/lan:language/*/text())"/>
    <language>
      <xsl:value-of select="iso19115-to-ech0271:langToISO639($langCode)"/>
    </language>
  </xsl:template>

  <xsl:template match="mdb:identificationInfo" mode="iso19115-to-ech0271">
    <xsl:variable name="diTID" select="generate-id(.)"/>
    <eCH0271_1.eCH0271.MD_DataIdentification TID="DI_{$diTID}">
      <xsl:if test="*/mri:citation">
        <xsl:apply-templates select="*/mri:citation" mode="iso19115-to-ech0271"/>
      </xsl:if>
      <xsl:if test="*/mri:abstract/gco:CharacterString">
        <abstract>
          <xsl:value-of select="normalize-space(*/mri:abstract/gco:CharacterString)"/>
        </abstract>
      </xsl:if>
      <xsl:if test="*/mri:purpose/gco:CharacterString">
        <purpose>
          <xsl:value-of select="normalize-space(*/mri:purpose/gco:CharacterString)"/>
        </purpose>
      </xsl:if>
      <xsl:if test="*/mri:status/mcc:MD_ProgressCode/@codeListValue">
        <status>
          <xsl:value-of select="normalize-space(*/mri:status/mcc:MD_ProgressCode/@codeListValue)"/>
        </status>
      </xsl:if>
      <xsl:apply-templates select="*/mri:pointOfContact" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="*/mri:extent" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="*/mri:keywords" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="*/mri:resourceConstraints" mode="iso19115-to-ech0271"/>
    </eCH0271_1.eCH0271.MD_DataIdentification>
  </xsl:template>

  <xsl:template match="mri:citation | cit:CI_Citation" mode="iso19115-to-ech0271">
    <xsl:variable name="citTID" select="generate-id(.)"/>
    <eCH0271_1.eCH0271.CI_Citation TID="CIT_{$citTID}">
      <xsl:if test="cit:title/gco:CharacterString">
        <title>
          <xsl:value-of select="normalize-space(cit:title/gco:CharacterString)"/>
        </title>
      </xsl:if>
      <!-- Publication date -->
      <xsl:if test="cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']/cit:date/gco:Date">
        <date>
          <xsl:value-of select="normalize-space(cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']/cit:date/gco:Date)"/>
        </date>
      </xsl:if>
      <!-- Revision date (fallback if publication not found) -->
      <xsl:if test="not(cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']/cit:date/gco:Date) and cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']/cit:date/gco:Date">
        <date>
          <xsl:value-of select="normalize-space(cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']/cit:date/gco:Date)"/>
        </date>
      </xsl:if>
    </eCH0271_1.eCH0271.CI_Citation>
  </xsl:template>

  <xsl:template match="mri:extent" mode="iso19115-to-ech0271">
    <xsl:variable name="extTID" select="generate-id(.)"/>
    <eCH0271_1.eCH0271.EX_Extent TID="EXT_{$extTID}">
      <xsl:apply-templates select="gex:EX_Extent/gex:geographicElement" mode="iso19115-to-ech0271"/>
    </eCH0271_1.eCH0271.EX_Extent>
  </xsl:template>

  <xsl:template match="gex:geographicElement" mode="iso19115-to-ech0271">
    <xsl:variable name="bboxTID" select="generate-id(.)"/>
    <xsl:if test="gex:EX_GeographicBoundingBox">
      <eCH0271_1.eCH0271.EX_GeographicBoundingBox TID="BBOX_{$bboxTID}">
        <westBoundLongitude>
          <xsl:value-of select="normalize-space(gex:EX_GeographicBoundingBox/gex:westBoundLongitude/gco:Decimal)"/>
        </westBoundLongitude>
        <eastBoundLongitude>
          <xsl:value-of select="normalize-space(gex:EX_GeographicBoundingBox/gex:eastBoundLongitude/gco:Decimal)"/>
        </eastBoundLongitude>
        <southBoundLatitude>
          <xsl:value-of select="normalize-space(gex:EX_GeographicBoundingBox/gex:southBoundLatitude/gco:Decimal)"/>
        </southBoundLatitude>
        <northBoundLatitude>
          <xsl:value-of select="normalize-space(gex:EX_GeographicBoundingBox/gex:northBoundLatitude/gco:Decimal)"/>
        </northBoundLatitude>
      </eCH0271_1.eCH0271.EX_GeographicBoundingBox>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mdb:distributionInfo" mode="iso19115-to-ech0271">
    <xsl:variable name="distTID" select="generate-id(.)"/>
    <eCH0271_1.eCH0271.MD_Distribution TID="DIST_{$distTID}"/>
  </xsl:template>

  <xsl:template match="mdb:dataQualityInfo" mode="iso19115-to-ech0271">
    <xsl:variable name="dqTID" select="generate-id(.)"/>
    <dataQualityInfo TID="DQ_{$dqTID}"/>
  </xsl:template>

  <xsl:template match="mri:keywords" mode="iso19115-to-ech0271">
    <xsl:variable name="kwTID" select="generate-id(.)"/>
    <xsl:if test="mri:MD_Keywords/mri:keyword">
      <descriptiveKeywords TID="KW_{$kwTID}">
        <xsl:for-each select="mri:MD_Keywords/mri:keyword/gco:CharacterString">
          <keyword>
            <xsl:value-of select="normalize-space(.)"/>
          </keyword>
        </xsl:for-each>
      </descriptiveKeywords>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mdb:contact | mri:pointOfContact" mode="iso19115-to-ech0271">
    <xsl:variable name="respTID" select="generate-id(.)"/>
    <xsl:if test="cit:CI_Responsibility | cit:CI_ResponsibleParty">
      <eCH0271_1.eCH0271.CI_ResponsibleParty TID="RESP_{$respTID}">
        <!-- Role -->
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/@codeListValue">
          <role>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/@codeListValue)"/>
          </role>
        </xsl:if>
        
        <!-- Organisation name (from party - both CHE and standard) -->
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/cit:name/gco:CharacterString">
          <organisationName>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/cit:name/gco:CharacterString)"/>
          </organisationName>
        </xsl:if>
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString">
          <organisationName>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString)"/>
          </organisationName>
        </xsl:if>
        
        <!-- Individual name (from individualMember or direct) -->
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/che:individualMember/cit:CI_Individual/cit:name/gco:CharacterString">
          <individualName>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/che:individualMember/cit:CI_Individual/cit:name/gco:CharacterString)"/>
          </individualName>
        </xsl:if>
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/cit:CI_Individual/cit:name/gco:CharacterString">
          <individualName>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/cit:CI_Individual/cit:name/gco:CharacterString)"/>
          </individualName>
        </xsl:if>

        <!-- Contact info -->
        <xsl:apply-templates select="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/*/cit:contactInfo" mode="iso19115-to-ech0271"/>
      </eCH0271_1.eCH0271.CI_ResponsibleParty>
    </xsl:if>
  </xsl:template>

  <!-- Contact info template -->
  <xsl:template match="cit:contactInfo" mode="iso19115-to-ech0271">
    <xsl:variable name="contactTID" select="generate-id(.)"/>
    <xsl:if test="cit:CI_Contact">
      <contactInfo TID="CONT_{$contactTID}">
        <!-- Phone -->
        <xsl:if test="cit:CI_Contact/cit:phone/cit:CI_Telephone/cit:voice/gco:CharacterString">
          <phone>
            <xsl:value-of select="normalize-space(cit:CI_Contact/cit:phone/cit:CI_Telephone/cit:voice/gco:CharacterString)"/>
          </phone>
        </xsl:if>
        <!-- Address -->
        <xsl:apply-templates select="cit:CI_Contact/cit:address" mode="iso19115-to-ech0271"/>
        <!-- Online resource -->
        <xsl:if test="cit:CI_Contact/cit:onlineResource/cit:CI_OnlineResource/cit:linkage/gco:CharacterString">
          <onlineResource>
            <xsl:value-of select="normalize-space(cit:CI_Contact/cit:onlineResource/cit:CI_OnlineResource/cit:linkage/gco:CharacterString)"/>
          </onlineResource>
        </xsl:if>
      </contactInfo>
    </xsl:if>
  </xsl:template>

  <!-- Address template -->
  <xsl:template match="cit:address" mode="iso19115-to-ech0271">
    <address>
      <xsl:if test="cit:CI_Address/cit:deliveryPoint/gco:CharacterString">
        <streetName>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:deliveryPoint/gco:CharacterString)"/>
        </streetName>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:city/gco:CharacterString">
        <city>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:city/gco:CharacterString)"/>
        </city>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:administrativeArea/gco:CharacterString">
        <administrativeArea>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:administrativeArea/gco:CharacterString)"/>
        </administrativeArea>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:postalCode/gco:CharacterString">
        <postalCode>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:postalCode/gco:CharacterString)"/>
        </postalCode>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:country/gco:CharacterString">
        <country>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:country/gco:CharacterString)"/>
        </country>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:electronicMailAddress/gco:CharacterString">
        <electronicMailAddress>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:electronicMailAddress/gco:CharacterString)"/>
        </electronicMailAddress>
      </xsl:if>
    </address>
  </xsl:template>

  <xsl:template match="mri:resourceConstraints" mode="iso19115-to-ech0271">
    <xsl:variable name="constraintTID" select="generate-id(.)"/>
    <xsl:if test="mco:MD_LegalConstraints/mco:useLimitation/gco:CharacterString">
      <resourceConstraints TID="RC_{$constraintTID}">
        <useLimitation>
          <xsl:value-of select="normalize-space(mco:MD_LegalConstraints/mco:useLimitation/gco:CharacterString)"/>
        </useLimitation>
      </resourceConstraints>
    </xsl:if>
  </xsl:template>

  <xsl:function name="iso19115-to-ech0271:langToISO639">
    <xsl:param name="lang3" as="xs:string"/>
    <xsl:sequence select="
      if ($lang3 = ('ger', 'deu')) then 'de'
      else if ($lang3 = ('fra', 'fre')) then 'fr'
      else if ($lang3 = ('ita')) then 'it'
      else if ($lang3 = ('eng')) then 'en'
      else if ($lang3 = ('roh')) then 'rm'
      else if (string-length($lang3) = 2) then $lang3
      else substring($lang3, 1, 2)"/>
  </xsl:function>

  <xsl:template match="text()|@*" priority="-10" mode="iso19115-to-ech0271"/>
  <xsl:template match="text()|@*" priority="-10"/>

</xsl:stylesheet>
