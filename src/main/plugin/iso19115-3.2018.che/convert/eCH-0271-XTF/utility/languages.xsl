<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: language code utilities
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ech0271="urn:ech0271-functions"
  exclude-result-prefixes="#all">

  <!-- ISO 639-1 codes and their ISO 639-2 equivalent, at the same position -->
  <xsl:variable name="ech0271:iso639-1" as="xs:string+" select="('de', 'fr', 'it', 'en', 'rm')"/>
  <xsl:variable name="ech0271:iso639-2" as="xs:string+" select="('ger', 'fre', 'ita', 'eng', 'roh')"/>

  <!-- ================================================================
       ech0271:locale-id($lang)
       Id of the lan:PT_Locale for an eCH-0271 language code ('de' → 'DE'),
       as referenced by lan:LocalisedCharacterString/@locale ('#DE').
       ================================================================ -->
  <xsl:function name="ech0271:locale-id" as="xs:string">
    <xsl:param name="lang" as="xs:string?"/>
    <xsl:sequence select="upper-case(normalize-space($lang))"/>
  </xsl:function>

  <!-- ================================================================
       ech0271:iso639-2($lang)
       ISO 639-2/B code of an ISO 639-1 language code ('de' → 'ger'),
       case insensitive. Any other value (already 3 letters or unknown)
       is returned lower-cased.
       ================================================================ -->
  <xsl:function name="ech0271:iso639-2" as="xs:string">
    <xsl:param name="lang" as="xs:string?"/>
    <xsl:variable name="code" select="lower-case(normalize-space($lang))"/>
    <xsl:sequence select="($ech0271:iso639-2[index-of($ech0271:iso639-1, $code)], $code)[1]"/>
  </xsl:function>

</xsl:stylesheet>
