<?xml version="1.0" encoding="UTF-8"?>
<!--
  Preprocessing step for GM03 → ISO 19115-3:2018 CHE conversion.
  
  Purpose:
    Flatten the INTERLIS structure by resolving @REF attributes into the
    referenced objects themselves, turning the tree-like structure into a
    fully traversable single document.
  
  Input:  Raw GM03 INTERLIS transfer file (int:TRANSFER/int:DATASECTION)
  Output: Flattened structure with @REF replaced by actual element copies
  
  Note: This step is optional if the main converter already resolves references
        via XSLT keys (as fromGM03.xsl currently does).
-->
<xsl:stylesheet version="1.0"
                xmlns:int="http://www.interlis.ch/INTERLIS2.3"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="int">

  <!-- ================================================================
       Root: Extract MD_Metadata (the only record we keep at top level)
       Flatten and resolve all @REF attributes to their target objects.
       ================================================================ -->
  <xsl:template match="int:GM03_2_1Comprehensive.Comprehensive|int:GM03_2_1Core.Core" mode="ResolveRefs">
    <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
      <!-- Prefer MD_Metadata with parentIdentifier (if it's a child metadata).
           Otherwise, take the first one. -->
      <xsl:choose>
        <xsl:when test="int:GM03_2_1Core.Core.MD_Metadata[int:parentIdentifier/@REF]">
          <xsl:apply-templates select="int:GM03_2_1Core.Core.MD_Metadata[int:parentIdentifier/@REF][1]" mode="ResolveRefs">
            <xsl:with-param name="parent" select="name(.)"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="int:GM03_2_1Core.Core.MD_Metadata[1]" mode="ResolveRefs">
            <xsl:with-param name="parent" select="name(.)"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Special case: formatDistributordistributorFormat creates loops.
           Handle it separately with ResolveRefsCopy to avoid infinite recursion. -->
      <xsl:apply-templates select="int:GM03_2_1Comprehensive.Comprehensive.formatDistributordistributorFormat"
                           mode="ResolveRefsCopy"/>
    </xsl:element>
  </xsl:template>


  <!-- ================================================================
       Drop back-references (association end-points that reference their
       parent). These are handled in the forward direction, not backward.
       ================================================================ -->
  <xsl:template match="*[@REF and (starts-with(name(.), 'CI_') or starts-with(name(.), 'DQ_') or starts-with(name(.), 'EX_') or starts-with(name(.), 'LI_') or starts-with(name(.), 'MD_') or starts-with(name(.), 'SV_'))]" mode="ResolveRefs"/>

  <!-- ================================================================
       Prevent infinite recursion: skip this association's forward pass
       (will be handled separately in mode="ResolveRefsCopy" to avoid loops).
       ================================================================ -->
  <xsl:template match="int:GM03_2_1Comprehensive.Comprehensive.formatDistributordistributorFormat" mode="ResolveRefs"/>

  <!-- ================================================================
       Generic element handler: copy structure and resolve all @REF.
       Also follow back-references (find all elements that reference this
       element's @TID) and include them as children.
       ================================================================ -->
  <xsl:template match="*" mode="ResolveRefs">
    <xsl:param name="parent"/>
    <xsl:variable name="selfName" select="name(.)"/>
    <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
      <!-- Copy all attributes, resolving @REF if present -->
      <xsl:apply-templates select="@*" mode="ResolveRefs"/>
      <!-- Recursively process child elements -->
      <xsl:apply-templates mode="ResolveRefs">
        <xsl:with-param name="parent" select="$selfName"/>
      </xsl:apply-templates>

      <!-- If this element has a @TID, find all back-references to it and include them -->
      <xsl:if test="@TID">
        <xsl:variable name="myTID" select="@TID"/>
        <!-- Search for all elements in both baskets that have a @REF matching this @TID -->
        <xsl:for-each select="/int:TRANSFER/int:DATASECTION/int:GM03_2_1Comprehensive.Comprehensive/*|/int:TRANSFER/int:DATASECTION/int:GM03_2_1Core.Core/*">
          <xsl:for-each select="*[@REF=$myTID]">
            <!-- Only include if: (1) parent differs, and (2) element name indicates it's a significant object -->
            <xsl:if test="$parent!=name(..) and (starts-with(name(.), 'CI_') or starts-with(name(.), 'DQ_') or starts-with(name(.), 'EX_') or starts-with(name(.), 'LI_') or starts-with(name(.), 'MD_') or starts-with(name(.), 'SV_'))">
              <xsl:apply-templates select=".." mode="ResolveRefs">
                <xsl:with-param name="parent" select="$selfName"/>
              </xsl:apply-templates>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>

        <!-- Special case: if this is an LI_Source, also include its process steps -->
        <xsl:if test="ends-with($selfName, 'Comprehensive.Comprehensive.LI_Source')">
          <xsl:apply-templates mode="ResolveRefs" select="/int:TRANSFER/int:DATASECTION/int:GM03_2_1Comprehensive.Comprehensive/
                       int:GM03_2_1Comprehensive.Comprehensive.sourceStepsource[int:source/@REF = $myTID]/int:sourceStep" />
        </xsl:if>
      </xsl:if>
    </xsl:element>
  </xsl:template>

    <!-- manage direct references -->
    <xsl:key name="index" match="/int:TRANSFER/int:DATASECTION/int:GM03_2_1Comprehensive.Comprehensive//*|/int:TRANSFER/int:DATASECTION/int:GM03_2_1Core.Core//*" use="@TID"/>
    <xsl:template match="@REF" mode="ResolveRefs">
        <xsl:attribute name="REF">
            <xsl:value-of select="."/>
        </xsl:attribute>
        <xsl:variable name="real" select="key('index', .)"/>
        <xsl:apply-templates select="$real" mode="ResolveRefs">
            <xsl:with-param name="parent" select="name(../..)"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="@*" mode="ResolveRefs">
        <xsl:attribute name="{name(.)}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()" mode="ResolveRefs">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

  <!-- ================================================================
       ResolveRefsCopy: Alternative mode for handling N-N associations
       that would otherwise cause infinite loops. This mode does NOT
       automatically follow back-references.
       ================================================================ -->
  <xsl:template match="*" mode="ResolveRefsCopy">
    <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
      <xsl:apply-templates select="@*" mode="ResolveRefsCopy"/>
      <xsl:apply-templates mode="ResolveRefsCopy"/>
    </xsl:element>
  </xsl:template>

  <!-- For formatDistributor and distributorFormat: resolve the @REF -->
  <xsl:template match="int:formatDistributor/@REF" mode="ResolveRefsCopy">
    <xsl:apply-templates mode="ResolveRefs" select="."/>
  </xsl:template>

  <xsl:template match="int:distributorFormat/@REF" mode="ResolveRefsCopy">
    <xsl:apply-templates mode="ResolveRefs" select="."/>
  </xsl:template>

  <!-- Copy all other attributes -->
  <xsl:template match="@*" mode="ResolveRefsCopy">
    <xsl:attribute name="{name(.)}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
