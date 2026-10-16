<?xml version="1.0" encoding="UTF-8"?>
<!-- ISO 19115-3:2018 CHE → eCH0271 XTF 2.4 reverse converter
     Generates flat basket structure with proper @ili:tid/@ili:ref linking -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:che="http://geocat.ch/che"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:mdq="http://standards.iso.org/iso/19115/-3/mdq/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
  xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
  xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
  exclude-result-prefixes="xsl xs che mdb mri mrd cit gex mdq mcc lan gco mrl mrs mco mmi">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="uuid" as="xs:string?"/>

  <!-- Root template: generate XTF transfer with flat basket -->
  <xsl:template match="/">
    <ili:transfer xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS" 
                  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1" 
                  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2" 
                  xmlns:geom="http://www.interlis.ch/geometry/1.0" 
                  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <ili:headersection>
        <ili:models>
          <ili:model>eCH0271_1</ili:model>
        </ili:models>
      </ili:headersection>
      <ili:datasection>
        <!-- Wrap all elements in eCH0271 basket container for XTF 2.4 compliance -->
        <eCH0271_1:eCH0271 ili:bid="eCH0271_1.eCH0271">
          <!-- Generate all elements from CHE_MD_Metadata in flat structure -->
          <xsl:apply-templates select="//che:CHE_MD_Metadata | //mdb:MD_Metadata" mode="flatten"/>
        </eCH0271_1:eCH0271>
      </ili:datasection>
    </ili:transfer>
  </xsl:template>

  <!-- Main CHE_MD_Metadata: flatten all contained elements -->
  <xsl:template match="che:CHE_MD_Metadata | mdb:MD_Metadata" mode="flatten">
    <xsl:variable name="mdTID" select="generate-id(.)"/>
    <xsl:variable name="mdUUID">
      <xsl:choose>
        <xsl:when test="normalize-space($uuid) != ''">
          <xsl:value-of select="$uuid"/>
        </xsl:when>
        <xsl:when test="mdb:metadataIdentifier/*/mcc:code/gco:CharacterString">
          <xsl:value-of select="normalize-space(mdb:metadataIdentifier/*/mcc:code/gco:CharacterString)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('md-', generate-id(.))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Generate all referenced elements first (bottom-up) -->
    
    <!-- MD_Identifier for metadataIdentifier -->
    <xsl:if test="mdb:metadataIdentifier/*/mcc:code/gco:CharacterString">
      <xsl:variable name="mdIdTID" select="generate-id(mdb:metadataIdentifier)"/>
      <xsl:variable name="mdIdCode" select="normalize-space(mdb:metadataIdentifier/*/mcc:code/gco:CharacterString)"/>
      <eCH0271_1:MD_Identifier ili:tid="MDID_{$mdIdTID}">
        <eCH0271_1:code>
          <Localisation_V2:MultilingualMText>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedMText>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$mdIdCode"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedMText>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualMText>
        </eCH0271_1:code>
      </eCH0271_1:MD_Identifier>
    </xsl:if>

    <!-- MD_Identifier for referenceSystemIdentifier -->
    <xsl:if test="mdb:referenceSystemInfo/*/mrs:referenceSystemIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString">
      <xsl:variable name="refIdTID" select="generate-id(mdb:referenceSystemInfo[1]/*/mrs:referenceSystemIdentifier)"/>
      <xsl:variable name="refIdCode" select="normalize-space(mdb:referenceSystemInfo[1]/*/mrs:referenceSystemIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString)"/>
      <eCH0271_1:MD_Identifier ili:tid="REFID_{$refIdTID}">
        <eCH0271_1:code>
          <Localisation_V2:MultilingualMText>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedMText>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$refIdCode"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedMText>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualMText>
        </eCH0271_1:code>
      </eCH0271_1:MD_Identifier>
    </xsl:if>

    <!-- MD_MetadataScope -->
    <xsl:if test="mdb:metadataScope">
      <xsl:variable name="scopeTID" select="generate-id(mdb:metadataScope[1])"/>
      <eCH0271_1:MD_MetadataScope ili:tid="SCOPE_{$scopeTID}">
        <xsl:if test="mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope">
          <eCH0271_1:resourceScope>
            <xsl:value-of select="normalize-space((mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mdb:MD_ScopeCode | mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope)[1])"/>
          </eCH0271_1:resourceScope>
        </xsl:if>
        <xsl:if test="mdb:metadataScope/mdb:MD_MetadataScope/mdb:name">
          <eCH0271_1:name>
            <xsl:value-of select="normalize-space((mdb:metadataScope/mdb:MD_MetadataScope/mdb:name/gco:CharacterString | mdb:metadataScope/mdb:MD_MetadataScope/mdb:name)[1])"/>
          </eCH0271_1:name>
        </xsl:if>
      </eCH0271_1:MD_MetadataScope>
    </xsl:if>

    <!-- Contact/Responsibility elements and associated organisations -->
    <xsl:for-each select="mdb:contact | mdb:identificationInfo/*/mri:pointOfContact">
      <!-- Generate organisation first if referenced -->
      <xsl:variable name="partyElem" select="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party[1]"/>
      <xsl:if test="$partyElem">
        <xsl:call-template name="generate-organisation">
          <xsl:with-param name="elem" select="$partyElem"/>
        </xsl:call-template>
        <!-- Generate address if exists (contact info) -->
        <xsl:if test="$partyElem/*/cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address">
          <xsl:call-template name="generate-address">
            <xsl:with-param name="elem" select="$partyElem/*/cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address"/>
          </xsl:call-template>
        </xsl:if>
        <!-- Generate individual for organisation if exists -->
        <xsl:if test="$partyElem/*/cit:individual/cit:CI_Individual">
          <xsl:call-template name="generate-individual">
            <xsl:with-param name="elem" select="$partyElem/*/cit:individual/cit:CI_Individual"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
      <!-- Then generate responsibility -->
      <xsl:call-template name="generate-responsibility">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Generate maintenance information -->
    <xsl:for-each select="mdb:identificationInfo/*/mri:resourceMaintenance/che:CHE_MD_MaintenanceInformation | mdb:identificationInfo/*/mri:resourceMaintenance/mmi:MD_MaintenanceInformation">
      <xsl:call-template name="generate-maintenance-info">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Generate browse graphics -->
    <xsl:for-each select="mdb:identificationInfo/*/mri:graphicOverview/mcc:MD_BrowseGraphic">
      <xsl:call-template name="generate-browse-graphic">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Generate legal constraints -->
    <xsl:for-each select="mdb:identificationInfo/*/mri:resourceConstraints/mco:MD_LegalConstraints">
      <xsl:call-template name="generate-legal-constraints">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- CHE_MD_Legislation and legislationCitation -->
    <xsl:for-each select="mdb:identificationInfo/*/che:legislationInformation/che:CHE_MD_Legislation">
      <xsl:call-template name="generate-legislation">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
      <!-- Also generate the legislationCitation if present -->
      <xsl:for-each select="che:legislationCitation/cit:CI_Citation">
        <xsl:call-template name="generate-citation">
          <xsl:with-param name="elem" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>

    <!-- Citation elements (from metadata standard and data identification) -->
    <xsl:for-each select="mdb:metadataStandard/*/descendant::cit:CI_Citation">
      <xsl:call-template name="generate-citation">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="mdb:identificationInfo/*/mri:citation/cit:CI_Citation">
      <xsl:call-template name="generate-citation">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Extent and bounding boxes -->
    <xsl:for-each select="mdb:identificationInfo/*/mri:extent/gex:EX_Extent">
      <xsl:call-template name="generate-extent">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Distribution elements -->
    <xsl:for-each select="mdb:distributionInfo/mrd:MD_Distribution">
      <xsl:call-template name="generate-distribution">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Reference system: include the code from referenceSystemIdentifier -->
    <xsl:for-each select="mdb:referenceSystemInfo/mrs:MD_ReferenceSystem">
      <xsl:variable name="refSysTID" select="generate-id(.)"/>
      <eCH0271_1:MD_ReferenceSystem ili:tid="REFSYS_{$refSysTID}">
        <xsl:if test="mrs:referenceSystemIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString">
          <xsl:variable name="refIdTID" select="generate-id(mrs:referenceSystemIdentifier)"/>
          <eCH0271_1:referenceSystemIdentifier ili:ref="REFID_{$refIdTID}"/>
        </xsl:if>
      </eCH0271_1:MD_ReferenceSystem>
    </xsl:for-each>

    <!-- CHE_MD_DataIdentification (main) -->
    <xsl:for-each select="mdb:identificationInfo">
      <xsl:variable name="diTID" select="generate-id(.)"/>
      <eCH0271_1:CHE_MD_DataIdentification ili:tid="DI_{$diTID}">
        <xsl:if test="*/mri:abstract/gco:CharacterString | */mri:abstract/*/text()">
          <eCH0271_1:abstract>
            <Localisation_V2:MultilingualMText>
              <Localisation_V2:LocalisedText>
                <Localisation_V2:LocalisedMText>
                  <Localisation_V2:Language>fr</Localisation_V2:Language>
                  <Localisation_V2:Text><xsl:value-of select="normalize-space((*/mri:abstract/gco:CharacterString | */mri:abstract/*/text())[1])"/></Localisation_V2:Text>
                </Localisation_V2:LocalisedMText>
              </Localisation_V2:LocalisedText>
            </Localisation_V2:MultilingualMText>
          </eCH0271_1:abstract>
        </xsl:if>
        <xsl:if test="*/mri:status">
          <eCH0271_1:status>
            <xsl:value-of select="normalize-space((*/mri:status/mcc:MD_ProgressCode/@codeListValue | */mri:status/mcc:MD_ProgressCode/text())[1])"/>
          </eCH0271_1:status>
        </xsl:if>
        <xsl:if test="*/mri:topicCategory">
          <eCH0271_1:topicCategory>
            <xsl:value-of select="normalize-space((*/mri:topicCategory/mri:MD_TopicCategoryCode/text() | */mri:topicCategory/mri:MD_TopicCategoryCode)[1])"/>
          </eCH0271_1:topicCategory>
        </xsl:if>
        <!-- defaultLocale: inline PT_Locale (no OID needed) -->
        <xsl:if test="*/mri:defaultLocale/lan:PT_Locale">
          <eCH0271_1:defaultLocale>
            <xsl:call-template name="generate-default-locale">
              <xsl:with-param name="elem" select="*/mri:defaultLocale[1]/lan:PT_Locale[1]"/>
            </xsl:call-template>
          </eCH0271_1:defaultLocale>
        </xsl:if>
        <!-- basicGeodata flag -->
        <xsl:if test="*/che:basicGeodata/gco:Boolean">
          <eCH0271_1:basicGeodata>
            <xsl:value-of select="normalize-space(*/che:basicGeodata/gco:Boolean)"/>
          </eCH0271_1:basicGeodata>
        </xsl:if>
        <!-- basicGeodataInformation: inline (no OID needed) -->
        <xsl:if test="*/che:basicGeodataInformation">
          <eCH0271_1:basicGeodataInformation>
            <xsl:call-template name="generate-basicgeodatainformation">
              <xsl:with-param name="elem" select="*/che:basicGeodataInformation[1]"/>
            </xsl:call-template>
          </eCH0271_1:basicGeodataInformation>
        </xsl:if>
      </eCH0271_1:CHE_MD_DataIdentification>
    </xsl:for-each>

    <!-- Main CHE_MD_Metadata - only allowed elements per schema -->
    <eCH0271_1:CHE_MD_Metadata ili:tid="MD_{$mdTID}">
      <!-- Only 3 properties allowed: defaultLocale, otherLocale, dateInfo -->
      
      <!-- defaultLocale -->
      <xsl:if test="mdb:defaultLocale">
        <eCH0271_1:defaultLocale>
          <xsl:call-template name="generate-default-locale">
            <xsl:with-param name="elem" select="mdb:defaultLocale[1]/*[1]"/>
          </xsl:call-template>
        </eCH0271_1:defaultLocale>
      </xsl:if>

      <!-- otherLocale: BAG of PT_Locale -->
      <xsl:for-each select="mdb:otherLocale | mdb:defaultLocale[position() > 1]">
        <eCH0271_1:otherLocale>
          <xsl:call-template name="generate-default-locale">
            <xsl:with-param name="elem" select="./*[1]"/>
          </xsl:call-template>
        </eCH0271_1:otherLocale>
      </xsl:for-each>

      <!-- dateInfo: BAG {1..*} OF CI_Date (inline STRUCTURE, no OID) -->
      <xsl:for-each select="mdb:dateInfo/*">
        <eCH0271_1:dateInfo>
          <eCH0271_1:CI_Date>
            <!-- date: MANDATORY DateTime -->
            <xsl:if test="cit:date/gco:Date | cit:date/gco:DateTime">
              <eCH0271_1:date>
                <xsl:value-of select="normalize-space((cit:date/gco:Date | cit:date/gco:DateTime)[1])"/>
              </eCH0271_1:date>
            </xsl:if>
            <!-- dateType: MANDATORY CI_DateTypeCode -->
            <xsl:if test="cit:dateType/cit:CI_DateTypeCode">
              <eCH0271_1:dateType>
                <xsl:value-of select="normalize-space((cit:dateType/cit:CI_DateTypeCode/@codeListValue | cit:dateType/cit:CI_DateTypeCode/text())[1])"/>
              </eCH0271_1:dateType>
            </xsl:if>
          </eCH0271_1:CI_Date>
        </eCH0271_1:dateInfo>
      </xsl:for-each>
    </eCH0271_1:CHE_MD_Metadata>
  </xsl:template>

  <!-- Generate CHE_CI_Organisation with contact info and individual -->
  <xsl:template name="generate-organisation">
    <xsl:param name="elem"/>
    <xsl:variable name="partyTID" select="generate-id($elem)"/>
    <xsl:if test="$elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation">
      <eCH0271_1:CHE_CI_Organisation ili:tid="PARTY_{$partyTID}">
        <xsl:if test="($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/cit:name/gco:CharacterString">
          <xsl:variable name="orgName" select="normalize-space(($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/cit:name/gco:CharacterString)"/>
          <eCH0271_1:name>
            <Localisation_V2:MultilingualMText>
              <Localisation_V2:LocalisedText>
                <Localisation_V2:LocalisedMText>
                  <Localisation_V2:Language>fr</Localisation_V2:Language>
                  <Localisation_V2:Text><xsl:value-of select="$orgName"/></Localisation_V2:Text>
                </Localisation_V2:LocalisedMText>
              </Localisation_V2:LocalisedText>
            </Localisation_V2:MultilingualMText>
          </eCH0271_1:name>
        </xsl:if>
        <!-- Contact info and individual are commented out in INTERLIS structure -->
        <xsl:if test="($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/che:organisationAcronym/gco:CharacterString">
          <eCH0271_1:organisationAcronym>
            <xsl:value-of select="normalize-space(($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/che:organisationAcronym/gco:CharacterString)"/>
          </eCH0271_1:organisationAcronym>
        </xsl:if>
      </eCH0271_1:CHE_CI_Organisation>
    </xsl:if>
  </xsl:template>

  <!-- Generate CI_Responsibility with CHE_CI_Organisation -->
  <xsl:template name="generate-responsibility">
    <xsl:param name="elem"/>
    <xsl:variable name="respTID" select="generate-id($elem)"/>
    <xsl:if test="$elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty">
      <eCH0271_1:CI_Responsibility ili:tid="RESP_{$respTID}">
        <!-- Extract role code -->
        <xsl:variable name="roleCode">
          <xsl:choose>
            <xsl:when test="($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/@codeListValue">
              <xsl:value-of select="normalize-space(($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/@codeListValue)"/>
            </xsl:when>
            <xsl:when test="($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/text()">
              <xsl:value-of select="normalize-space(($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/text())"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$roleCode != ''">
          <eCH0271_1:role><xsl:value-of select="$roleCode"/></eCH0271_1:role>
        </xsl:if>
        <!-- Party reference is handled via ASSOCIATION CI_Responsibilityparty -->
        <!-- INTERLIS ASSOCIATION: party - {1..*} CI_Party means each CI_Responsibility must reference a CI_Party (CHE_CI_Organisation or CI_Individual) -->
        <!-- However, this is enforced by the presence of CHE_CI_Organisation/CI_Individual with proper OID, not by direct reference in CI_Responsibility -->
      </eCH0271_1:CI_Responsibility>
    </xsl:if>
  </xsl:template>

  <!-- Generate CI_Citation with dates -->
  <xsl:template name="generate-citation">
    <xsl:param name="elem"/>
    <xsl:variable name="citTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_Citation ili:tid="CIT_{$citTID}">
      <xsl:if test="$elem/cit:title/gco:CharacterString">
        <xsl:variable name="citTitle" select="normalize-space($elem/cit:title/gco:CharacterString)"/>
        <eCH0271_1:title>
          <Localisation_V2:MultilingualMText>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedMText>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$citTitle"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedMText>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualMText>
        </eCH0271_1:title>
      </xsl:if>
      <!-- Process date elements from ISO citation -->
      <xsl:for-each select="$elem/cit:date/cit:CI_Date">
        <eCH0271_1:date>
          <eCH0271_1:CI_Date>
            <xsl:if test="cit:date/gco:Date | cit:date/gco:DateTime">
              <eCH0271_1:date>
                <xsl:value-of select="normalize-space((cit:date/gco:DateTime | cit:date/gco:Date)[1])"/>
              </eCH0271_1:date>
            </xsl:if>
            <xsl:if test="cit:dateType">
              <eCH0271_1:dateType>
                <xsl:variable name="dtCode" select="normalize-space((cit:dateType/cit:CI_DateTypeCode/@codeListValue | cit:dateType/cit:CI_DateTypeCode/text())[1])"/>
                <xsl:choose>
                  <xsl:when test="$dtCode = 'revised'">revision</xsl:when>
                  <xsl:otherwise><xsl:value-of select="$dtCode"/></xsl:otherwise>
                </xsl:choose>
              </eCH0271_1:dateType>
            </xsl:if>
          </eCH0271_1:CI_Date>
        </eCH0271_1:date>
      </xsl:for-each>
    </eCH0271_1:CI_Citation>
  </xsl:template>

  <!-- Generate CI_Individual -->
  <xsl:template name="generate-individual">
    <xsl:param name="elem"/>
    <xsl:variable name="individualTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_Individual ili:tid="INDIVIDUAL_{$individualTID}">
      <xsl:if test="$elem/cit:name/gco:CharacterString">
        <xsl:variable name="indName" select="normalize-space($elem/cit:name/gco:CharacterString)"/>
        <eCH0271_1:name>
          <Localisation_V2:MultilingualMText>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedMText>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$indName"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedMText>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualMText>
        </eCH0271_1:name>
      </xsl:if>
      <xsl:if test="$elem/cit:positionName/gco:CharacterString">
        <eCH0271_1:positionName>
          <xsl:value-of select="normalize-space($elem/cit:positionName/gco:CharacterString)"/>
        </eCH0271_1:positionName>
      </xsl:if>
    </eCH0271_1:CI_Individual>
  </xsl:template>

  <!-- Generate EX_Extent -->
  <xsl:template name="generate-extent">
    <xsl:param name="elem"/>
    <xsl:variable name="extTID" select="generate-id($elem)"/>
    <eCH0271_1:EX_Extent ili:tid="EXT_{$extTID}">
      <!-- Add description if present -->
      <xsl:if test="$elem/gex:description/gco:CharacterString">
        <xsl:variable name="extDesc" select="normalize-space($elem/gex:description/gco:CharacterString)"/>
        <eCH0271_1:description>
          <Localisation_V2:MultilingualMText>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedMText>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$extDesc"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedMText>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualMText>
        </eCH0271_1:description>
      </xsl:if>
    </eCH0271_1:EX_Extent>
    <!-- Generate bbox elements -->
    <xsl:for-each select="$elem/gex:geographicElement/gex:EX_GeographicBoundingBox">
      <xsl:call-template name="generate-bbox">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- Generate EX_GeographicBoundingBox -->
  <xsl:template name="generate-bbox">
    <xsl:param name="elem"/>
    <xsl:variable name="bboxTID" select="generate-id($elem)"/>
    <eCH0271_1:EX_GeographicBoundingBox ili:tid="BBOX_{$bboxTID}">
      <eCH0271_1:westBoundLongitude>
        <xsl:value-of select="normalize-space($elem/gex:westBoundLongitude/gco:Decimal)"/>
      </eCH0271_1:westBoundLongitude>
      <eCH0271_1:eastBoundLongitude>
        <xsl:value-of select="normalize-space($elem/gex:eastBoundLongitude/gco:Decimal)"/>
      </eCH0271_1:eastBoundLongitude>
      <eCH0271_1:southBoundLatitude>
        <xsl:value-of select="normalize-space($elem/gex:southBoundLatitude/gco:Decimal)"/>
      </eCH0271_1:southBoundLatitude>
      <eCH0271_1:northBoundLatitude>
        <xsl:value-of select="normalize-space($elem/gex:northBoundLatitude/gco:Decimal)"/>
      </eCH0271_1:northBoundLatitude>
    </eCH0271_1:EX_GeographicBoundingBox>
  </xsl:template>

  <!-- Generate MD_Distribution with online resources and transfer options -->
  <xsl:template name="generate-distribution">
    <xsl:param name="elem"/>
    <xsl:variable name="distTID" select="generate-id($elem)"/>
    <!-- Generate CI_OnlineResource elements first -->
    <xsl:for-each select="$elem/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource">
      <xsl:call-template name="generate-online-resource">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- Generate MD_Distribution element with explicit closing tag (not self-closing) -->
    <eCH0271_1:MD_Distribution ili:tid="DIST_{$distTID}"></eCH0271_1:MD_Distribution>
  </xsl:template>

  <!-- Generate CI_OnlineResource -->
  <xsl:template name="generate-online-resource">
    <xsl:param name="elem"/>
    <xsl:variable name="orTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_OnlineResource ili:tid="OR_{$orTID}">
      <xsl:if test="$elem/cit:linkage/gco:CharacterString">
        <xsl:variable name="linkageUrl" select="normalize-space($elem/cit:linkage/gco:CharacterString)"/>
        <eCH0271_1:linkage>
          <Localisation_V2:MultilingualUri>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedUri>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$linkageUrl"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedUri>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualUri>
        </eCH0271_1:linkage>
      </xsl:if>
      <xsl:if test="$elem/cit:protocol/gco:CharacterString">
        <eCH0271_1:protocol>
          <xsl:value-of select="normalize-space($elem/cit:protocol/gco:CharacterString)"/>
        </eCH0271_1:protocol>
      </xsl:if>
      <xsl:if test="$elem/cit:function/cit:CI_OnLineFunctionCode/@codeListValue | $elem/cit:function/cit:CI_OnLineFunctionCode/text()">
        <eCH0271_1:function>
          <xsl:value-of select="normalize-space(($elem/cit:function/cit:CI_OnLineFunctionCode/@codeListValue | $elem/cit:function/cit:CI_OnLineFunctionCode/text())[1])"/>
        </eCH0271_1:function>
      </xsl:if>
      <xsl:if test="$elem/cit:description/gco:CharacterString">
        <xsl:variable name="orDesc" select="normalize-space($elem/cit:description/gco:CharacterString)"/>
        <eCH0271_1:description>
          <Localisation_V2:MultilingualMText>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedMText>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$orDesc"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedMText>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualMText>
        </eCH0271_1:description>
      </xsl:if>
      <xsl:if test="$elem/cit:name/gco:CharacterString">
        <xsl:variable name="orName" select="normalize-space($elem/cit:name/gco:CharacterString)"/>
        <eCH0271_1:name>
          <Localisation_V2:MultilingualMText>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedMText>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$orName"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedMText>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualMText>
        </eCH0271_1:name>
      </xsl:if>
    </eCH0271_1:CI_OnlineResource>
  </xsl:template>

  <!-- Generate CHE_MD_Legislation -->
  <xsl:template name="generate-legislation">
    <xsl:param name="elem"/>
    <xsl:variable name="legTID" select="generate-id($elem)"/>
    <!-- Check if this is CHE_MD_Legislation -->
    <xsl:if test="$elem/self::che:CHE_MD_Legislation">
      <eCH0271_1:CHE_MD_Legislation ili:tid="LEG_{$legTID}">
        <!-- Extract country from lan:CountryCode -->
        <xsl:if test="$elem/che:country/lan:CountryCode">
          <eCH0271_1:country>
            <xsl:choose>
              <xsl:when test="$elem/che:country/lan:CountryCode/@codeListValue = 'CH'">
                <xsl:text>CHE</xsl:text>
              </xsl:when>
              <xsl:when test="$elem/che:country/lan:CountryCode/@codeListValue">
                <xsl:value-of select="normalize-space($elem/che:country/lan:CountryCode/@codeListValue)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($elem/che:country/lan:CountryCode/text())"/>
              </xsl:otherwise>
            </xsl:choose>
          </eCH0271_1:country>
        </xsl:if>
        <!-- Extract legislationType -->
        <xsl:if test="$elem/che:legislationType/che:CHE_CI_LegislationTypeCode">
          <eCH0271_1:legislationType>
            <xsl:choose>
              <xsl:when test="$elem/che:legislationType/che:CHE_CI_LegislationTypeCode/@codeListValue">
                <xsl:value-of select="normalize-space($elem/che:legislationType/che:CHE_CI_LegislationTypeCode/@codeListValue)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($elem/che:legislationType/che:CHE_CI_LegislationTypeCode/text())"/>
              </xsl:otherwise>
            </xsl:choose>
          </eCH0271_1:legislationType>
        </xsl:if>
        <!-- Extract internalReference -->
        <xsl:if test="$elem/che:internalReference/gco:CharacterString">
          <eCH0271_1:internalReference>
            <xsl:value-of select="normalize-space($elem/che:internalReference/gco:CharacterString)"/>
          </eCH0271_1:internalReference>
        </xsl:if>
        <!-- Generate legislationCitation reference -->
        <xsl:if test="$elem/che:legislationCitation/cit:CI_Citation">
          <xsl:variable name="citTID" select="generate-id($elem/che:legislationCitation/cit:CI_Citation)"/>
          <eCH0271_1:legislationCitation ili:ref="CIT_{$citTID}"/>
        </xsl:if>
      </eCH0271_1:CHE_MD_Legislation>
    </xsl:if>
  </xsl:template>

  <!-- Generate CI_Contact (empty shell) -->
  <xsl:template name="generate-contact">
    <xsl:param name="elem"/>
    <xsl:variable name="contactTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_Contact ili:tid="CONTACT_{$contactTID}">
      <!-- Contact properties are not directly included in eCH0271 CI_Contact element -->
    </eCH0271_1:CI_Contact>
  </xsl:template>

  <!-- Generate CI_Address -->
  <xsl:template name="generate-address">
    <xsl:param name="elem"/>
    <xsl:variable name="addressTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_Address ili:tid="ADDR_{$addressTID}">
      <xsl:if test="$elem/cit:deliveryPoint/gco:CharacterString">
        <eCH0271_1:deliveryPoint>
          <xsl:value-of select="normalize-space($elem/cit:deliveryPoint/gco:CharacterString)"/>
        </eCH0271_1:deliveryPoint>
      </xsl:if>
      <xsl:if test="$elem/cit:city/gco:CharacterString">
        <eCH0271_1:city>
          <xsl:value-of select="normalize-space($elem/cit:city/gco:CharacterString)"/>
        </eCH0271_1:city>
      </xsl:if>
      <xsl:if test="$elem/cit:administrativeArea/gco:CharacterString">
        <eCH0271_1:administrativeArea>
          <xsl:value-of select="normalize-space($elem/cit:administrativeArea/gco:CharacterString)"/>
        </eCH0271_1:administrativeArea>
      </xsl:if>
      <xsl:if test="$elem/cit:postalCode/gco:CharacterString">
        <eCH0271_1:postalCode>
          <xsl:value-of select="normalize-space($elem/cit:postalCode/gco:CharacterString)"/>
        </eCH0271_1:postalCode>
      </xsl:if>
      <xsl:if test="$elem/cit:country/gco:CharacterString">
        <eCH0271_1:country>
          <xsl:choose>
            <xsl:when test="normalize-space($elem/cit:country/gco:CharacterString) = 'CH'">CHE</xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space($elem/cit:country/gco:CharacterString)"/></xsl:otherwise>
          </xsl:choose>
        </eCH0271_1:country>
      </xsl:if>
      <xsl:if test="$elem/cit:electronicMailAddress/gco:CharacterString">
        <eCH0271_1:electronicMailAddress>
          <xsl:value-of select="normalize-space($elem/cit:electronicMailAddress/gco:CharacterString)"/>
        </eCH0271_1:electronicMailAddress>
      </xsl:if>
    </eCH0271_1:CI_Address>
  </xsl:template>

  <!-- Generate CHE_MD_MaintenanceInformation -->
  <xsl:template name="generate-maintenance-info">
    <xsl:param name="elem"/>
    <xsl:variable name="rmTID" select="generate-id($elem)"/>
    <eCH0271_1:CHE_MD_MaintenanceInformation ili:tid="RM_{$rmTID}">
      <xsl:if test="$elem/mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode">
        <eCH0271_1:maintenanceAndUpdateFrequency>
          <xsl:value-of select="normalize-space(($elem/mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeListValue | $elem/mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/text())[1])"/>
        </eCH0271_1:maintenanceAndUpdateFrequency>
      </xsl:if>
      <xsl:if test="$elem/mmi:maintenanceNote/gco:CharacterString">
        <eCH0271_1:maintenanceNote>
          <xsl:value-of select="normalize-space($elem/mmi:maintenanceNote/gco:CharacterString)"/>
        </eCH0271_1:maintenanceNote>
      </xsl:if>
    </eCH0271_1:CHE_MD_MaintenanceInformation>
  </xsl:template>

  <!-- Generate MD_BrowseGraphic -->
  <xsl:template name="generate-browse-graphic">
    <xsl:param name="elem"/>
    <xsl:variable name="goTID" select="generate-id($elem)"/>
    <eCH0271_1:MD_BrowseGraphic ili:tid="GO_{$goTID}">
      <xsl:if test="$elem/mcc:fileName/gco:CharacterString">
        <eCH0271_1:fileName>
          <xsl:value-of select="normalize-space($elem/mcc:fileName/gco:CharacterString)"/>
        </eCH0271_1:fileName>
      </xsl:if>
      <xsl:if test="$elem/mcc:fileDescription/gco:CharacterString">
        <eCH0271_1:fileDescription>
          <xsl:value-of select="normalize-space($elem/mcc:fileDescription/gco:CharacterString)"/>
        </eCH0271_1:fileDescription>
      </xsl:if>
    </eCH0271_1:MD_BrowseGraphic>
  </xsl:template>

  <!-- Generate MD_LegalConstraints -->
  <xsl:template name="generate-legal-constraints">
    <xsl:param name="elem"/>
    <xsl:variable name="rcTID" select="generate-id($elem)"/>
    <eCH0271_1:CHE_MD_LegalConstraints ili:tid="RC_{$rcTID}">
      <xsl:if test="$elem/mco:useConstraints/mco:MD_RestrictionCode">
        <eCH0271_1:useConstraints>
          <xsl:value-of select="normalize-space(($elem/mco:useConstraints/mco:MD_RestrictionCode/@codeListValue | $elem/mco:useConstraints/mco:MD_RestrictionCode/text())[1])"/>
        </eCH0271_1:useConstraints>
      </xsl:if>
      <xsl:if test="$elem/mco:otherConstraints/gco:CharacterString">
        <xsl:variable name="otherCons" select="normalize-space($elem/mco:otherConstraints/gco:CharacterString)"/>
        <eCH0271_1:otherConstraints>
          <Localisation_V2:MultilingualMText>
            <Localisation_V2:LocalisedText>
              <Localisation_V2:LocalisedMText>
                <Localisation_V2:Language>fr</Localisation_V2:Language>
                <Localisation_V2:Text><xsl:value-of select="$otherCons"/></Localisation_V2:Text>
              </Localisation_V2:LocalisedMText>
            </Localisation_V2:LocalisedText>
          </Localisation_V2:MultilingualMText>
        </eCH0271_1:otherConstraints>
      </xsl:if>
    </eCH0271_1:CHE_MD_LegalConstraints>
  </xsl:template>

  <!-- Generate PT_Locale (for defaultLocale in DataIdentification) -->
  <xsl:template name="generate-default-locale">
    <xsl:param name="elem"/>
    <eCH0271_1:PT_Locale>
      <xsl:if test="$elem/lan:language/lan:LanguageCode">
        <eCH0271_1:language>
          <xsl:choose>
            <xsl:when test="normalize-space(($elem/lan:language/lan:LanguageCode/@codeListValue | $elem/lan:language/lan:LanguageCode/text())[1]) = 'fre'">fr</xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(($elem/lan:language/lan:LanguageCode/@codeListValue | $elem/lan:language/lan:LanguageCode/text())[1])"/></xsl:otherwise>
          </xsl:choose>
        </eCH0271_1:language>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$elem/lan:characterEncoding/lan:MD_CharacterSetCode and not($elem/lan:characterEncoding/lan:MD_CharacterSetCode/@gco:nilReason)">
          <eCH0271_1:characterEncoding>
            <xsl:value-of select="normalize-space(($elem/lan:characterEncoding/lan:MD_CharacterSetCode/@codeListValue | $elem/lan:characterEncoding/lan:MD_CharacterSetCode/text())[1])"/>
          </eCH0271_1:characterEncoding>
        </xsl:when>
        <xsl:otherwise>
          <!-- Default to utf8 if not specified or nil -->
          <eCH0271_1:characterEncoding>utf8</eCH0271_1:characterEncoding>
        </xsl:otherwise>
      </xsl:choose>
    </eCH0271_1:PT_Locale>
  </xsl:template>

  <!-- Generate CHE_MD_BasicGeodataInformation -->
  <xsl:template name="generate-basicgeodatainformation">
    <xsl:param name="elem"/>
    <eCH0271_1:CHE_MD_BasicGeodataInformation>
      <xsl:if test="$elem/che:CHE_MD_BasicGeodataInformation/che:basicGeodataID/gco:CharacterString">
        <eCH0271_1:basicGeodataID>
          <xsl:value-of select="normalize-space($elem/che:CHE_MD_BasicGeodataInformation/che:basicGeodataID/gco:CharacterString)"/>
        </eCH0271_1:basicGeodataID>
      </xsl:if>
      <xsl:if test="$elem/che:CHE_MD_BasicGeodataInformation/che:basicGeodataLegalLevel/che:CHE_MD_LevelCode">
        <eCH0271_1:basicGeodataLegalLevel>
          <xsl:value-of select="normalize-space(($elem/che:CHE_MD_BasicGeodataInformation/che:basicGeodataLegalLevel/che:CHE_MD_LevelCode/@codeListValue | $elem/che:CHE_MD_BasicGeodataInformation/che:basicGeodataLegalLevel/che:CHE_MD_LevelCode/text())[1])"/>
        </eCH0271_1:basicGeodataLegalLevel>
      </xsl:if>
    </eCH0271_1:CHE_MD_BasicGeodataInformation>
  </xsl:template>

  <xsl:template match="text()|@*" priority="-10"/>
</xsl:stylesheet>
