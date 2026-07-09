<?xml version="1.0" encoding="UTF-8"?>
<!--
  Entry point: ISO 19115-3:2018 (CHE profile) → eCH0271 1.0 INTERLIS

  Pure XSLT 2.0 — no Java extension functions required.
  Delegates to eCH-0271/toECH0271.xsl which contains the full mapping logic.

  Optional parameter:
    $uuid  – override the metadata identifier in the output (defaults to
             the ISO 19115 metadataIdentifier or a generated UUID).

  Reverse mapping from ISO 19115-3:2018.che back to INTERLIS 2.3 eCH0271_1
  format. Useful for round-trip conversions and backward compatibility.
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

  <xsl:import href="eCH-0271/toECH0271.xsl"/>

  <xsl:param name="uuid"/>

</xsl:stylesheet>
