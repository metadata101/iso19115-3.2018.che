<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH0271 → ISO 19115-3:2018 CHE distribution mapping
     Transforms: MD_Distribution, MD_DigitalTransferOptions, CI_OnlineResource, MD_Format -->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:ili  ="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:ech0271 ="urn:ech0271-functions"
  xmlns:cit  ="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:lan  ="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mcc  ="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mrd  ="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- MD_Distribution -->
  <xsl:template name="ech0271:MD_Distribution">
    <xsl:param name="distRecord" as="element()"/>
    <xsl:param name="basket"     as="element()"/>

    <mrd:MD_Distribution>

      <!-- distributionFormat: Find MD_Format records via eCH0271_1:distributionFormat/@ili:ref -->
      <xsl:for-each select="$distRecord/eCH0271_1:distributionFormat[@ili:ref]">
        <xsl:variable name="fmtRecord" select="key('byTID', @ili:ref)"/>
        <xsl:if test="$fmtRecord/self::eCH0271_1:MD_Format">
          <mrd:distributionFormat>
            <xsl:call-template name="ech0271:MD_Format">
              <xsl:with-param name="fmtRecord" select="$fmtRecord"/>
            </xsl:call-template>
          </mrd:distributionFormat>
        </xsl:if>
      </xsl:for-each>

      <!-- transferOptions: Find MD_DigitalTransferOptions records via eCH0271_1:transferOptions/@ili:ref -->
      <xsl:for-each select="$distRecord/eCH0271_1:transferOptions[@ili:ref]">
        <xsl:variable name="dtoRecord" select="key('byTID', @ili:ref)"/>
        <xsl:if test="$dtoRecord/self::eCH0271_1:MD_DigitalTransferOptions">
          <mrd:transferOptions>
            <xsl:call-template name="ech0271:MD_DigitalTransferOptions">
              <xsl:with-param name="dtoRecord" select="$dtoRecord"/>
              <xsl:with-param name="basket"    select="$basket"/>
            </xsl:call-template>
          </mrd:transferOptions>
        </xsl:if>
      </xsl:for-each>

    </mrd:MD_Distribution>
  </xsl:template>

  <!-- MD_DigitalTransferOptions -->
  <xsl:template name="ech0271:MD_DigitalTransferOptions">
    <xsl:param name="dtoRecord" as="element()"/>
    <xsl:param name="basket"    as="element()"/>

    <mrd:MD_DigitalTransferOptions>
      <!-- online resources: Find CI_OnlineResource records via eCH0271_1:onLine/@ili:ref -->
      <xsl:for-each select="$dtoRecord/eCH0271_1:onLine[@ili:ref]">
        <xsl:variable name="orRecord" select="key('byTID', @ili:ref)"/>
        <xsl:if test="$orRecord/self::eCH0271_1:CI_OnlineResource">
          <mrd:onLine>
            <xsl:call-template name="ech0271:CI_OnlineResource">
              <xsl:with-param name="orRecord" select="$orRecord"/>
            </xsl:call-template>
          </mrd:onLine>
        </xsl:if>
      </xsl:for-each>
    </mrd:MD_DigitalTransferOptions>
  </xsl:template>

  <!-- CI_OnlineResource -->
  <xsl:template name="ech0271:CI_OnlineResource">
    <xsl:param name="orRecord" as="element()"/>

    <cit:CI_OnlineResource>
      <!-- linkage: Plain text URL from eCH0271_1:linkage -->
      <xsl:if test="normalize-space($orRecord/eCH0271_1:linkage) != ''">
        <cit:linkage>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space($orRecord/eCH0271_1:linkage)"/>
          </gco:CharacterString>
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

      <!-- name (optional, via reference) -->
      <xsl:if test="$orRecord/eCH0271_1:name[@ili:ref]">
        <xsl:variable name="nameRecord" select="key('byTID', $orRecord/eCH0271_1:name/@ili:ref)"/>
        <xsl:if test="$nameRecord">
          <cit:name>
            <xsl:apply-templates select="$nameRecord" mode="multilingual-text"/>
          </cit:name>
        </xsl:if>
      </xsl:if>

      <!-- description (optional, via reference) -->
      <xsl:if test="$orRecord/eCH0271_1:description[@ili:ref]">
        <xsl:variable name="descRecord" select="key('byTID', $orRecord/eCH0271_1:description/@ili:ref)"/>
        <xsl:if test="$descRecord">
          <cit:description>
            <xsl:apply-templates select="$descRecord" mode="multilingual-text"/>
          </cit:description>
        </xsl:if>
      </xsl:if>

      <!-- function (CI_OnLineFunctionCode) -->
      <xsl:if test="normalize-space($orRecord/eCH0271_1:function) != ''">
        <cit:function>
          <cit:CI_OnLineFunctionCode codeListValue="{normalize-space($orRecord/eCH0271_1:function)}">
            <xsl:value-of select="normalize-space($orRecord/eCH0271_1:function)"/>
          </cit:CI_OnLineFunctionCode>
        </cit:function>
      </xsl:if>
    </cit:CI_OnlineResource>
  </xsl:template>

  <!-- MD_Format -->
  <xsl:template name="ech0271:MD_Format">
    <xsl:param name="fmtRecord" as="element()"/>

    <mrd:MD_Format>
      <mrd:formatSpecificationCitation>
        <cit:CI_Citation>
          <xsl:if test="$fmtRecord/eCH0271_1:name">
            <cit:title>
              <xsl:apply-templates select="$fmtRecord/eCH0271_1:name" mode="multilingual-text"/>
            </cit:title>
          </xsl:if>
        </cit:CI_Citation>
      </mrd:formatSpecificationCitation>
    </mrd:MD_Format>
  </xsl:template>

</xsl:stylesheet>
