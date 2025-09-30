<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                  xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                  xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                  xmlns:xs="http://www.w3.org/2001/XMLSchema"
                  xmlns:geonet="http://www.fao.org/geonetwork"
                  xmlns:util="java:org.fao.geonet.util.XslUtil"
                  xmlns:saxon="http://saxon.sf.net/"
                  extension-element-prefixes="saxon"
                  exclude-result-prefixes="#all">


<xsl:import href="../convert/ISO19139/fromISO19139.xsl"></xsl:import>

<!-- Remove geonet:* elements. -->
<xsl:template match="geonet:*" priority="2" mode="from19139to19115-3.2018"/>

</xsl:stylesheet>
