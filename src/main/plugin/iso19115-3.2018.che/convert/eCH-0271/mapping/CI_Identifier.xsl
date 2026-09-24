<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CI_Identifier mapping
     Handles metadata and scope identifiers
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       metadataIdentifier processor
       Resolves eCH0271_1:metadataIdentifier[@ili:ref] to MD_Identifier
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
       metadataScope processor
       Resolves eCH0271_1:metadataScope[@ili:ref] to MD_MetadataScope
       ================================================================ -->
  <xsl:template match="eCH0271_1:metadataScope[@ili:ref]" mode="metadata-scope">
    <xsl:variable name="scopeId" select="@ili:ref"/>
    <xsl:variable name="scopeObj" select="key('byTID', $scopeId)"/>

    <xsl:if test="$scopeObj/self::eCH0271_1:MD_MetadataScope">
      <mdb:metadataScope>
        <mdb:MD_MetadataScope>
          <mdb:resourceScope>
            <xsl:call-template name="scope-code">
              <xsl:with-param name="value" select="normalize-space($scopeObj/eCH0271_1:resourceScope)"/>
            </xsl:call-template>
          </mdb:resourceScope>
          <xsl:if test="$scopeObj/eCH0271_1:name">
            <mdb:name>
              <gco:CharacterString>
                <xsl:value-of select="$scopeObj/eCH0271_1:name"/>
              </gco:CharacterString>
            </mdb:name>
          </xsl:if>
        </mdb:MD_MetadataScope>
      </mdb:metadataScope>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
