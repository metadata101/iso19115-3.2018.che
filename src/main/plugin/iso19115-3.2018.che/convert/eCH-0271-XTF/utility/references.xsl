<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: object link resolution utilities
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:f271="urn:ech0271-functions"
  exclude-result-prefixes="#all">

  <!-- Elements holding an ili:ref, indexed by the referenced TID
       (complements the 'byTID' key declared in fromECH0271-XTF.xsl) -->
  <xsl:key name="refsTo" match="*[@ili:ref]" use="@ili:ref"/>

  <!-- ================================================================
       f271:related($obj, $types)
       Objects of one of the given types (local names) linked to $obj,
       whatever the way the XTF expresses the link:
       - nested structure:     $obj/property/Type
       - reference from $obj:  $obj/role/@ili:ref → Type
       - reference to $obj:    Type/role/@ili:ref → $obj
       - association object (no ili:tid) referencing both $obj and Type
       Results are in document order, without duplicates.
       ================================================================ -->
  <xsl:function name="f271:related" as="element()*">
    <xsl:param name="obj" as="element()"/>
    <xsl:param name="types" as="xs:string+"/>
    <xsl:sequence select="f271:related($obj, $types, ())"/>
  </xsl:function>

  <!-- Same, restricted to the given roles: local name of the element that
       holds the linked object (nested structure, reference from $obj or
       from an association). A reference to $obj does not name the role of
       the linked object, so it is ignored when roles are given. -->
  <xsl:function name="f271:related" as="element()*">
    <xsl:param name="obj" as="element()"/>
    <xsl:param name="types" as="xs:string+"/>
    <xsl:param name="roles" as="xs:string*"/>
    <xsl:sequence select="f271:related($obj, $types, $roles, ())"/>
  </xsl:function>

  <!-- Same, also following references to $obj made through one of the
       given inverse roles: local name of the element of the linked object
       that holds the reference to $obj (e.g. 'standardUsedBy' for the
       metadataStandard of an MD_Metadata, 'MD_Metadata' for its
       resourceLineage). -->
  <xsl:function name="f271:related" as="element()*">
    <xsl:param name="obj" as="element()"/>
    <xsl:param name="types" as="xs:string+"/>
    <xsl:param name="roles" as="xs:string*"/>
    <xsl:param name="inverseRoles" as="xs:string*"/>
    <xsl:variable name="root" select="root($obj)"/>
    <xsl:variable name="refsToObj" select="key('refsTo', $obj/@ili:tid, $root)"/>
    <xsl:variable name="linked" select="
        $obj/*[empty($roles) or local-name() = $roles]/*
      | key('byTID', $obj/*[empty($roles) or local-name() = $roles]/@ili:ref, $root)
      | $refsToObj[empty($roles) or local-name() = $inverseRoles]/parent::*[@ili:tid]
      | key('byTID', $refsToObj/parent::*[not(@ili:tid)]/*[empty($roles) or local-name() = $roles]/@ili:ref, $root)"/>
    <xsl:sequence select="($linked except $obj)[local-name() = $types]"/>
  </xsl:function>

</xsl:stylesheet>
