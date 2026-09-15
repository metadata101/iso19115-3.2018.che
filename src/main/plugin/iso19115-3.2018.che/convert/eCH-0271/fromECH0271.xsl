<?xml version="1.0" encoding="UTF-8"?>
<!--
  Direct converter: eCH0271 XTF 2.4 INTERLIS → ISO 19115-3:2018 (CHE profile)

  Adapted for XTF 2.4 format (modern ili2pg output).

  XSLT 2.0 — no Java extension functions required.
  Compatible with Saxon HE 9.1+.

  The eCH0271 XTF 2.4 transfer format stores all objects flat
  inside a "basket" element, linked together by @ili:tid / @ili:ref
  identity references. This stylesheet resolves those references
  using XSLT 2.0 key() functions.

  Handles eCH0271_1.eCH0271 baskets with proper XTF 2.4 namespace.

  Usage from Java:
      TransformerFactory tf = TransformerFactoryFactory.getTransformerFactory(); // Saxon
      Transformer t  = tf.newTransformer(new StreamSource(path/to/eCH-0271/fromECH0271_XTF24.xsl));
      t.transform(new StreamSource(ech0271Xtf24Input), new StreamResult(output));
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:ili  ="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:LocalisationCH_V2="http://www.interlis.ch/xtf/2.4/LocalisationCH_V2"
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
       NOTE: Modular mapping files (distribution.xsl, extent.xsl, etc.)
       are written for INTERLIS 2.3 and not compatible with XTF 2.4.
       They are temporarily disabled until adapted for the new format.
       ================================================================ -->
  <!-- xsl:include href="mapping/distribution.xsl"/ -->
  <!-- xsl:include href="mapping/extent.xsl"/ -->
  <!-- xsl:include href="mapping/legislation.xsl"/ -->
  <!-- xsl:include href="mapping/maintenance-info.xsl"/ -->

  <!-- ================================================================
       Parameters
       ================================================================ -->
  <!-- Optional UUID override for the metadata identifier. -->
  <xsl:param name="uuid" as="xs:string?"/>

  <!-- ================================================================
       Keys — resolve any @ili:ref → the object with matching @ili:tid
       ================================================================ -->
  <xsl:key name="byTID"
    match="/ili:transfer/ili:datasection/eCH0271_1:eCH0271//*[@ili:tid]"
    use="@ili:tid"/>

  <!-- Key to find CHE_MD_DataIdentification by its MD_Metadata reference -->
  <xsl:key name="dataIdentByMetadataRef"
    match="//eCH0271_1:CHE_MD_DataIdentification"
    use="eCH0271_1:MD_Metadata/@ili:ref"/>

  <!-- ================================================================
       Shared constant
       ================================================================ -->
  <xsl:variable name="CL"
    select="'https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#'"/>

  <!-- ================================================================
       Entry point — find the first MD_Metadata record (XTF 2.4)
       ================================================================ -->
  <xsl:template match="/">
    <!-- Locate the eCH0271_1.eCH0271 basket (XTF 2.4 format). -->
    <xsl:variable name="basket"
      select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271[1]"/>

    <xsl:if test="not($basket)">
      <xsl:message terminate="yes">
        ERROR: No eCH0271_1:eCH0271 basket found in XTF 2.4 format.
      </xsl:message>
    </xsl:if>

    <xsl:variable name="mdRecords"
      select="$basket/eCH0271_1:CHE_MD_Metadata"/>

    <xsl:if test="not($mdRecords)">
      <xsl:message terminate="yes">
        ERROR: No eCH0271_1:CHE_MD_Metadata records found in the basket.
      </xsl:message>
    </xsl:if>

    <!-- Wrap all CHE_MD_Metadata records in a container element for valid XML output. -->
    <!-- When processing single metadata, only one will be present. -->
    <!-- When processing batches (43+ records), all are converted. -->
    <xsl:choose>
      <xsl:when test="count($mdRecords) = 1">
        <!-- Single record: output it directly as CHE_MD_Metadata. -->
        <xsl:apply-templates select="$mdRecords[1]" mode="md-metadata"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Multiple records: wrap in a synthetic container for valid XML. -->
        <!-- Note: This container will need post-processing in consumers. -->
        <che:CHE_MD_MetadataCollection>
          <xsl:apply-templates select="$mdRecords" mode="md-metadata"/>
        </che:CHE_MD_MetadataCollection>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================
       md-metadata: CHE_MD_Metadata → che:CHE_MD_Metadata
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_MD_Metadata" mode="md-metadata">
    <xsl:variable name="mdTID" select="@ili:tid"/>
    <che:CHE_MD_Metadata>
      <!-- metadata identifier -->
      <xsl:apply-templates select="eCH0271_1:metadataIdentifier" mode="identifier"/>

      <!-- default locale -->
      <xsl:if test="eCH0271_1:defaultLocale">
        <xsl:apply-templates select="eCH0271_1:defaultLocale/eCH0271_1:PT_Locale" mode="locale"/>
      </xsl:if>

      <!-- date info (creation, publication) -->
      <xsl:if test="eCH0271_1:dateInfo">
        <xsl:apply-templates select="eCH0271_1:dateInfo/eCH0271_1:CI_Date" mode="date-info"/>
      </xsl:if>

      <!-- contact (responsibility) — if present in future versions -->
      <xsl:if test="eCH0271_1:pointOfContact">
        <xsl:apply-templates select="eCH0271_1:pointOfContact" mode="contact"/>
      </xsl:if>

      <!-- data identification: find CHE_MD_DataIdentification that references this metadata -->
      <!-- Direct XPath: find any CHE_MD_DataIdentification where MD_Metadata/@ili:ref == this @ili:tid -->
      <xsl:variable name="dataIdentifications" 
        select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:CHE_MD_DataIdentification[eCH0271_1:MD_Metadata/@ili:ref = $mdTID]"/>
      <xsl:apply-templates select="$dataIdentifications" mode="data-id"/>
    </che:CHE_MD_Metadata>
  </xsl:template>

  <!-- ================================================================
       metadataIdentifier: resolve @ili:ref and build mdb:metadataIdentifier
       ================================================================ -->
  <xsl:template match="eCH0271_1:metadataIdentifier[@ili:ref]" mode="identifier">
    <xsl:variable name="id" select="@ili:ref"/>
    <xsl:variable name="idObj" select="key('byTID', $id)"/>

    <xsl:if test="$idObj/self::eCH0271_1:MD_Identifier">
      <mdb:metadataIdentifier>
        <mcc:MD_Identifier>
          <mcc:code>
            <xsl:choose>
              <xsl:when test="$idObj/eCH0271_1:code">
                <xsl:apply-templates select="$idObj/eCH0271_1:code" mode="multilingual-text"/>
              </xsl:when>
              <xsl:otherwise>
                <gco:CharacterString>
                  <xsl:value-of select="$id"/>
                </gco:CharacterString>
              </xsl:otherwise>
            </xsl:choose>
          </mcc:code>
        </mcc:MD_Identifier>
      </mdb:metadataIdentifier>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       defaultLocale: PT_Locale → mdb:defaultLocale
       ================================================================ -->
  <xsl:template match="eCH0271_1:PT_Locale" mode="locale">
    <mdb:defaultLocale>
      <lan:PT_Locale>
        <lan:language>
          <lan:LanguageCode>
            <xsl:value-of select="eCH0271_1:language"/>
          </lan:LanguageCode>
        </lan:language>
        <xsl:if test="eCH0271_1:characterEncoding">
          <lan:characterEncoding>
            <lan:MD_CharacterSetCode>
              <xsl:value-of select="eCH0271_1:characterEncoding"/>
            </lan:MD_CharacterSetCode>
          </lan:characterEncoding>
        </xsl:if>
      </lan:PT_Locale>
    </mdb:defaultLocale>
  </xsl:template>

  <!-- ================================================================
       dateInfo: CI_Date → mdb:dateInfo
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Date" mode="date-info">
    <mdb:dateInfo>
      <cit:CI_Date>
        <cit:date>
          <xsl:value-of select="eCH0271_1:date"/>
        </cit:date>
        <xsl:if test="eCH0271_1:dateType">
          <cit:dateType>
            <cit:CI_DateTypeCode>
              <xsl:value-of select="eCH0271_1:dateType"/>
            </cit:CI_DateTypeCode>
          </cit:dateType>
        </xsl:if>
      </cit:CI_Date>
    </mdb:dateInfo>
  </xsl:template>

  <!-- ================================================================
       pointOfContact: resolve @ili:ref → CI_Responsibility
       ================================================================ -->
  <xsl:template match="eCH0271_1:pointOfContact[@ili:ref]" mode="contact">
    <xsl:variable name="respId" select="@ili:ref"/>
    <xsl:variable name="respObj" select="key('byTID', $respId)"/>

    <xsl:if test="$respObj/self::eCH0271_1:CI_Responsibility">
      <mdb:contact>
        <cit:CI_Responsibility>
          <cit:role>
            <cit:CI_RoleCode>
              <xsl:value-of select="$respObj/eCH0271_1:role"/>
            </cit:CI_RoleCode>
          </cit:role>
          <!-- party, party.name, contact info, etc. — expand as needed -->
        </cit:CI_Responsibility>
      </mdb:contact>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       CHE_MD_DataIdentification: title, abstract, keywords (future)
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_MD_DataIdentification" mode="data-id">
    <mdb:identificationInfo>
      <mri:MD_DataIdentification>
        <xsl:if test="eCH0271_1:citation">
          <mri:citation>
            <xsl:apply-templates select="eCH0271_1:citation" mode="citation"/>
          </mri:citation>
        </xsl:if>
        
        <!-- Abstract — multilingual text (Localisation_V2:MultilingualMText) -->
        <xsl:if test="eCH0271_1:abstract">
          <mri:abstract>
            <xsl:apply-templates select="eCH0271_1:abstract" mode="multilingual-text"/>
          </mri:abstract>
        </xsl:if>
        
        <!-- TODO: keywords, extent, etc. -->
      </mri:MD_DataIdentification>
    </mdb:identificationInfo>
  </xsl:template>

  <!-- ================================================================
       citation: CI_Citation
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Citation" mode="citation">
    <cit:CI_Citation>
      <xsl:if test="eCH0271_1:title">
        <cit:title>
          <xsl:apply-templates select="eCH0271_1:title" mode="multilingual-text"/>
        </cit:title>
      </xsl:if>
    </cit:CI_Citation>
  </xsl:template>

  <!-- ================================================================
       Multilingual text: MultilingualMText → gco:CharacterString or lan:PT_FreeText
       ================================================================ -->
  <xsl:template match="*" mode="multilingual-text">
    <xsl:choose>
      <xsl:when test="Localisation_V2:MultilingualMText | LocalisationCH_V2:MultilingualMText">
        <!-- Has multi-language content -->
        <xsl:variable name="primary"
          select="(Localisation_V2:MultilingualMText/Localisation_V2:LocalisedText[1] |
                   LocalisationCH_V2:MultilingualMText/LocalisationCH_V2:LocalisedText[1])/
                  (Localisation_V2:LocalisedMText/Localisation_V2:Text |
                   LocalisationCH_V2:LocalisedMText/LocalisationCH_V2:Text)"/>
        <gco:CharacterString>
          <xsl:value-of select="$primary[1]"/>
        </gco:CharacterString>
        <!-- TODO: Add lan:PT_FreeText for additional languages -->
      </xsl:when>
      <xsl:otherwise>
        <!-- Plain text -->
        <gco:CharacterString>
          <xsl:value-of select="."/>
        </gco:CharacterString>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================
       Placeholder: import mapping includes as needed
       ================================================================ -->
  <!-- distribution.xsl, extent.xsl, etc. will inherit this context -->

</xsl:stylesheet>
