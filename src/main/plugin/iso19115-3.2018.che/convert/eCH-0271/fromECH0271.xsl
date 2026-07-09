<?xml version="1.0" encoding="UTF-8"?>
<!--
  Direct converter: eCH0271 INTERLIS → ISO 19115-3:2018 (CHE profile)

  XSLT 2.0 — no Java extension functions required.
  Compatible with Saxon HE 9.1+.

  The eCH0271 INTERLIS transfer format stores all objects (MD_Metadata,
  CI_Citation, CI_Responsibility, MD_DataIdentification, etc.) flat
  inside a "basket" element, linked together by @TID / @REF identity
  references.  This stylesheet resolves those references using XSLT 2.0
  key() functions.

  Handles eCH0271_1.eCH0271 baskets with proper namespace resolution.

  Usage from Java:
      TransformerFactory tf = TransformerFactoryFactory.getTransformerFactory(); // Saxon
      Transformer t  = tf.newTransformer(new StreamSource(path/to/eCH-0271/fromECH0271.xsl));
      t.transform(new StreamSource(ech0271Input), new StreamResult(output));
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:int  ="http://www.interlis.ch/INTERLIS2.3"
  xmlns:ech0271 ="urn:ech0271-functions"
  xmlns:che  ="http://geocat.ch/che"
  xmlns:cat  ="http://standards.iso.org/iso/19115/-3/cat/1.0"
  xmlns:cit  ="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gcx  ="http://standards.iso.org/iso/19115/-3/gcx/1.0"
  xmlns:gex  ="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:gml  ="http://www.opengis.net/gml/3.2"
  xmlns:lan  ="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mac  ="http://standards.iso.org/iso/19115/-3/mac/2.0"
  xmlns:mcc  ="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mco  ="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:mdb  ="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mdq  ="http://standards.iso.org/iso/19157/-2/mdq/1.0"
  xmlns:mex  ="http://standards.iso.org/iso/19115/-3/mex/1.0"
  xmlns:mrc  ="http://standards.iso.org/iso/19115/-3/mrc/2.0"
  xmlns:mrd  ="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:mri  ="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:mrl  ="http://standards.iso.org/iso/19115/-3/mrl/2.0"
  xmlns:mrs  ="http://standards.iso.org/iso/19115/-3/mrs/1.0"
  xmlns:msr  ="http://standards.iso.org/iso/19115/-3/msr/2.0"
  xmlns:srv  ="http://standards.iso.org/iso/19115/-3/srv/2.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- ================================================================
       Imports / Includes — Modular mapping files for ISO 19115-3
       ================================================================ -->
  <xsl:include href="mapping/distribution.xsl"/>
  <xsl:include href="mapping/extent.xsl"/>
  <xsl:include href="mapping/legislation.xsl"/>
  <xsl:include href="mapping/maintenance-info.xsl"/>

  <!-- ================================================================
       Parameters
       ================================================================ -->
  <!-- Optional UUID override for the metadata identifier. -->
  <xsl:param name="uuid" as="xs:string?" select="()"/>

  <!-- ================================================================
       Keys — resolve any @REF → the object with the matching @TID
       ================================================================ -->
  <xsl:key name="byTID"
    match="/int:TRANSFER/int:DATASECTION/int:eCH0271_1.eCH0271//*[@TID]"
    use="@TID"/>

  <!-- ================================================================
       Shared constant
       ================================================================ -->
  <xsl:variable name="CL"
    select="'https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#'"/>

  <!-- ================================================================
       Entry point — find the first MD_Metadata record
       ================================================================ -->
  <xsl:template match="/">
    <!-- Locate the eCH0271_1.eCH0271 basket. -->
    <xsl:variable name="basket"
      select="/int:TRANSFER/int:DATASECTION/int:eCH0271_1.eCH0271[1]"/>

    <xsl:if test="empty($basket)">
      <xsl:message terminate="yes">
        ERROR: No eCH0271_1.eCH0271 basket found.
      </xsl:message>
    </xsl:if>

    <xsl:variable name="mdRecord"
      select="$basket/int:eCH0271_1.eCH0271.MD_Metadata[1]"/>

    <xsl:if test="empty($mdRecord)">
      <xsl:message terminate="yes">
        ERROR: No eCH0271_1.eCH0271.MD_Metadata found in the basket.
        This transfer file does not appear to be an eCH0271 metadata record.
      </xsl:message>
    </xsl:if>

    <xsl:apply-templates select="$mdRecord">
      <xsl:with-param name="basket" select="$basket"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ================================================================
       MD_Metadata → che:CHE_MD_Metadata
       ================================================================ -->
  <xsl:template match="int:eCH0271_1.eCH0271.MD_Metadata">
    <xsl:param name="basket" as="element()"/>

    <xsl:variable name="mdTID"        select="@TID"/>
    <xsl:variable name="mainLangCode"
      select="if (normalize-space(int:language) != '')
              then normalize-space(int:language) else 'de'"/>
    <xsl:variable name="mainLangISO3" select="ech0271:langToISO3($mainLangCode)"/>
    <xsl:variable name="mainLangUPPER" select="upper-case($mainLangCode)"/>

    <che:CHE_MD_Metadata gco:isoType="mdb:MD_Metadata">

      <!-- ── 1. Metadata identifier ─────────────────────────────── -->
      <mdb:metadataIdentifier>
        <mcc:MD_Identifier>
          <mcc:code>
            <gco:CharacterString>
              <xsl:choose>
                <xsl:when test="normalize-space($uuid) != ''">
                  <xsl:value-of select="$uuid"/>
                </xsl:when>
                <xsl:when test="normalize-space(int:fileIdentifier) != ''">
                  <xsl:value-of select="normalize-space(int:fileIdentifier)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$mdTID"/>
                </xsl:otherwise>
              </xsl:choose>
            </gco:CharacterString>
          </mcc:code>
        </mcc:MD_Identifier>
      </mdb:metadataIdentifier>

      <!-- ── 2. Default locale ──────────────────────────────────── -->
      <mdb:defaultLocale>
        <lan:PT_Locale id="{$mainLangUPPER}">
          <lan:language>
            <lan:LanguageCode codeList="{$CL}LanguageCode"
              codeListValue="{$mainLangISO3}">
              <xsl:value-of select="$mainLangISO3"/>
            </lan:LanguageCode>
          </lan:language>
          <lan:characterEncoding>
            <lan:MD_CharacterSetCode codeList="{$CL}MD_CharacterSetCode"
              codeListValue="utf8">utf8</lan:MD_CharacterSetCode>
          </lan:characterEncoding>
        </lan:PT_Locale>
      </mdb:defaultLocale>

      <!-- ── 3. Other locales (the four Swiss national languages + EN) -->
      <xsl:for-each select="('de','fr','it','en','rm')">
        <xsl:variable name="lc" select="."/>
        <xsl:if test="$lc != $mainLangCode">
          <mdb:otherLocale>
            <lan:PT_Locale id="{upper-case($lc)}">
              <lan:language>
                <lan:LanguageCode codeList="{$CL}LanguageCode"
                  codeListValue="{ech0271:langToISO3($lc)}">
                  <xsl:value-of select="ech0271:langToISO3($lc)"/>
                </lan:LanguageCode>
              </lan:language>
              <lan:characterEncoding>
                <lan:MD_CharacterSetCode codeList="{$CL}MD_CharacterSetCode"
                  codeListValue="utf8">utf8</lan:MD_CharacterSetCode>
              </lan:characterEncoding>
            </lan:PT_Locale>
          </mdb:otherLocale>
        </xsl:if>
      </xsl:for-each>

      <!-- ── 4. Metadata scope ──────────────────────────────────── -->
      <xsl:variable name="hierarchyLevel"
        select="normalize-space(
          int:hierarchyLevel/int:eCH0271_1.eCH0271.MD_ScopeCode_[1]/int:value)"/>
      <mdb:metadataScope>
        <mdb:MD_MetadataScope>
          <mdb:resourceScope>
            <mcc:MD_ScopeCode codeList="{$CL}MD_ScopeCode"
              codeListValue="{if ($hierarchyLevel != '') then $hierarchyLevel else 'dataset'}">
              <xsl:value-of
                select="if ($hierarchyLevel != '') then $hierarchyLevel else 'dataset'"/>
            </mcc:MD_ScopeCode>
          </mdb:resourceScope>
        </mdb:MD_MetadataScope>
      </mdb:metadataScope>

      <!-- ── 5. Metadata contacts ───────────────────────────────── -->
      <!-- eCH0271 uses an association class MD_Metadatacontact to link
           MD_Metadata ↔ CI_Responsibility with a role. -->
      <xsl:for-each
        select="$basket/int:eCH0271_1.eCH0271.MD_Metadatacontact
                        [int:MD_Metadata/@REF = $mdTID]">
        <mdb:contact>
          <xsl:call-template name="ech0271:CI_Responsibility">
            <xsl:with-param name="partyTID" select="int:contact/@REF"/>
            <xsl:with-param name="roleCode"
              select="normalize-space(int:role/int:eCH0271_1.eCH0271.CI_RoleCode_[1]/int:value)"/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </mdb:contact>
      </xsl:for-each>

      <!-- ── 6. Date info ───────────────────────────────────────── -->
      <xsl:if test="normalize-space(int:dateStamp) != ''">
        <mdb:dateInfo>
          <cit:CI_Date>
            <cit:date>
              <xsl:call-template name="ech0271:outputDate">
                <xsl:with-param name="value" select="normalize-space(int:dateStamp)"/>
              </xsl:call-template>
            </cit:date>
            <cit:dateType>
              <cit:CI_DateTypeCode codeList="{$CL}CI_DateTypeCode"
                codeListValue="revision">revision</cit:CI_DateTypeCode>
            </cit:dateType>
          </cit:CI_Date>
        </mdb:dateInfo>
      </xsl:if>

      <!-- ── 7. Metadata standard ───────────────────────────────── -->
      <mdb:metadataStandard>
        <cit:CI_Citation>
          <cit:title>
            <gco:CharacterString>
              <xsl:value-of
                select="if (normalize-space(int:metadataStandardName) != '')
                        then normalize-space(int:metadataStandardName)
                        else 'ISO 19115-1:2014 / CHE profile'"/>
            </gco:CharacterString>
          </cit:title>
          <xsl:if test="normalize-space(int:metadataStandardVersion) != ''">
            <cit:edition>
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(int:metadataStandardVersion)"/>
              </gco:CharacterString>
            </cit:edition>
          </xsl:if>
        </cit:CI_Citation>
      </mdb:metadataStandard>

      <!-- ── 8. Reference systems ───────────────────────────────── -->
      <xsl:for-each
        select="$basket/int:eCH0271_1.eCH0271.referenceSystemInfoMD_Metadata
                        [int:MD_Metadata/@REF = $mdTID]">
        <xsl:variable name="rsRecord" select="key('byTID', int:referenceSystemInfo/@REF)"/>
        <xsl:if test="$rsRecord">
          <mdb:referenceSystemInfo>
            <xsl:call-template name="ech0271:MD_ReferenceSystem">
              <xsl:with-param name="rsRecord" select="$rsRecord"/>
            </xsl:call-template>
          </mdb:referenceSystemInfo>
        </xsl:if>
      </xsl:for-each>

      <!-- ── 9. Identification info ──────────────────────────────
           In eCH0271, MD_DataIdentification contains
           a back-reference child element  int:MD_Metadata/@REF  that points
           to its parent MD_Metadata record.
           Support both Core (eCH0271_1.eCH0271) and Comprehensive (eCH0271_1.Comprehensive)
           ────────────────────────────────────────────────────────── -->
      <xsl:for-each
        select="$basket/(int:eCH0271_1.eCH0271.MD_DataIdentification
                         | int:eCH0271_1.Comprehensive.MD_DataIdentification)
                        [int:MD_Metadata/@REF = $mdTID]">
        <mdb:identificationInfo>
          <xsl:call-template name="ech0271:CHE_MD_DataIdentification">
            <xsl:with-param name="basket"       select="$basket"/>
            <xsl:with-param name="mainLangCode" select="$mainLangCode"/>
          </xsl:call-template>
        </mdb:identificationInfo>
      </xsl:for-each>

      <!-- ── 10. Distribution ──────────────────────────────────── -->
      <xsl:for-each
        select="$basket/(int:eCH0271_1.eCH0271.MD_Distribution
                         | int:eCH0271_1.Comprehensive.MD_Distribution)
                        [int:MD_Metadata/@REF = $mdTID]">
        <mdb:distributionInfo>
          <xsl:call-template name="ech0271:MD_Distribution">
            <xsl:with-param name="distRecord" select="."/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </mdb:distributionInfo>
      </xsl:for-each>

      <!-- ── 11. Data quality / lineage ─────────────────────────── -->
      <xsl:for-each
        select="$basket/(int:eCH0271_1.eCH0271.DQ_DataQuality
                         | int:eCH0271_1.Comprehensive.DQ_DataQuality)
                        [int:MD_Metadata/@REF = $mdTID]">
        <xsl:variable name="dqTID" select="@TID"/>
        <mdb:dataQualityInfo>
          <mdq:DQ_DataQuality>
            <!-- scope -->
            <xsl:for-each
              select="$basket/int:eCH0271_1.eCH0271.DQ_Scope
                              [int:DQ_DataQuality/@REF = $dqTID]">
              <mdq:scope>
                <mcc:MD_Scope>
                  <mcc:level>
                    <mcc:MD_ScopeCode codeList="{$CL}MD_ScopeCode"
                      codeListValue="{normalize-space(int:level)}">
                      <xsl:value-of select="normalize-space(int:level)"/>
                    </mcc:MD_ScopeCode>
                  </mcc:level>
                </mcc:MD_Scope>
              </mdq:scope>
            </xsl:for-each>
            <!-- lineage statement -->
            <xsl:for-each
              select="$basket/int:eCH0271_1.eCH0271.LI_Lineage
                              [int:DQ_DataQuality/@REF = $dqTID]
                              [int:statement]">
              <mdq:lineage>
                <mrl:LI_Lineage>
                  <mrl:statement xsi:type="lan:PT_FreeText_PropertyType">
                    <xsl:call-template name="ech0271:PT_FreeText_content">
                      <xsl:with-param name="freeText"
                        select="int:statement/int:eCH0271_1.eCH0271.PT_FreeText"/>
                    </xsl:call-template>
                  </mrl:statement>
                </mrl:LI_Lineage>
              </mdq:lineage>
            </xsl:for-each>
          </mdq:DQ_DataQuality>
        </mdb:dataQualityInfo>
      </xsl:for-each>

    </che:CHE_MD_Metadata>
  </xsl:template>

  <!-- ================================================================
       CHE_MD_DataIdentification
       ================================================================ -->
  <xsl:template name="ech0271:CHE_MD_DataIdentification">
    <xsl:param name="basket"       as="element()"/>
    <xsl:param name="mainLangCode" as="xs:string"/>

    <xsl:variable name="diTID" select="@TID"/>

    <che:CHE_MD_DataIdentification gco:isoType="mri:MD_DataIdentification">

      <!-- citation -->
      <mri:citation>
        <xsl:call-template name="ech0271:CI_Citation">
          <xsl:with-param name="citTID" select="citation/@REF"/>
          <xsl:with-param name="basket" select="$basket"/>
        </xsl:call-template>
      </mri:citation>

      <!-- abstract -->
      <mri:abstract xsi:type="lan:PT_FreeText_PropertyType">
        <xsl:call-template name="ech0271:PT_FreeText_content">
          <xsl:with-param name="freeText"
            select="abstract/int:eCH0271_1.eCH0271.PT_FreeText | abstract/int:eCH0271_1.Comprehensive.PT_FreeText"/>
        </xsl:call-template>
      </mri:abstract>

      <!-- purpose (optional) -->
      <xsl:if test="purpose/int:eCH0271_1.eCH0271.PT_FreeText | purpose/int:eCH0271_1.Comprehensive.PT_FreeText">
        <mri:purpose xsi:type="lan:PT_FreeText_PropertyType">
          <xsl:call-template name="ech0271:PT_FreeText_content">
            <xsl:with-param name="freeText"
              select="purpose/int:eCH0271_1.eCH0271.PT_FreeText | purpose/int:eCH0271_1.Comprehensive.PT_FreeText"/>
          </xsl:call-template>
        </mri:purpose>
      </xsl:if>

      <!-- status -->
      <xsl:for-each
        select="status/int:eCH0271_1.eCH0271.MD_ProgressCode_/int:value | status/int:eCH0271_1.Comprehensive.MD_ProgressCode_/int:value">
        <mri:status>
          <mcc:MD_ProgressCode codeList="{$CL}MD_ProgressCode"
            codeListValue="{normalize-space(.)}">
            <xsl:value-of select="normalize-space(.)"/>
          </mcc:MD_ProgressCode>
        </mri:status>
      </xsl:for-each>

      <!-- point of contact (via MD_IdentificationpointOfContact association or pointOfContact element) -->
      <!-- First try direct pointOfContact element -->
      <xsl:for-each select="pointOfContact/@REF">
        <mri:pointOfContact>
          <xsl:call-template name="ech0271:CI_Responsibility">
            <xsl:with-param name="partyTID" select="."/>
            <xsl:with-param name="roleCode">pointOfContact</xsl:with-param>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </mri:pointOfContact>
      </xsl:for-each>
      <!-- Then try association class -->
      <xsl:for-each
        select="$basket/(int:eCH0271_1.eCH0271.MD_IdentificationpointOfContact
                         | int:eCH0271_1.Comprehensive.MD_IdentificationpointOfContact)
                        [int:MD_Identification/@REF = $diTID]">
        <mri:pointOfContact>
          <xsl:call-template name="ech0271:CI_Responsibility">
            <xsl:with-param name="partyTID" select="int:pointOfContact/@REF"/>
            <xsl:with-param name="roleCode"
              select="normalize-space(int:role/int:eCH0271_1.eCH0271.CI_RoleCode_[1]/int:value)"/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </mri:pointOfContact>
      </xsl:for-each>

      <!-- spatial representation type -->
      <xsl:for-each
        select="spatialRepresentationType/int:eCH0271_1.eCH0271.MD_SpatialRepresentationTypeCode_/int:value
                | spatialRepresentationType/int:eCH0271_1.Comprehensive.MD_SpatialRepresentationTypeCode_/int:value">
        <mri:spatialRepresentationType>
          <mcc:MD_SpatialRepresentationTypeCode codeList="{$CL}MD_SpatialRepresentationTypeCode"
            codeListValue="{normalize-space(.)}">
            <xsl:value-of select="normalize-space(.)"/>
          </mcc:MD_SpatialRepresentationTypeCode>
        </mri:spatialRepresentationType>
      </xsl:for-each>

      <!-- descriptive keywords (via direct keywords element or association) -->
      <!-- First try direct keywords element -->
      <xsl:for-each select="descriptiveKeywords/@REF">
        <xsl:variable name="kwRecord" select="key('byTID', .)"/>
        <xsl:if test="$kwRecord">
          <mri:descriptiveKeywords>
            <mri:MD_Keywords>
              <xsl:for-each
                select="$kwRecord/keyword/int:eCH0271_1.eCH0271.PT_FreeText | $kwRecord/keyword/int:eCH0271_1.Comprehensive.PT_FreeText">
                <mri:keyword xsi:type="lan:PT_FreeText_PropertyType">
                  <xsl:call-template name="ech0271:PT_FreeText_content">
                    <xsl:with-param name="freeText" select="."/>
                  </xsl:call-template>
                </mri:keyword>
              </xsl:for-each>
              <xsl:if test="normalize-space($kwRecord/type) != ''">
                <mri:type>
                  <mri:MD_KeywordTypeCode codeList="{$CL}MD_KeywordTypeCode"
                    codeListValue="{normalize-space($kwRecord/type)}">
                    <xsl:value-of select="normalize-space($kwRecord/type)"/>
                  </mri:MD_KeywordTypeCode>
                </mri:type>
              </xsl:if>
              <xsl:if test="$kwRecord/thesaurus/@REF">
                <xsl:variable name="thesRecord"
                  select="key('byTID', $kwRecord/thesaurus/@REF)"/>
                <xsl:if test="$thesRecord">
                  <mri:thesaurusName>
                    <xsl:call-template name="ech0271:CI_Citation">
                      <xsl:with-param name="citTID"
                        select="$thesRecord/citation/@REF"/>
                      <xsl:with-param name="basket" select="$basket"/>
                    </xsl:call-template>
                  </mri:thesaurusName>
                </xsl:if>
              </xsl:if>
            </mri:MD_Keywords>
          </mri:descriptiveKeywords>
        </xsl:if>
      </xsl:for-each>
      <!-- Then try association class -->
      <xsl:for-each
        select="$basket/(int:eCH0271_1.eCH0271.descriptiveKeywordsMD_Identification
                         | int:eCH0271_1.Comprehensive.descriptiveKeywordsMD_Identification)
                        [int:MD_Identification/@REF = $diTID]">
        <xsl:variable name="kwRecord" select="key('byTID', int:descriptiveKeywords/@REF)"/>
        <xsl:if test="$kwRecord">
          <mri:descriptiveKeywords>
            <mri:MD_Keywords>
              <xsl:for-each
                select="$kwRecord/keyword/int:eCH0271_1.eCH0271.PT_FreeText">
                <mri:keyword xsi:type="lan:PT_FreeText_PropertyType">
                  <xsl:call-template name="ech0271:PT_FreeText_content">
                    <xsl:with-param name="freeText" select="."/>
                  </xsl:call-template>
                </mri:keyword>
              </xsl:for-each>
              <xsl:if test="normalize-space($kwRecord/int:type) != ''">
                <mri:type>
                  <mri:MD_KeywordTypeCode codeList="{$CL}MD_KeywordTypeCode"
                    codeListValue="{normalize-space($kwRecord/int:type)}">
                    <xsl:value-of select="normalize-space($kwRecord/int:type)"/>
                  </mri:MD_KeywordTypeCode>
                </mri:type>
              </xsl:if>
              <xsl:if test="$kwRecord/int:thesaurus/@REF">
                <xsl:variable name="thesRecord"
                  select="key('byTID', $kwRecord/int:thesaurus/@REF)"/>
                <xsl:if test="$thesRecord">
                  <mri:thesaurusName>
                    <xsl:call-template name="ech0271:CI_Citation">
                      <xsl:with-param name="citTID"
                        select="$thesRecord/int:citation/@REF"/>
                      <xsl:with-param name="basket" select="$basket"/>
                    </xsl:call-template>
                  </mri:thesaurusName>
                </xsl:if>
              </xsl:if>
            </mri:MD_Keywords>
          </mri:descriptiveKeywords>
        </xsl:if>
      </xsl:for-each>

      <!-- default / other locale for the resource -->
      <xsl:variable name="resourceLangs"
        select="language/int:CodeISO.LanguageCodeISO_/int:value"/>
      <xsl:for-each select="$resourceLangs">
        <xsl:variable name="lc" select="normalize-space(.)"/>
        <xsl:choose>
          <xsl:when test="position() = 1">
            <mri:defaultLocale>
              <lan:PT_Locale id="{upper-case($lc)}">
                <lan:language>
                  <lan:LanguageCode codeList="{$CL}LanguageCode"
                    codeListValue="{ech0271:langToISO3($lc)}">
                    <xsl:value-of select="ech0271:langToISO3($lc)"/>
                  </lan:LanguageCode>
                </lan:language>
                <lan:characterEncoding>
                  <lan:MD_CharacterSetCode codeList="{$CL}MD_CharacterSetCode"
                    codeListValue="utf8">utf8</lan:MD_CharacterSetCode>
                </lan:characterEncoding>
              </lan:PT_Locale>
            </mri:defaultLocale>
          </xsl:when>
          <xsl:otherwise>
            <mri:otherLocale>
              <lan:PT_Locale id="{upper-case($lc)}">
                <lan:language>
                  <lan:LanguageCode codeList="{$CL}LanguageCode"
                    codeListValue="{ech0271:langToISO3($lc)}">
                    <xsl:value-of select="ech0271:langToISO3($lc)"/>
                  </lan:LanguageCode>
                </lan:language>
                <lan:characterEncoding>
                  <lan:MD_CharacterSetCode codeList="{$CL}MD_CharacterSetCode"
                    codeListValue="utf8">utf8</lan:MD_CharacterSetCode>
                </lan:characterEncoding>
              </lan:PT_Locale>
            </mri:otherLocale>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <!-- topic category -->
      <xsl:for-each
        select="topicCategory/int:eCH0271_1.eCH0271.MD_TopicCategoryCode_/int:value | topicCategory/int:eCH0271_1.Comprehensive.MD_TopicCategoryCode_/int:value">
        <mri:topicCategory>
          <!-- GM03_2_1 uses extended codes like
               'environment.environment_NatureProtection' — strip the subcode
               suffix to produce a valid ISO 19115 topicCategory code. -->
          <mri:MD_TopicCategoryCode>
            <xsl:variable name="raw" select="normalize-space(.)"/>
            <xsl:value-of
              select="if (contains($raw, '.')) then substring-before($raw, '.') else $raw"/>
          </mri:MD_TopicCategoryCode>
        </mri:topicCategory>
      </xsl:for-each>

      <!-- extent (via direct extent element or back-reference) -->
      <!-- First try direct extent element -->
      <xsl:for-each select="extent/@REF">
        <xsl:variable name="extRecord" select="key('byTID', .)"/>
        <xsl:if test="$extRecord">
          <mri:extent>
            <xsl:call-template name="ech0271:EX_Extent">
              <xsl:with-param name="extRecord" select="$extRecord"/>
              <xsl:with-param name="basket" select="$basket"/>
            </xsl:call-template>
          </mri:extent>
        </xsl:if>
      </xsl:for-each>
      <!-- Then try back-reference from EX_Extent -->
      <xsl:for-each
        select="$basket/(int:eCH0271_1.eCH0271.EX_Extent | int:eCH0271_1.Comprehensive.EX_Extent)
                        [int:MD_DataIdentification/@REF = $diTID or int:eCH0271_1.Comprehensive.MD_DataIdentification/@REF = $diTID]">
        <mri:extent>
          <xsl:call-template name="ech0271:EX_Extent">
            <xsl:with-param name="extRecord" select="."/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </mri:extent>
      </xsl:for-each>

      <!-- resource constraints — legal framework (CHE_MD_Legislation) -->
      <!-- First try direct resourceConstraints element -->
      <xsl:for-each select="resourceConstraints/@REF">
        <xsl:variable name="legisRecord" select="key('byTID', .)"/>
        <xsl:if test="$legisRecord">
          <mri:resourceConstraints>
            <xsl:call-template name="ech0271:CHE_MD_Legislation">
              <xsl:with-param name="legisRecord" select="$legisRecord"/>
              <xsl:with-param name="basket" select="$basket"/>
            </xsl:call-template>
          </mri:resourceConstraints>
        </xsl:if>
      </xsl:for-each>

      <!-- maintenance and update information -->
      <xsl:for-each
        select="$basket/(int:eCH0271_1.eCH0271.MD_MaintenanceInformation
                         | int:eCH0271_1.Comprehensive.MD_MaintenanceInformation)
                        [int:MD_Identification/@REF = $diTID]">
        <mdb:resourceMaintenanceInfo>
          <xsl:call-template name="ech0271:MD_MaintenanceInformation">
            <xsl:with-param name="maintRecord" select="."/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </mdb:resourceMaintenanceInfo>
      </xsl:for-each>

    </che:CHE_MD_DataIdentification>
  </xsl:template>

  <!-- ================================================================
       CI_Citation
       ================================================================ -->
  <xsl:template name="ech0271:CI_Citation">
    <xsl:param name="citTID" as="xs:string?"/>
    <xsl:param name="basket"  as="element()"/>

    <xsl:variable name="citRecord" select="key('byTID', $citTID)"/>

    <cit:CI_Citation>
      <cit:title xsi:type="lan:PT_FreeText_PropertyType">
        <xsl:choose>
          <xsl:when test="$citRecord/title/int:eCH0271_1.eCH0271.PT_FreeText | $citRecord/title/int:eCH0271_1.Comprehensive.PT_FreeText">
            <xsl:call-template name="ech0271:PT_FreeText_content">
              <xsl:with-param name="freeText"
                select="$citRecord/title/int:eCH0271_1.eCH0271.PT_FreeText | $citRecord/title/int:eCH0271_1.Comprehensive.PT_FreeText"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <gco:CharacterString/>
          </xsl:otherwise>
        </xsl:choose>
      </cit:title>

      <!-- Dates linked to this citation via CI_Date back-reference -->
      <xsl:for-each
        select="$basket/(int:eCH0271_1.eCH0271.CI_Date | int:eCH0271_1.Comprehensive.CI_Date)
                        [int:CI_Citation/@REF = $citTID]">
        <cit:date>
          <cit:CI_Date>
            <cit:date>
              <xsl:call-template name="ech0271:outputDate">
                <xsl:with-param name="value" select="normalize-space(date)"/>
              </xsl:call-template>
            </cit:date>
            <cit:dateType>
              <cit:CI_DateTypeCode codeList="{$CL}CI_DateTypeCode"
                codeListValue="{normalize-space(dateType)}">
                <xsl:value-of select="normalize-space(dateType)"/>
              </cit:CI_DateTypeCode>
            </cit:dateType>
          </cit:CI_Date>
        </cit:date>
      </xsl:for-each>

      <!-- Edition (Comprehensive only) -->
      <xsl:if test="normalize-space($citRecord/edition) != ''">
        <cit:edition>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space($citRecord/edition)"/>
          </gco:CharacterString>
        </cit:edition>
      </xsl:if>
    </cit:CI_Citation>
  </xsl:template>

  <!-- ================================================================
       CI_Responsibility (wraps a GM03 CI_ResponsibleParty with a role)
       ================================================================ -->
  <xsl:template name="ech0271:CI_Responsibility">
    <xsl:param name="partyTID" as="xs:string?"/>
    <xsl:param name="roleCode"  as="xs:string"/>
    <xsl:param name="basket"    as="element()"/>

    <xsl:variable name="party" select="key('byTID', $partyTID)"/>

    <cit:CI_Responsibility>
      <cit:role>
        <cit:CI_RoleCode codeList="{$CL}CI_RoleCode"
          codeListValue="{if (normalize-space($roleCode) != '')
                         then $roleCode else 'pointOfContact'}">
          <xsl:value-of
            select="if (normalize-space($roleCode) != '')
                    then $roleCode else 'pointOfContact'"/>
        </cit:CI_RoleCode>
      </cit:role>
      <xsl:if test="$party">
        <cit:party>
          <xsl:call-template name="ech0271:CI_Party">
            <xsl:with-param name="party"  select="$party"/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </cit:party>
      </xsl:if>
    </cit:CI_Responsibility>
  </xsl:template>

  <!-- ================================================================
       CI_Organisation / CI_Individual
       (from a GM03 CI_ResponsibleParty element)
       ================================================================ -->
  <xsl:template name="ech0271:CI_Party">
    <xsl:param name="party"  as="element()"/>
    <xsl:param name="basket" as="element()"/>

    <xsl:variable name="hasOrg"
      select="exists($party/int:organisationName)"/>
    <xsl:variable name="hasIndividual"
      select="normalize-space($party/int:individualFirstName) != ''
              or normalize-space($party/int:individualLastName) != ''"/>

    <xsl:choose>
      <xsl:when test="$hasOrg">
        <che:CHE_CI_Organisation gco:isoType="cit:CI_Organisation">
          <cit:name xsi:type="lan:PT_FreeText_PropertyType">
            <xsl:call-template name="ech0271:PT_FreeText_content">
              <xsl:with-param name="freeText"
                select="$party/int:organisationName/int:eCH0271_1.eCH0271.PT_FreeText"/>
            </xsl:call-template>
          </cit:name>
          <xsl:call-template name="ech0271:contactInfo">
            <xsl:with-param name="party"  select="$party"/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
          <xsl:if test="$hasIndividual">
            <che:individualMember>
              <cit:CI_Individual>
                <cit:name>
                  <gco:CharacterString>
                    <xsl:value-of
                      select="normalize-space(concat(
                        $party/int:individualFirstName, ' ',
                        $party/int:individualLastName))"/>
                  </gco:CharacterString>
                </cit:name>
              </cit:CI_Individual>
            </che:individualMember>
          </xsl:if>
        </che:CHE_CI_Organisation>
      </xsl:when>
      <xsl:otherwise>
        <cit:CI_Individual>
          <cit:name>
            <gco:CharacterString>
              <xsl:value-of
                select="normalize-space(concat(
                  $party/int:individualFirstName, ' ',
                  $party/int:individualLastName))"/>
            </gco:CharacterString>
          </cit:name>
          <xsl:call-template name="ech0271:contactInfo">
            <xsl:with-param name="party"  select="$party"/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </cit:CI_Individual>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================
       Contact info (phone, address, email, online resource)
       ================================================================ -->
  <xsl:template name="ech0271:contactInfo">
    <xsl:param name="party"  as="element()"/>
    <xsl:param name="basket" as="element()"/>

    <xsl:variable name="addressRecord"
      select="key('byTID', $party/int:address/@REF)"/>
    <!-- Telephones reference back to CI_ResponsibleParty via CI_Telephone/CI_ResponsibleParty/@REF -->
    <xsl:variable name="phoneRecords"
      select="$basket/int:eCH0271_1.eCH0271.CI_Telephone
                      [int:CI_ResponsibleParty/@REF = $party/@TID]"/>

    <xsl:if test="$addressRecord or $phoneRecords
                  or $party/int:electronicalMailAddress
                  or $party/int:linkage">
      <cit:contactInfo>
        <cit:CI_Contact>
          <!-- phones -->
          <xsl:for-each select="$phoneRecords">
            <cit:phone>
              <cit:CI_Telephone>
                <cit:number>
                  <gco:CharacterString>
                    <xsl:value-of select="normalize-space(int:number)"/>
                  </gco:CharacterString>
                </cit:number>
                <cit:numberType>
                  <cit:CI_TelephoneTypeCode codeList="{$CL}CI_TelephoneTypeCode"
                    codeListValue="{normalize-space(int:numberType)}">
                    <xsl:value-of select="normalize-space(int:numberType)"/>
                  </cit:CI_TelephoneTypeCode>
                </cit:numberType>
              </cit:CI_Telephone>
            </cit:phone>
          </xsl:for-each>
          <!-- address + email -->
          <xsl:if test="$addressRecord or $party/int:electronicalMailAddress">
            <cit:address>
              <cit:CI_Address>
                <xsl:if test="$addressRecord">
                  <xsl:variable name="delivery"
                    select="normalize-space(string-join((
                      normalize-space($addressRecord/int:addressLine),
                      normalize-space(concat($addressRecord/int:streetName,' ',
                                             $addressRecord/int:streetNumber))),' '))"/>
                  <xsl:if test="$delivery != ''">
                    <cit:deliveryPoint>
                      <gco:CharacterString><xsl:value-of select="$delivery"/></gco:CharacterString>
                    </cit:deliveryPoint>
                  </xsl:if>
                  <xsl:if test="normalize-space($addressRecord/int:city) != ''">
                    <cit:city>
                      <gco:CharacterString>
                        <xsl:value-of select="normalize-space($addressRecord/int:city)"/>
                      </gco:CharacterString>
                    </cit:city>
                  </xsl:if>
                  <xsl:if test="normalize-space($addressRecord/int:postalCode) != ''">
                    <cit:postalCode>
                      <gco:CharacterString>
                        <xsl:value-of select="normalize-space($addressRecord/int:postalCode)"/>
                      </gco:CharacterString>
                    </cit:postalCode>
                  </xsl:if>
                  <xsl:if test="normalize-space($addressRecord/int:country) != ''">
                    <cit:country>
                      <gco:CharacterString>
                        <xsl:value-of select="normalize-space($addressRecord/int:country)"/>
                      </gco:CharacterString>
                    </cit:country>
                  </xsl:if>
                </xsl:if>
                <xsl:for-each
                  select="$party/int:electronicalMailAddress
                                  /int:eCH0271_1.eCH0271.URL_/int:value">
                  <cit:electronicMailAddress>
                    <gco:CharacterString>
                      <xsl:value-of select="normalize-space(.)"/>
                    </gco:CharacterString>
                  </cit:electronicMailAddress>
                </xsl:for-each>
              </cit:CI_Address>
            </cit:address>
          </xsl:if>
          <!-- online resource (first URL of the linkage PT_FreeURL) -->
          <xsl:for-each
            select="($party/int:linkage/int:eCH0271_1.eCH0271.PT_FreeURL
                            /int:URLGroup/int:eCH0271_1.eCH0271.PT_URLGroup/int:plainURL)[1]">
            <cit:onlineResource>
              <cit:CI_OnlineResource>
                <cit:linkage>
                  <gco:CharacterString>
                    <xsl:value-of select="normalize-space(.)"/>
                  </gco:CharacterString>
                </cit:linkage>
              </cit:CI_OnlineResource>
            </cit:onlineResource>
          </xsl:for-each>
        </cit:CI_Contact>
      </cit:contactInfo>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       Reference System
       ================================================================ -->
  <xsl:template name="ech0271:MD_ReferenceSystem">
    <xsl:param name="rsRecord" as="element()"/>

    <mrs:MD_ReferenceSystem>
      <xsl:if test="$rsRecord/int:referenceSystemIdentifier/@REF">
        <xsl:variable name="idRecord"
          select="key('byTID', $rsRecord/int:referenceSystemIdentifier/@REF)"/>
        <xsl:if test="$idRecord">
          <mrs:referenceSystemIdentifier>
            <mcc:MD_Identifier>
              <mcc:code xsi:type="lan:PT_FreeText_PropertyType">
                <xsl:call-template name="ech0271:PT_FreeText_content">
                  <xsl:with-param name="freeText"
                    select="$idRecord/int:code/int:eCH0271_1.eCH0271.PT_FreeText"/>
                </xsl:call-template>
              </mcc:code>
              <xsl:if test="normalize-space($idRecord/int:codeSpace) != ''">
                <mcc:codeSpace>
                  <gco:CharacterString>
                    <xsl:value-of select="normalize-space($idRecord/int:codeSpace)"/>
                  </gco:CharacterString>
                </mcc:codeSpace>
              </xsl:if>
            </mcc:MD_Identifier>
          </mrs:referenceSystemIdentifier>
        </xsl:if>
      </xsl:if>
    </mrs:MD_ReferenceSystem>
  </xsl:template>

  <!-- ================================================================
       Geographic bounding box
       ================================================================ -->
  <xsl:template match="int:eCH0271_1.eCH0271.EX_GeographicBoundingBox">
    <gex:EX_GeographicBoundingBox>
      <gex:westBoundLongitude>
        <gco:Decimal>
          <xsl:value-of select="normalize-space(int:westBoundLongitude)"/>
        </gco:Decimal>
      </gex:westBoundLongitude>
      <gex:eastBoundLongitude>
        <gco:Decimal>
          <xsl:value-of select="normalize-space(int:eastBoundLongitude)"/>
        </gco:Decimal>
      </gex:eastBoundLongitude>
      <gex:southBoundLatitude>
        <gco:Decimal>
          <xsl:value-of select="normalize-space(int:southBoundLatitude)"/>
        </gco:Decimal>
      </gex:southBoundLatitude>
      <gex:northBoundLatitude>
        <gco:Decimal>
          <xsl:value-of select="normalize-space(int:northBoundLatitude)"/>
        </gco:Decimal>
      </gex:northBoundLatitude>
    </gex:EX_GeographicBoundingBox>
  </xsl:template>

  <!-- ================================================================
       Temporal primitive (period or instant)
       ================================================================ -->
  <xsl:template match="int:eCH0271_1.eCH0271.TM_Primitive">
    <xsl:variable name="begin" select="normalize-space(int:begin)"/>
    <xsl:variable name="end"   select="normalize-space(int:end)"/>
    <xsl:choose>
      <xsl:when test="$end != ''">
        <gml:TimePeriod gml:id="tp-{generate-id(.)}">
          <gml:beginPosition>
            <xsl:value-of select="ech0271:normalizeDate($begin)"/>
          </gml:beginPosition>
          <gml:endPosition>
            <xsl:value-of select="ech0271:normalizeDate($end)"/>
          </gml:endPosition>
        </gml:TimePeriod>
      </xsl:when>
      <xsl:otherwise>
        <gml:TimeInstant gml:id="ti-{generate-id(.)}">
          <gml:timePosition>
            <xsl:value-of select="ech0271:normalizeDate($begin)"/>
          </gml:timePosition>
        </gml:TimeInstant>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================
       Multilingual text
       Outputs gco:CharacterString (first group) + optional lan:PT_FreeText
       ================================================================ -->
  <xsl:template name="ech0271:PT_FreeText_content">
    <xsl:param name="freeText" as="element()?"/>
    <xsl:variable name="groups"
      select="$freeText/textGroup/int:eCH0271_1.eCH0271.PT_Group | $freeText/textGroup/int:eCH0271_1.Comprehensive.PT_Group"/>
    <gco:CharacterString>
      <xsl:value-of select="normalize-space($groups[1]/plainText)"/>
    </gco:CharacterString>
    <xsl:if test="count($groups) > 1">
      <lan:PT_FreeText>
        <xsl:for-each select="$groups">
          <lan:textGroup>
            <lan:LocalisedCharacterString locale="#{upper-case(normalize-space(language))}">
              <xsl:value-of select="normalize-space(plainText)"/>
            </lan:LocalisedCharacterString>
          </lan:textGroup>
        </xsl:for-each>
      </lan:PT_FreeText>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       Date output helper
       ================================================================ -->
  <xsl:template name="ech0271:outputDate">
    <xsl:param name="value" as="xs:string"/>
    <xsl:variable name="n" select="ech0271:normalizeDate($value)"/>
    <xsl:choose>
      <xsl:when test="string-length($n) > 10">
        <gco:DateTime><xsl:value-of select="$n"/></gco:DateTime>
      </xsl:when>
      <xsl:otherwise>
        <gco:Date><xsl:value-of select="$n"/></gco:Date>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================
       Function: 2-letter language code → ISO 639-2/T 3-letter code
       ================================================================ -->
  <xsl:function name="ech0271:langToISO3" as="xs:string">
    <xsl:param name="lang" as="xs:string"/>
    <xsl:sequence select="
      if ($lang = 'de') then 'ger'
      else if ($lang = 'fr') then 'fre'
      else if ($lang = 'it') then 'ita'
      else if ($lang = 'en') then 'eng'
      else if ($lang = 'rm') then 'roh'
      else $lang"/>
  </xsl:function>

  <!-- ================================================================
       Function: normalize a GM03 date value to ISO 8601
       GM03 dates may use ':' instead of '-' as separator.
       ================================================================ -->
  <xsl:function name="ech0271:normalizeDate" as="xs:string">
    <xsl:param name="d" as="xs:string"/>
    <xsl:variable name="s" select="normalize-space($d)"/>
    <xsl:sequence select="
      if (string-length($s) = 0) then ''
      else if (string-length($s) le 10) then translate($s, ':', '-')
      else concat(translate(substring($s, 1, 10), ':', '-'), 'T', substring($s, 12))"/>
  </xsl:function>

  <!-- ================================================================
       Suppress unmatched nodes (default XSLT 2.0 behaviour would copy text)
       ================================================================ -->
  <xsl:template match="text()|@*" priority="-10"/>

</xsl:stylesheet>
