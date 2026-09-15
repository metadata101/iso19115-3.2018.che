<?xml version="1.0" encoding="UTF-8"?>
<!--
  eCH0271 → ISO 19115-3:2018 (CHE) — Distribution mapping
  Covers: MD_Distribution, MD_DigitalTransferOptions, CI_OnlineResource,
          MD_Format, MD_Distributor, MD_Medium.
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:ech0271 ="urn:ech0271-functions"
  xmlns:cit  ="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:lan  ="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mcc  ="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mrd  ="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       MD_Distribution
       Called from the main stylesheet when MD_Metadata/distributionInfo
       references an MD_Distribution record.
       ================================================================ -->
  <xsl:template name="ech0271:MD_Distribution">
    <xsl:param name="distRecord" as="element()"/>
    <xsl:param name="basket"     as="element()"/>

    <mrd:MD_Distribution>

      <!-- distributionFormat (via MD_DistributiondistributionFormat) -->
      <xsl:for-each
        select="$basket/eCH0271_1:eCH0271_1.eCH0271.MD_DistributiondistributionFormat
                        [eCH0271_1:MD_Distribution/@REF = $distRecord/@TID]">
        <xsl:variable name="fmtRecord" select="key('byTID', eCH0271_1:distributionFormat/@REF)"/>
        <xsl:if test="$fmtRecord">
          <mrd:distributionFormat>
            <xsl:call-template name="ech0271:MD_Format">
              <xsl:with-param name="fmtRecord" select="$fmtRecord"/>
            </xsl:call-template>
          </mrd:distributionFormat>
        </xsl:if>
      </xsl:for-each>

      <!-- transferOptions via MD_DigitalTransferOptions -->
      <xsl:for-each
        select="$basket/(eCH0271_1:eCH0271_1.eCH0271.MD_DigitalTransferOptions
                        |eCH0271_1:eCH0271_1.eCH0271.MD_DigitalTransferOptions)
                        [eCH0271_1:MD_Distribution/@REF = $distRecord/@TID]">
        <mrd:transferOptions>
          <xsl:call-template name="ech0271:MD_DigitalTransferOptions">
            <xsl:with-param name="dtoRecord" select="."/>
            <xsl:with-param name="basket"    select="$basket"/>
          </xsl:call-template>
        </mrd:transferOptions>
      </xsl:for-each>

    </mrd:MD_Distribution>
  </xsl:template>

  <!-- ================================================================
       MD_DigitalTransferOptions
       ================================================================ -->
  <xsl:template name="ech0271:MD_DigitalTransferOptions">
    <xsl:param name="dtoRecord" as="element()"/>
    <xsl:param name="basket"    as="element()"/>

    <mrd:MD_DigitalTransferOptions>
      <!-- online resources -->
      <xsl:for-each
        select="$basket/eCH0271_1:eCH0271_1.eCH0271.CI_OnlineResource
                        [eCH0271_1:MD_DigitalTransferOptions/@REF = $dtoRecord/@TID]">
        <mrd:onLine>
          <xsl:call-template name="ech0271:CI_OnlineResource">
            <xsl:with-param name="orRecord" select="."/>
          </xsl:call-template>
        </mrd:onLine>
      </xsl:for-each>
    </mrd:MD_DigitalTransferOptions>
  </xsl:template>

  <!-- ================================================================
       CI_OnlineResource
       ================================================================ -->
  <xsl:template name="ech0271:CI_OnlineResource">
    <xsl:param name="orRecord" as="element()"/>

    <cit:CI_OnlineResource>
      <!-- linkage (first URL from PT_FreeURL) -->
      <xsl:variable name="url"
        select="normalize-space(
          $orRecord/eCH0271_1:linkage/eCH0271_1:eCH0271_1.eCH0271.PT_FreeURL
                    /eCH0271_1:URLGroup/eCH0271_1:eCH0271_1.eCH0271.PT_URLGroup[1]/eCH0271_1:plainURL)"/>
      <xsl:if test="$url != ''">
        <cit:linkage>
          <gco:CharacterString><xsl:value-of select="$url"/></gco:CharacterString>
        </cit:linkage>
      </xsl:if>
      <!-- protocol -->
      <xsl:if test="normalize-space($orRecord/eCH0271_1:protocol) != ''">
        <cit:protocol>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space($orRecord/eCH0271_1:protocol)"/>
          </gco:CharacterString>
        </cit:protocol>
      </xsl:if>
      <!-- name -->
      <xsl:if test="$orRecord/eCH0271_1:name/eCH0271_1:eCH0271_1.eCH0271.PT_FreeText">
        <cit:name xsi:type="lan:PT_FreeText_PropertyType">
          <xsl:call-template name="ech0271:PT_FreeText_content">
            <xsl:with-param name="freeText"
              select="$orRecord/eCH0271_1:name/eCH0271_1:eCH0271_1.eCH0271.PT_FreeText"/>
          </xsl:call-template>
        </cit:name>
      </xsl:if>
      <!-- description -->
      <xsl:if test="$orRecord/eCH0271_1:description/eCH0271_1:eCH0271_1.eCH0271.PT_FreeText">
        <cit:description xsi:type="lan:PT_FreeText_PropertyType">
          <xsl:call-template name="ech0271:PT_FreeText_content">
            <xsl:with-param name="freeText"
              select="$orRecord/eCH0271_1:description/eCH0271_1:eCH0271_1.eCH0271.PT_FreeText"/>
          </xsl:call-template>
        </cit:description>
      </xsl:if>
      <!-- function -->
      <xsl:if test="normalize-space($orRecord/eCH0271_1:function) != ''">
        <cit:function>
          <cit:CI_OnLineFunctionCode
            codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_OnLineFunctionCode"
            codeListValue="{normalize-space($orRecord/eCH0271_1:function)}">
            <xsl:value-of select="normalize-space($orRecord/eCH0271_1:function)"/>
          </cit:CI_OnLineFunctionCode>
        </cit:function>
      </xsl:if>
    </cit:CI_OnlineResource>
  </xsl:template>

  <!-- ================================================================
       MD_Format
       ================================================================ -->
  <xsl:template name="ech0271:MD_Format">
    <xsl:param name="fmtRecord" as="element()"/>

    <mrd:MD_Format>
      <mrd:formatSpecificationCitation>
        <cit:CI_Citation>
          <cit:title>
            <gco:CharacterString>
              <xsl:value-of select="normalize-space($fmtRecord/eCH0271_1:name)"/>
            </gco:CharacterString>
          </cit:title>
          <xsl:if test="normalize-space($fmtRecord/eCH0271_1:version) != ''">
            <cit:edition>
              <gco:CharacterString>
                <xsl:value-of select="normalize-space($fmtRecord/eCH0271_1:version)"/>
              </gco:CharacterString>
            </cit:edition>
          </xsl:if>
        </cit:CI_Citation>
      </mrd:formatSpecificationCitation>
    </mrd:MD_Format>
  </xsl:template>

</xsl:stylesheet>
