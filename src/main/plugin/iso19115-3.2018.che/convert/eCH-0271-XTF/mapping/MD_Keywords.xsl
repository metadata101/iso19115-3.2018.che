<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: MD_Keywords mapping
     Descriptive keywords of an identification, grouped by thesaurus
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:f271="urn:ech0271-functions"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       descriptive-keywords: MD_Keywords of the context identification
       → one mri:descriptiveKeywords per thesaurus

       In the XTF, several MD_Keywords (often one keyword each) may
       reference the same thesaurus: their keywords are merged into a
       single mri:MD_Keywords, with the thesaurus cited at the end.
       A thesaurus is identified by its identifier code, so that distinct
       CI_Citation objects for the same thesaurus are merged too (the
       first one is cited).
       MD_Keywords without thesaurus ("free text") are not merged: each
       one gives its own mri:MD_Keywords, without mri:thesaurusName.
       The type is taken from the first MD_Keywords of the group.
       ================================================================ -->
  <xsl:template name="descriptive-keywords">
    <xsl:for-each-group select="f271:related(., 'MD_Keywords', 'descriptiveKeywords')"
                        group-by="f271:keywords-group-key(.)">
      <xsl:variable name="thesaurus" select="f271:keywords-thesaurus(.)"/>
      <mri:descriptiveKeywords>
        <mri:MD_Keywords>
          <xsl:for-each select="current-group()/eCH0271:keyword">
            <mri:keyword>
              <xsl:apply-templates select="." mode="multilingual-text"/>
            </mri:keyword>
          </xsl:for-each>
          <xsl:for-each select="(current-group()/eCH0271:type[normalize-space()])[1]">
            <mri:type>
              <mri:MD_KeywordTypeCode codeList="{$CL}MD_KeywordTypeCode"
                                      codeListValue="{normalize-space()}"/>
            </mri:type>
          </xsl:for-each>
          <xsl:for-each select="$thesaurus">
            <mri:thesaurusName>
              <xsl:apply-templates select="." mode="citation"/>
            </mri:thesaurusName>
          </xsl:for-each>
        </mri:MD_Keywords>
      </mri:descriptiveKeywords>
    </xsl:for-each-group>
  </xsl:template>

  <!-- Thesaurus (CI_Citation) of a MD_Keywords, if any -->
  <xsl:function name="f271:keywords-thesaurus" as="element()?">
    <xsl:param name="keywords" as="element()"/>
    <xsl:sequence select="f271:related($keywords, 'CI_Citation', 'thesaurusName')[1]"/>
  </xsl:function>

  <!-- Grouping key of a MD_Keywords: the identifier code of its thesaurus,
       else the thesaurus object itself; free text keywords (no thesaurus)
       are keyed by the MD_Keywords object itself, so never merged -->
  <xsl:function name="f271:keywords-group-key" as="xs:string">
    <xsl:param name="keywords" as="element()"/>
    <xsl:variable name="thesaurus" select="f271:keywords-thesaurus($keywords)"/>
    <xsl:choose>
      <xsl:when test="empty($thesaurus)">
        <xsl:sequence select="generate-id($keywords)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="code" select="normalize-space(
            (f271:related($thesaurus, 'MD_Identifier', 'identifier')/eCH0271:code//*[local-name() = 'Text'])[1])"/>
        <xsl:sequence select="if ($code != '') then $code else generate-id($thesaurus)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>
