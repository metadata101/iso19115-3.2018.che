<?xml version="1.0" encoding="UTF-8"?>
<!--
  Entry point: eCH0271 1.0 INTERLIS → ISO 19115-3:2018 (CHE profile).

  Pure XSLT 2.0 — no Java extension functions required.
  Delegates to eCH-0271/fromECH0271.xsl which contains the full mapping logic.

  Optional parameter:
    $uuid  – override the metadata identifier in the output (defaults to
             the eCH0271 fileIdentifier or the @TID of the MD_Metadata record).
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

  <xsl:import href="eCH-0271/fromECH0271.xsl"/>

  <xsl:param name="uuid"/>

</xsl:stylesheet>
