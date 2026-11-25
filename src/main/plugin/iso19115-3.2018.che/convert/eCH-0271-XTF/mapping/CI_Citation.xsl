<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: CI_Citation mapping
     Handles citation (title + alternateTitle + dates) transformation
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:f271="urn:ech0271-functions"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       citation: CI_Citation reference resolver
       Resolves eCH0271:citation[@ili:ref] to CI_Citation object
       ================================================================ -->
  <xsl:template match="eCH0271:citation[@ili:ref]" mode="citation">
    <xsl:variable name="citationId" select="@ili:ref"/>
    <xsl:variable name="citationObj" select="key('byTID', $citationId)"/>
    
    <xsl:if test="$citationObj/self::eCH0271:CI_Citation">
      <cit:CI_Citation>
        <xsl:if test="$citationObj/eCH0271:title">
          <cit:title>
            <xsl:apply-templates select="$citationObj/eCH0271:title" mode="multilingual-text"/>
          </cit:title>
        </xsl:if>
        <xsl:for-each select="$citationObj/eCH0271:alternateTitle">
          <cit:alternateTitle>
            <xsl:apply-templates select="." mode="multilingual-text"/>
          </cit:alternateTitle>
        </xsl:for-each>
        <xsl:call-template name="process-citation-dates">
          <xsl:with-param name="citationObj" select="$citationObj"/>
        </xsl:call-template>
      </cit:CI_Citation>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       citation: CI_Citation (direct - fallback for inline citations)
       ================================================================ -->
  <xsl:template match="eCH0271:CI_Citation" mode="citation">
    <cit:CI_Citation>
      <xsl:if test="eCH0271:title">
        <cit:title>
          <xsl:apply-templates select="eCH0271:title" mode="multilingual-text"/>
        </cit:title>
      </xsl:if>
      <xsl:for-each select="eCH0271:alternateTitle">
        <cit:alternateTitle>
          <xsl:apply-templates select="." mode="multilingual-text"/>
        </cit:alternateTitle>
      </xsl:for-each>
      <xsl:call-template name="process-citation-dates">
        <xsl:with-param name="citationObj" select="."/>
      </xsl:call-template>
    </cit:CI_Citation>
  </xsl:template>

  <!-- ================================================================
       Citation dates: CI_Date linked to the citation through its 'date'
       role (nested structure, reference or association)
       ================================================================ -->
  <xsl:template name="process-citation-dates">
    <xsl:param name="citationObj" as="element()"/>
    <xsl:for-each select="f271:related($citationObj, 'CI_Date', 'date')">
      <cit:date>
        <xsl:apply-templates select="." mode="date"/>
      </cit:date>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
