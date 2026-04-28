<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mpc="http://standards.iso.org/iso/19115/-3/mpc/1.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:che="http://geocat.ch/che"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:adms="http://www.w3.org/ns/adms#"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:local="http://local-functions"
                exclude-result-prefixes="#all">

  <!-- ================================================ -->
  <!-- DCAT-AP CH MAPPING FROM ISO 19115-3 CHE        -->
  <!-- Based on opendata.swiss documentation           -->
  <!-- https://handbook.opendata.swiss/de/content/glossar/bibliothek/dcat-ap-ch.html -->
  <!-- ================================================ -->

  <!-- ================================================ -->
  <!-- MAIN TEMPLATE: CHE_MD_Metadata to dcat:Dataset  -->
  <!-- ================================================ -->
  
  <xsl:template match="che:CHE_MD_Metadata" mode="iso19115-3-to-dcat">
    <xsl:variable name="uuid" select="mdb:metadataIdentifier/*/mcc:code/*/text()"/>
    <xsl:variable name="resourceUri" select="concat('https://www.geocat.ch/geonetwork/srv/api/records/', $uuid, '/formatters/dcat-ap-ch')"/>
    
    <dcat:Dataset rdf:about="{$resourceUri}">
      <!-- 1. TYPE -->
      <!-- <rdf:type rdf:resource="http://www.w3.org/ns/dcat#Dataset"/> -->
      
      <!-- 2. IDENTIFIER -->
      <dct:identifier><xsl:value-of select="$uuid"/></dct:identifier>
      
      <!-- 3. TITLE -->
      <xsl:call-template name="multilingual-field">
        <xsl:with-param name="nodes" select="mdb:identificationInfo/*/mri:citation/*/cit:title"/>
        <xsl:with-param name="property" select="'dct:title'"/>
      </xsl:call-template>
      
      <!-- 4. DESCRIPTION -->
      <xsl:call-template name="multilingual-field">
        <xsl:with-param name="nodes" select="mdb:identificationInfo/*/mri:abstract"/>
        <xsl:with-param name="property" select="'dct:description'"/>
      </xsl:call-template>
      
      <!-- 5. PUBLISHER -->
      <xsl:call-template name="add-publisher"/>
      
      <!-- 6. CONTACT POINT -->
      <xsl:call-template name="add-contact-point"/>
      
      <!-- 7. DISTRIBUTIONS -->
      <xsl:call-template name="add-distributions"/>
      
      <!-- 8. DATES -->
      <xsl:call-template name="add-dates"/>
      
      <!-- 9. THEMES -->
      <xsl:call-template name="add-themes"/>
      
      <!-- 10. LANDING PAGE -->
      <xsl:call-template name="add-landing-page"/>
      
      <!-- 11. RELATION -->
      <xsl:call-template name="add-geocat-relation"/>
      
      <!-- 12. LANGUAGES -->
      <xsl:call-template name="add-languages"/>
      
      <!-- 13. KEYWORDS -->
      <xsl:call-template name="add-keywords"/>
      
      <!-- 14. SPATIAL -->
      <xsl:call-template name="add-spatial"/>
      
      <!-- 15. TEMPORAL -->
      <xsl:call-template name="add-temporal"/>
      
      <!-- 16. ACCRUAL PERIODICITY -->
      <xsl:call-template name="add-accrual-periodicity"/>
      
      <!-- 17. QUALIFIED RELATION -->
      <xsl:call-template name="add-qualified-relation"/>
      
      <!-- 18. DOCUMENTATION -->
      <xsl:call-template name="add-documentation"/>
      
      <!-- 19. CONFORMS TO -->
      <xsl:call-template name="add-conforms-to"/>
    </dcat:Dataset>
  </xsl:template>

  <!-- ================================================ -->
  <!-- HELPER TEMPLATES                                -->
  <!-- ================================================ -->

  <!-- 1. MULTILINGUAL FIELD PROCESSING -->
  <xsl:template name="multilingual-field">
    <xsl:param name="nodes"/>
    <xsl:param name="property"/>
    
    <!-- Process default language -->
    <xsl:for-each select="$nodes/gco:CharacterString[normalize-space() != '']">
      <xsl:variable name="defaultLang" select="ancestor::che:CHE_MD_Metadata/mdb:defaultLocale/*/lan:language/*/@codeListValue"/>
      <xsl:variable name="langCode" select="local:iso639-to-2letter($defaultLang)"/>
      <!-- Skip unsupported language codes (conversion returns empty string for unmapped ISO 639-2 codes) -->
      <xsl:if test="$langCode != ''">
        <xsl:element name="{$property}">
          <xsl:attribute name="xml:lang" select="$langCode"/>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
    
    <!-- Process localized strings -->
    <xsl:for-each select="$nodes/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[normalize-space() != '']">
      <xsl:variable name="localeId" select="substring-after(@locale, '#')"/>
      <xsl:variable name="langCode3" select="
        ancestor::che:CHE_MD_Metadata/mdb:locale/*[@id = $localeId]/mdb:languageCode/*/@codeListValue |
        ancestor::che:CHE_MD_Metadata/mdb:otherLocale/*[@id = $localeId]/lan:language/*/@codeListValue
      "/>
      <xsl:variable name="langCode" select="local:iso639-to-2letter($langCode3)"/>
      <!-- Skip undefined languages -->
      <xsl:if test="$langCode != ''">
        <xsl:element name="{$property}">
          <xsl:attribute name="xml:lang" select="$langCode"/>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- 3. ADD PUBLISHER -->
  <xsl:template name="add-publisher">
    <xsl:variable name="publisherOrg" select="local:get-candidate-org(.)"/>
    
    <xsl:if test="$publisherOrg">
      <!-- Try to get URL from contact's onlineResource -->
      <xsl:variable name="orgUrl" select="normalize-space(($publisherOrg/cit:contactInfo/*/cit:onlineResource/*/cit:linkage/*/text())[1])"/>
      
      <dct:publisher>
        <xsl:choose>
          <xsl:when test="$orgUrl != ''">
            <foaf:Agent rdf:about="{$orgUrl}">
              <xsl:call-template name="multilingual-field">
                <xsl:with-param name="nodes" select="$publisherOrg/cit:name"/>
                <xsl:with-param name="property" select="'foaf:name'"/>
              </xsl:call-template>
            </foaf:Agent>
          </xsl:when>
          <xsl:otherwise>
            <foaf:Agent>
              <xsl:call-template name="multilingual-field">
                <xsl:with-param name="nodes" select="$publisherOrg/cit:name"/>
                <xsl:with-param name="property" select="'foaf:name'"/>
              </xsl:call-template>
            </foaf:Agent>
          </xsl:otherwise>
        </xsl:choose>
      </dct:publisher>
    </xsl:if>
  </xsl:template>

  <!-- 4. ADD CONTACT POINT -->
  <xsl:template name="add-contact-point">
    <xsl:variable name="contacts" select="
      mdb:identificationInfo/*/mri:pointOfContact[cit:CI_Responsibility/cit:role/*/@codeListValue = 'pointOfContact'] |
      mdb:identificationInfo/*/mri:pointOfContact[cit:CI_Responsibility/cit:role/*/@codeListValue = 'owner'] |
      mdb:contact[cit:CI_Responsibility]
    "/>
    
    <xsl:for-each select="$contacts[1]">
      <xsl:variable name="contactOrg" select="*/cit:party/che:CHE_CI_Organisation"/>
      <xsl:variable name="email" select="normalize-space($contactOrg/cit:contactInfo/*/cit:address/*/cit:electronicMailAddress[1]/gco:CharacterString)"/>
      <xsl:variable name="orgName" select="normalize-space($contactOrg/cit:name/gco:CharacterString)"/>
      
      <xsl:if test="$contactOrg and $email != ''">
        <dcat:contactPoint>
          <vcard:Organization>
            <vcard:fn>
              <xsl:value-of select="$orgName"/>
            </vcard:fn>
            <vcard:hasEmail rdf:resource="mailto:{$email}"/>
          </vcard:Organization>
        </dcat:contactPoint>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- 5. ADD DISTRIBUTIONS -->
  <xsl:template name="add-distributions">
    <!-- Filter online resources based on protocol -->
    <xsl:for-each select="mdb:distributionInfo//mrd:onLine">
      <xsl:variable name="protocol" select="normalize-space((*/cit:protocol/*/text())[1])"/>
      <xsl:variable name="url" select="normalize-space((*/cit:linkage/*/text())[1])"/>
      <!-- Check if this should be a DCAT distribution -->
      <xsl:if test="
        starts-with($protocol, 'WWW:DOWNLOAD') or
        starts-with($protocol, 'OGC:WMTS') or
        starts-with($protocol, 'OGC:WFS') or
        starts-with($protocol, 'OGC:WMS') or
        starts-with($protocol, 'ESRI:REST') or
        starts-with($protocol, 'LINKED:DATA') or
        starts-with($protocol, 'MAP:Preview')
      ">
        <xsl:variable name="datasetUuid" select="ancestor::che:CHE_MD_Metadata/mdb:metadataIdentifier/*/mcc:code/*/text()"/>
        <xsl:variable name="distributionUri" select="concat('https://www.geocat.ch/geonetwork/srv/api/records/', $datasetUuid, '/distributions/', position())"/>
        <dcat:distribution>
          <dcat:Distribution rdf:about="{$distributionUri}">
            <!-- Access URL -->
            <dcat:accessURL rdf:resource="{$url}"/>
            <!-- Download URL for download protocols -->
            <xsl:if test="starts-with($protocol, 'WWW:DOWNLOAD')">
              <dcat:downloadURL rdf:resource="{$url}"/>
            </xsl:if>
            <!-- Title -->
            <xsl:call-template name="multilingual-field">
              <xsl:with-param name="nodes" select="*/cit:name"/>
              <xsl:with-param name="property" select="'dct:title'"/>
            </xsl:call-template>
            <!-- Description -->
            <xsl:call-template name="multilingual-field">
              <xsl:with-param name="nodes" select="*/cit:description"/>
              <xsl:with-param name="property" select="'dct:description'"/>
            </xsl:call-template>
            <!-- Format -->
            <xsl:call-template name="add-format">
              <xsl:with-param name="protocol" select="$protocol"/>
              <xsl:with-param name="url" select="$url"/>
            </xsl:call-template>
            <!-- Media Type -->
            <xsl:call-template name="add-media-type">
              <xsl:with-param name="protocol" select="$protocol"/>
            </xsl:call-template>
            <!-- Rights/License mandatory - extracted from metadata constraints -->
            <xsl:call-template name="add-distribution-license"/>
            <!-- Dates mandatory: issued/modified (taken from parent dataset if not available) -->
            <xsl:variable name="dates" select="ancestor::che:CHE_MD_Metadata/mdb:identificationInfo/*/mri:citation/*/cit:date"/>
            <xsl:variable name="issued" select="
              ($dates[*/cit:dateType/*/@codeListValue = 'publication']/*/cit:date/gco:Date/text())[1] |
              ($dates[*/cit:dateType/*/@codeListValue = 'publication']/*/cit:date/gco:DateTime/text())[1] |
              ($dates[*/cit:dateType/*/@codeListValue = 'creation']/*/cit:date/gco:Date/text())[1] |
              ($dates[*/cit:dateType/*/@codeListValue = 'creation']/*/cit:date/gco:DateTime/text())[1] |
              ($dates[*/cit:dateType/*/@codeListValue = 'revision']/*/cit:date/gco:Date/text())[1] |
              ($dates[*/cit:dateType/*/@codeListValue = 'revision']/*/cit:date/gco:DateTime/text())[1]
            "/>
            <xsl:if test="$issued[1] != ''">
              <dct:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                <xsl:value-of select="local:format-datetime($issued[1])"/>
              </dct:issued>
            </xsl:if>
            <xsl:variable name="modified" select="
              ($dates[*/cit:dateType/*/@codeListValue = 'revision']/*/cit:date/gco:Date/text())[1] |
              ($dates[*/cit:dateType/*/@codeListValue = 'revision']/*/cit:date/gco:DateTime/text())[1]
            "/>
            <xsl:if test="$modified[1] != ''">
              <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
                <xsl:value-of select="local:format-datetime($modified[1])"/>
              </dct:modified>
            </xsl:if>
            <!-- Langues (du dataset parent) -->
            <xsl:variable name="defaultLang" select="ancestor::che:CHE_MD_Metadata/mdb:defaultLocale/*/lan:language/*/@codeListValue"/>
            <xsl:if test="$defaultLang != ''">
              <dct:language rdf:resource="http://publications.europa.eu/resource/authority/language/{local:iso639-to-eu($defaultLang)}"/>
            </xsl:if>
            <xsl:for-each select="ancestor::che:CHE_MD_Metadata/mdb:otherLocale/*/lan:language/*/@codeListValue">
              <xsl:if test=". != $defaultLang">
                <dct:language rdf:resource="http://publications.europa.eu/resource/authority/language/{local:iso639-to-eu(.)}"/>
              </xsl:if>
            </xsl:for-each>
          </dcat:Distribution>
        </dcat:distribution>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- 6. ADD DATES -->
  <xsl:template name="add-dates">
    <xsl:variable name="dates" select="mdb:identificationInfo/*/mri:citation/*/cit:date"/>
    
    <!-- Issued date: publication or creation -->
    <xsl:variable name="issued" select="
      ($dates[*/cit:dateType/*/@codeListValue = 'publication']/*/cit:date/gco:Date/text())[1] |
      ($dates[*/cit:dateType/*/@codeListValue = 'publication']/*/cit:date/gco:DateTime/text())[1] |
      ($dates[*/cit:dateType/*/@codeListValue = 'creation']/*/cit:date/gco:Date/text())[1] |
      ($dates[*/cit:dateType/*/@codeListValue = 'creation']/*/cit:date/gco:DateTime/text())[1]
    "/>
    <xsl:if test="$issued[1] != ''">
      <dct:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
        <xsl:value-of select="local:format-datetime($issued[1])"/>
      </dct:issued>
    </xsl:if>
    
    <!-- Modified date: revision -->
    <xsl:variable name="modified" select="
      ($dates[*/cit:dateType/*/@codeListValue = 'revision']/*/cit:date/gco:Date/text())[1] |
      ($dates[*/cit:dateType/*/@codeListValue = 'revision']/*/cit:date/gco:DateTime/text())[1]
    "/>
    <xsl:if test="$modified[1] != ''">
      <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
        <xsl:value-of select="local:format-datetime($modified[1])"/>
      </dct:modified>
    </xsl:if>
  </xsl:template>

  <!-- 7. ADD THEMES -->
  <xsl:template name="add-themes">
    <xsl:for-each select="mdb:identificationInfo/*/mri:topicCategory/mri:MD_TopicCategoryCode">
      <xsl:variable name="category" select="text()"/>
      
      <!-- Map ISO topicCategory to EU data themes -->
      <xsl:variable name="theme">
        <xsl:choose>
          <!-- Geography and territory -->
          <xsl:when test="
            starts-with($category, 'imageryBaseMapsEarthCover') or
            $category = 'location' or $category = 'elevation' or
            $category = 'boundaries' or starts-with($category, 'planningCadastre') or
            starts-with($category, 'geoscientificInformation') or $category = 'structure'
          ">REGI</xsl:when>
          
          <!-- Environment -->
          <xsl:when test="
            starts-with($category, 'environment') or $category = 'biota' or
            $category = 'oceans' or $category = 'inlandWaters' or
            $category = 'climatologyMeteorologyAtmosphere'
          ">ENVI</xsl:when>
          
          <!-- Society -->
          <xsl:when test="$category = 'society'">SOCI</xsl:when>
          
          <!-- Health -->
          <xsl:when test="$category = 'health'">HEAL</xsl:when>
          
          <!-- Transport -->
          <xsl:when test="$category = 'transportation'">TRAN</xsl:when>
          
          <!-- Agriculture -->
          <xsl:when test="$category = 'farming'">AGRI</xsl:when>
          
          <!-- Economy -->
          <xsl:when test="$category = 'economy'">ECON</xsl:when>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:if test="$theme != ''">
        <dcat:theme rdf:resource="http://publications.europa.eu/resource/authority/data-theme/{$theme}"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- 8. ADD LANDING PAGE -->
  <xsl:template name="add-landing-page">
    <!-- First WWW:LINK resource from distribution -->
    <xsl:variable name="landingPageFromDist" select="
      normalize-space((mdb:distributionInfo//mrd:onLine[
        starts-with((*/cit:protocol/*/text())[1], 'WWW:LINK')
      ]/*/cit:linkage/gco:CharacterString/text())[1])
    "/>
    
    <!-- If not found in distribution, try contact onlineResource -->
    <xsl:variable name="landingPageFromContact" select="
      normalize-space((mdb:contact//cit:onlineResource[
        starts-with((*/cit:protocol/*/text())[1], 'WWW:LINK')
      ]/*/cit:linkage/gco:CharacterString/text())[1])
    "/>
    
    <!-- Use first available -->
    <xsl:variable name="landingPage" select="
      if ($landingPageFromDist != '') then $landingPageFromDist
      else $landingPageFromContact
    "/>
    
    <xsl:if test="$landingPage != ''">
      <dcat:landingPage rdf:resource="{$landingPage}"/>
    </xsl:if>
  </xsl:template>

  <!-- 9. ADD GEOCAT RELATION -->
  <xsl:template name="add-geocat-relation">
    <xsl:variable name="uuid" select="mdb:metadataIdentifier/*/mcc:code/*/text()"/>
    <xsl:variable name="geocatUrl" select="concat('https://www.geocat.ch/datahub/dataset/', $uuid)"/>
    
    <dct:relation>
      <rdf:Description rdf:about="{$geocatUrl}">
        <rdfs:label xml:lang="de">geocat.ch Permalink</rdfs:label>
        <rdfs:label xml:lang="fr">geocat.ch permalien</rdfs:label>
        <rdfs:label xml:lang="it">geocat.ch link permanente</rdfs:label>
        <rdfs:label xml:lang="en">geocat.ch permalink</rdfs:label>
      </rdf:Description>
    </dct:relation>
  </xsl:template>

  <!-- 10. ADD LANGUAGES -->
  <xsl:template name="add-languages">
    <!-- Default language -->
    <xsl:variable name="defaultLang" select="mdb:defaultLocale/*/lan:language/*/@codeListValue"/>
    <xsl:if test="$defaultLang != ''">
      <dct:language rdf:resource="http://publications.europa.eu/resource/authority/language/{local:iso639-to-eu($defaultLang)}"/>
    </xsl:if>
    
    <!-- Other languages -->
    <xsl:for-each select="mdb:otherLocale/*/lan:language/*/@codeListValue">
      <xsl:if test=". != $defaultLang">
        <dct:language rdf:resource="http://publications.europa.eu/resource/authority/language/{local:iso639-to-eu(.)}"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- 11. ADD KEYWORDS -->
  <xsl:template name="add-keywords">
    <xsl:for-each select="mdb:identificationInfo/*/mri:descriptiveKeywords/*/mri:keyword">
      <!-- Default language keyword -->
      <xsl:for-each select="gco:CharacterString[normalize-space() != '']">
        <xsl:variable name="defaultLang" select="ancestor::che:CHE_MD_Metadata/mdb:defaultLocale/*/lan:language/*/@codeListValue"/>
        <xsl:variable name="langCode" select="local:iso639-to-2letter($defaultLang)"/>
        <xsl:if test="$langCode != ''">
          <dcat:keyword xml:lang="{$langCode}">
            <xsl:value-of select="normalize-space(.)"/>
          </dcat:keyword>
        </xsl:if>
      </xsl:for-each>
      
      <!-- Localized keywords -->
      <xsl:for-each select="lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[normalize-space() != '']">
        <xsl:variable name="localeId" select="substring-after(@locale, '#')"/>
        <xsl:variable name="langCode3" select="
          ancestor::che:CHE_MD_Metadata/mdb:locale/*[@id = $localeId]/mdb:languageCode/*/@codeListValue |
          ancestor::che:CHE_MD_Metadata/mdb:otherLocale/*[@id = $localeId]/lan:language/*/@codeListValue
        "/>
        <xsl:variable name="langCode" select="local:iso639-to-2letter($langCode3)"/>
        <xsl:if test="$langCode != ''">
          <dcat:keyword xml:lang="{$langCode}">
            <xsl:value-of select="normalize-space(.)"/>
          </dcat:keyword>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <!-- 12. ADD SPATIAL -->
  <xsl:template name="add-spatial">
    <xsl:variable name="spatial" select="
      mdb:identificationInfo/*/mri:extent/*/gex:description/gco:CharacterString/text() |
      mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/gex:EX_GeographicDescription/gex:geographicIdentifier/*/mcc:code/gco:CharacterString/text()
    "/>
    
    <xsl:if test="$spatial[1] != ''">
      <dct:spatial><xsl:value-of select="$spatial[1]"/></dct:spatial>
    </xsl:if>
  </xsl:template>

  <!-- 13. ADD TEMPORAL -->
  <xsl:template name="add-temporal">
    <xsl:variable name="begin" select="
      mdb:identificationInfo/*/mri:extent/*/gex:temporalElement/*/gex:extent/*/gml:beginPosition/text()
    "/>
    <xsl:variable name="end" select="
      mdb:identificationInfo/*/mri:extent/*/gex:temporalElement/*/gex:extent/*/gml:endPosition/text()
    "/>
    
    <xsl:if test="$begin != '' or $end != ''">
      <dct:temporal>
        <dct:PeriodOfTime>
          <xsl:if test="$begin != ''">
            <dcat:startDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
              <xsl:value-of select="$begin"/>
            </dcat:startDate>
          </xsl:if>
          <xsl:if test="$end != ''">
            <dcat:endDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
              <xsl:value-of select="$end"/>
            </dcat:endDate>
          </xsl:if>
        </dct:PeriodOfTime>
      </dct:temporal>
    </xsl:if>
  </xsl:template>

  <!-- 14. ADD ACCRUAL PERIODICITY -->
  <xsl:template name="add-accrual-periodicity">
    <xsl:variable name="frequency" select="
      mdb:identificationInfo/*/mri:resourceMaintenance/*/mmi:maintenanceAndUpdateFrequency/*/@codeListValue
    "/>
    
    <xsl:variable name="euFrequency">
      <xsl:choose>
        <xsl:when test="$frequency = 'continual'">CONT</xsl:when>
        <xsl:when test="$frequency = 'daily'">DAILY</xsl:when>
        <xsl:when test="$frequency = 'weekly'">WEEKLY</xsl:when>
        <xsl:when test="$frequency = 'fortnightly'">BIWEEKLY</xsl:when>
        <xsl:when test="$frequency = 'monthly'">MONTHLY</xsl:when>
        <xsl:when test="$frequency = 'quarterly'">QUARTERLY</xsl:when>
        <xsl:when test="$frequency = 'biannually'">ANNUAL_2</xsl:when>
        <xsl:when test="$frequency = 'annually'">ANNUAL</xsl:when>
        <xsl:when test="$frequency = 'asNeeded'">IRREG</xsl:when>
        <xsl:when test="$frequency = 'irregular'">IRREG</xsl:when>
        <!-- Fallback: if no frequency specified, default to UNKNOWN -->
        <xsl:otherwise>UNKNOWN</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:if test="$euFrequency != ''">
      <dct:accrualPeriodicity rdf:resource="http://publications.europa.eu/resource/authority/frequency/{$euFrequency}"/>
    </xsl:if>
  </xsl:template>

  <!-- 15. ADD QUALIFIED RELATION -->
  <xsl:template name="add-qualified-relation">
    <xsl:for-each select="mdb:identificationInfo/*/mri:aggregationInfo/*/mri:aggregateDataSetIdentifier/*/mcc:code[gco:CharacterString/text() != '']">
      <xsl:variable name="relatedUuid" select="gco:CharacterString/text()"/>
      
      <dcat:qualifiedRelation>
        <dcat:Relationship>
          <dct:relation>
            <dcat:Dataset>
              <dct:identifier><xsl:value-of select="$relatedUuid"/></dct:identifier>
            </dcat:Dataset>
          </dct:relation>
          <dcat:hadRole rdf:resource="http://www.iana.org/assignments/relation/related"/>
        </dcat:Relationship>
      </dcat:qualifiedRelation>
    </xsl:for-each>
  </xsl:template>

  <!-- 16. ADD DOCUMENTATION -->
  <xsl:template name="add-documentation">
    <!-- foaf:page: WWW:LINK with function 'information' -->
    <xsl:for-each select="
      mdb:distributionInfo//mrd:onLine[
        starts-with((*/cit:protocol/*/text())[1], 'WWW:LINK') and
        */cit:function/*/@codeListValue = 'information'
      ]
    ">
      <xsl:variable name="url" select="normalize-space((*/cit:linkage/gco:CharacterString/text())[1])"/>
      <xsl:if test="$url != ''">
        <foaf:page>
          <foaf:Document rdf:about="{$url}"/>
        </foaf:page>
      </xsl:if>
    </xsl:for-each>
    <!-- foaf:documentation: function 'documentation' or in additionalDocumentation -->
    <xsl:for-each select="
      mdb:distributionInfo//mrd:onLine[
        */cit:function/*/@codeListValue = 'documentation' or
        ancestor::mrl:additionalDocumentation
      ]
    ">
      <xsl:variable name="url" select="normalize-space((*/cit:linkage/*/text())[1])"/>
      <xsl:if test="$url != ''">
        <foaf:documentation>
          <foaf:Document rdf:about="{$url}">
            <xsl:call-template name="multilingual-field">
              <xsl:with-param name="nodes" select="*/cit:name"/>
              <xsl:with-param name="property" select="'dct:title'"/>
            </xsl:call-template>
          </foaf:Document>
        </foaf:documentation>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- 17. ADD CONFORMS TO -->
  <xsl:template name="add-conforms-to">
    <xsl:for-each select=".//mrc:featureCatalogueCitation//cit:onlineResource/*/cit:linkage/*/text()">
      <xsl:if test="normalize-space() != ''">
        <dct:conformsTo rdf:resource="{normalize-space(.)}"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- 18. ADD FORMAT (for distributions) -->
  <xsl:template name="add-format">
    <xsl:param name="protocol"/>
    <xsl:param name="url"/>
    
    <xsl:variable name="formatUri">
      <xsl:choose>
        <!-- Service protocols (full URIs) -->
        <xsl:when test="starts-with($protocol, 'OGC:WMS')">
          <xsl:text>http://publications.europa.eu/resource/authority/file-type/WMS_SRVC</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with($protocol, 'OGC:WMTS')">
          <xsl:text>http://publications.europa.eu/resource/authority/file-type/WMTS_SRVC</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with($protocol, 'OGC:WFS')">
          <xsl:text>http://publications.europa.eu/resource/authority/file-type/WFS_SRVC</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with($protocol, 'ESRI:REST')">
          <xsl:text>http://publications.europa.eu/resource/authority/file-type/REST</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with($protocol, 'MAP:Preview')">
          <xsl:text>http://publications.europa.eu/resource/authority/file-type/HTML</xsl:text>
        </xsl:when>
        
        <!-- File formats by extension (code only) -->
        <xsl:when test="ends-with(lower-case($url), '.shp')">http://publications.europa.eu/resource/authority/file-type/SHP</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.gpkg')">http://publications.europa.eu/resource/authority/file-type/GPKG</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.geojson')">http://publications.europa.eu/resource/authority/file-type/GEOJSON</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.json')">http://publications.europa.eu/resource/authority/file-type/JSON</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.gml')">http://publications.europa.eu/resource/authority/file-type/GML</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.kml')">http://publications.europa.eu/resource/authority/file-type/KML</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.csv')">http://publications.europa.eu/resource/authority/file-type/CSV</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.xml')">http://publications.europa.eu/resource/authority/file-type/XML</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.zip')">http://publications.europa.eu/resource/authority/file-type/ZIP</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.pdf')">http://publications.europa.eu/resource/authority/file-type/PDF</xsl:when>
        <xsl:when test="ends-with(lower-case($url), '.html') or ends-with(lower-case($url), '.htm')">http://publications.europa.eu/resource/authority/file-type/HTML</xsl:when>
        
        <!-- Default -->
        <xsl:otherwise>http://publications.europa.eu/resource/authority/file-type/UNSPECIFIED</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:if test="$formatUri != ''">
      <dct:format rdf:resource="{$formatUri}"/>
    </xsl:if>
  </xsl:template>

  <!-- 19. ADD RIGHTS/LICENSE -->
  <xsl:template name="add-rights">
    <xsl:variable name="constraints" select="
      mdb:identificationInfo/*/mri:resourceConstraints/*[
        mco:useConstraints or mco:useLimitation or mco:otherConstraints
      ]
    "/>
    
    <xsl:variable name="constraintsText" select="
      string-join(
        $constraints/mco:useLimitation/*/text() | 
        $constraints/mco:otherConstraints//text(), 
        ' '
      )
    "/>
    
    <xsl:choose>
      <!-- OpenData.swiss terms -->
      <xsl:when test="
        contains($constraintsText, 'terms_open') or 
        contains($constraintsText, 'Opendata OPEN') or
        contains($constraintsText, 'Utilisation libre.') or
        contains($constraintsText, 'Freie Nutzung.')
      ">
        <dct:rights rdf:resource="http://dcat-ap.ch/vocabulary/licenses/terms_open"/>
        <dct:license rdf:resource="http://dcat-ap.ch/vocabulary/licenses/terms_open"/>
      </xsl:when>
      
      <!-- CC licenses -->
      <xsl:when test="contains($constraintsText, 'CC0')">
        <dct:rights rdf:resource="https://creativecommons.org/publicdomain/zero/1.0/"/>
        <dct:license rdf:resource="https://creativecommons.org/publicdomain/zero/1.0/"/>
      </xsl:when>
      
      <xsl:when test="contains($constraintsText, 'CC BY 4.0')">
        <dct:rights rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
        <dct:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
      </xsl:when>
      
      <!-- Fallback: literal text -->
      <xsl:when test="normalize-space($constraintsText) != ''">
        <dct:rights><xsl:value-of select="normalize-space($constraintsText)"/></dct:rights>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- 20. ADD DISTRIBUTION LICENSE (for distributions) -->
  <xsl:template name="add-distribution-license">
    <xsl:variable name="constraints" select="
      ancestor::che:CHE_MD_Metadata/mdb:identificationInfo/*/mri:resourceConstraints/*[
        mco:useConstraints or mco:useLimitation or mco:otherConstraints
      ]
    "/>
    
    <xsl:variable name="constraintsText" select="
      string-join(
        $constraints/mco:useLimitation/*/text() | 
        $constraints/mco:otherConstraints//text(), 
        ' '
      )
    "/>
    
    <!-- Determine license based on Opendata.swiss terminology -->
    <xsl:variable name="licenseUri">
      <xsl:choose>
        <!-- Opendata BY-ASK or terms_by_ask -->
        <xsl:when test="
          contains($constraintsText, 'Opendata BY-ASK')
        ">http://dcat-ap.ch/vocabulary/licenses/terms_by_ask</xsl:when>
        
        <!-- Opendata BY or terms_by -->
        <xsl:when test="
          contains($constraintsText, 'Opendata BY')
        ">http://dcat-ap.ch/vocabulary/licenses/terms_by</xsl:when>
        
        <!-- Opendata ASK or terms_ask -->
        <xsl:when test="
          contains($constraintsText, 'Opendata ASK')
        ">http://dcat-ap.ch/vocabulary/licenses/terms_ask</xsl:when>
        
        <!-- Opendata OPEN or terms_open -->
        <xsl:when test="
          contains($constraintsText, 'Opendata OPEN')
        ">http://dcat-ap.ch/vocabulary/licenses/terms_open</xsl:when>
        
        <!-- CC0 -->
        <xsl:when test="contains($constraintsText, 'CC0')">https://creativecommons.org/publicdomain/zero/1.0/</xsl:when>
        
        <!-- CC BY 4.0 -->
        <xsl:when test="contains($constraintsText, 'CC BY 4.0')">https://creativecommons.org/licenses/by/4.0/</xsl:when>
        
        <!-- Default fallback: terms_open -->
        <xsl:otherwise>http://dcat-ap.ch/vocabulary/licenses/terms_open</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- Output dct:license and dct:rights (same URI for consistency) -->
    <dct:license rdf:resource="{$licenseUri}"/>
    <dct:rights>
      <dct:RightsStatement rdf:about="{$licenseUri}"/>
    </dct:rights>
  </xsl:template>

  <!-- 21. ADD MEDIA TYPE (for distributions) -->
  <xsl:template name="add-media-type">
    <xsl:param name="protocol"/>
    
    <xsl:variable name="mediaType">
      <xsl:choose>
        <xsl:when test="starts-with($protocol, 'MAP:Preview') or starts-with($protocol, 'WWW:LINK')">text/html</xsl:when>
        <xsl:when test="starts-with($protocol, 'WWW:DOWNLOAD')">application/octet-stream</xsl:when>
        <xsl:when test="starts-with($protocol, 'OGC:') or starts-with($protocol, 'ESRI:')">application/xml</xsl:when>
        <xsl:otherwise>application/octet-stream</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:if test="$mediaType != ''">
      <dcat:mediaType rdf:resource="http://www.iana.org/assignments/media-types/{$mediaType}"/>
    </xsl:if>
  </xsl:template>

  <!-- ================================================ -->
  <!-- UTILITY FUNCTIONS                               -->
  <!-- ================================================ -->

  <!-- Get candidate organization (priority: publisher > owner > pointOfContact > metadata contact) -->
  <xsl:function name="local:get-candidate-org">
    <xsl:param name="metadata"/>
    
    <xsl:sequence select="
      ($metadata/mdb:identificationInfo/*/mri:pointOfContact[*/cit:role/*/@codeListValue = 'publisher']/*/cit:party/che:CHE_CI_Organisation,
       $metadata/mdb:identificationInfo/*/mri:pointOfContact[*/cit:role/*/@codeListValue = 'owner']/*/cit:party/che:CHE_CI_Organisation,
       $metadata/mdb:identificationInfo/*/mri:pointOfContact[*/cit:role/*/@codeListValue = 'pointOfContact']/*/cit:party/che:CHE_CI_Organisation,
       $metadata/mdb:contact/*/cit:party/che:CHE_CI_Organisation)[1]
    "/>
  </xsl:function>

  <!-- Format datetime with +00:00 timezone instead of Z -->
  <xsl:function name="local:format-datetime">
    <xsl:param name="dateValue"/>
    
    <xsl:choose>
      <xsl:when test="contains($dateValue, 'T')">
        <!-- If already has timezone, convert Z to +00:00 -->
        <xsl:choose>
          <xsl:when test="ends-with($dateValue, 'Z')">
            <xsl:value-of select="concat(substring-before($dateValue, 'Z'), '+00:00')"/>
          </xsl:when>
          <xsl:when test="contains($dateValue, '+') or (contains($dateValue, '-') and string-length(substring-after($dateValue, '-')) &lt; 6)">
            <!-- Already has timezone offset -->
            <xsl:value-of select="$dateValue"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- No timezone, add +00:00 -->
            <xsl:value-of select="concat($dateValue, '+00:00')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Date only, add time and timezone, completing partial dates (yyyy-MM → yyyy-MM-01, yyyy → yyyy-01-01) -->
        <xsl:variable name="paddedDate">
          <xsl:choose>
            <xsl:when test="string-length($dateValue) = 4">
              <xsl:value-of select="concat($dateValue, '-01-01')"/>
            </xsl:when>
            <xsl:when test="string-length($dateValue) = 7">
              <xsl:value-of select="concat($dateValue, '-01')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateValue"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($paddedDate, 'T00:00:00+00:00')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- ISO 639 language code conversion -->
  <xsl:function name="local:iso639-to-2letter">
    <xsl:param name="code"/>
    
    <xsl:choose>
      <xsl:when test="$code = 'ger'">de</xsl:when>
      <xsl:when test="$code = 'fre' or $code = 'fra'">fr</xsl:when>
      <xsl:when test="$code = 'ita'">it</xsl:when>
      <xsl:when test="$code = 'eng'">en</xsl:when>
      <xsl:when test="$code = 'roh'">rm</xsl:when>
      <xsl:when test="string-length($code) = 2"><xsl:value-of select="$code"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- ISO 639-2 to EU bibliographic codes (ISO 639-2/B) -->
  <xsl:function name="local:iso639-to-eu">
    <xsl:param name="code"/>
    
    <xsl:variable name="normalizedCode" select="lower-case($code)"/>
    
    <xsl:choose>
      <xsl:when test="$normalizedCode = 'ger'">DEU</xsl:when>
      <xsl:when test="$normalizedCode = 'deu'">DEU</xsl:when>
      <xsl:when test="$normalizedCode = 'fre'">FRA</xsl:when>
      <xsl:when test="$normalizedCode = 'fra'">FRA</xsl:when>
      <xsl:when test="$normalizedCode = 'ita'">ITA</xsl:when>
      <xsl:when test="$normalizedCode = 'eng'">ENG</xsl:when>
      <xsl:when test="$normalizedCode = 'roh'">ROH</xsl:when>
      <xsl:otherwise><xsl:value-of select="upper-case($normalizedCode)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>