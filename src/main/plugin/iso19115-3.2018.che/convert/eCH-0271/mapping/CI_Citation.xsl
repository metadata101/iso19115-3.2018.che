<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CI_Citation mapping
     Handles citation (title + dates) transformation
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       citation: CI_Citation reference resolver
       Resolves eCH0271_1:citation[@ili:ref] to CI_Citation object
       ================================================================ -->
  <xsl:template match="eCH0271_1:citation[@ili:ref]" mode="citation">
    <xsl:variable name="citationId" select="@ili:ref"/>
    <xsl:variable name="citationObj" select="key('byTID', $citationId)"/>
    
    <xsl:if test="$citationObj/self::eCH0271_1:CI_Citation">
      <cit:CI_Citation>
        <xsl:if test="$citationObj/eCH0271_1:title">
          <cit:title>
            <xsl:apply-templates select="$citationObj/eCH0271_1:title" mode="multilingual-text"/>
          </cit:title>
        </xsl:if>
        <xsl:call-template name="process-citation-dates">
          <xsl:with-param name="citationObj" select="$citationObj"/>
          <xsl:with-param name="citObjTid" select="$citationObj/@ili:tid"/>
        </xsl:call-template>
      </cit:CI_Citation>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       citation: CI_Citation (direct - fallback for inline citations)
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Citation" mode="citation">
    <cit:CI_Citation>
      <xsl:if test="eCH0271_1:title">
        <cit:title>
          <xsl:apply-templates select="eCH0271_1:title" mode="multilingual-text"/>
        </cit:title>
      </xsl:if>
      <xsl:call-template name="process-citation-dates">
        <xsl:with-param name="citationObj" select="."/>
        <xsl:with-param name="citObjTid" select="@ili:tid"/>
      </xsl:call-template>
    </cit:CI_Citation>
  </xsl:template>

  <!-- ================================================================
       Process citation dates with 3-priority fallback strategy
       Called by both citation[@ili:ref] and CI_Citation direct templates
       ================================================================ -->
  <xsl:template name="process-citation-dates">
    <xsl:param name="citationObj" as="element()"/>
    <xsl:param name="citObjTid" as="xs:string?"/>
    
    <!-- Priority 1: Direct reference -->
    <xsl:choose>
      <xsl:when test="$citationObj/eCH0271_1:date[@ili:ref]">
        <xsl:for-each select="$citationObj/eCH0271_1:date[@ili:ref]">
          <xsl:variable name="dateRef" select="@ili:ref"/>
          <xsl:variable name="dateObj" select="key('byTID', $dateRef)"/>
          <xsl:if test="$dateObj/self::eCH0271_1:CI_Date">
            <cit:date>
              <xsl:apply-templates select="$dateObj" mode="date"/>
            </cit:date>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <!-- Priority 2: Association table (CI_Citationdate) -->
      <xsl:when test="$citObjTid and //eCH0271_1:CI_Citationdate[@ili:from=$citObjTid]">
        <xsl:for-each select="//eCH0271_1:CI_Citationdate[@ili:from=$citObjTid]">
          <xsl:variable name="dateRef" select="@ili:to"/>
          <xsl:variable name="dateObj" select="key('byTID', $dateRef)"/>
          <xsl:if test="$dateObj/self::eCH0271_1:CI_Date">
            <cit:date>
              <xsl:apply-templates select="$dateObj" mode="date"/>
            </cit:date>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <!-- Priority 3: CI_Date following-sibling (fallback for inline dates) - support multiple consecutive dates -->
      <xsl:otherwise>
        <xsl:variable name="datesAfter" select="$citationObj/following-sibling::eCH0271_1:CI_Date"/>
        <xsl:for-each select="$datesAfter">
          <xsl:variable name="pos" select="position()"/>
          <xsl:variable name="prevSibling" select="preceding-sibling::*[1]"/>
          <!-- Process first CI_Date or any CI_Date immediately following another CI_Date -->
          <xsl:if test="($pos = 1 or $prevSibling/self::eCH0271_1:CI_Date) and eCH0271_1:date">
            <cit:date>
              <xsl:apply-templates select="." mode="date"/>
            </cit:date>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================
       multilingual-text: Extract text from Localisation_V2:MultilingualMText
       ================================================================ -->
  <xsl:template match="Localisation_V2:MultilingualMText" mode="multilingual-text">
    <gco:CharacterString>
      <!-- Extract first available text (preferred: French, otherwise first available) -->
      <xsl:choose>
        <xsl:when test="Localisation_V2:LocalisedText/Localisation_V2:LocalisedMText[Localisation_V2:Language='fr']/Localisation_V2:Text">
          <xsl:value-of select="Localisation_V2:LocalisedText/Localisation_V2:LocalisedMText[Localisation_V2:Language='fr']/Localisation_V2:Text/text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="Localisation_V2:LocalisedText[1]/Localisation_V2:LocalisedMText/Localisation_V2:Text/text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </gco:CharacterString>
  </xsl:template>

</xsl:stylesheet>
