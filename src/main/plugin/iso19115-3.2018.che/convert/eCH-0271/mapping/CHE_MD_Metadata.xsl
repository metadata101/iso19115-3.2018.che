<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CHE_MD_Metadata root mapping
     Handles root metadata element: identifiers, contacts, scopes, standards
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:che="http://geocat.ch/che"
  xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:LocalisationCH_V2="http://www.interlis.ch/xtf/2.4/LocalisationCH_V2"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       CHE_MD_Metadata root processor
       Maps eCH0271_1:CHE_MD_Metadata to ISO 19115-3:2018 che:CHE_MD_Metadata
       
       Input structure handling:
       - metadataIdentifier: ili:ref reference → resolves via key()
       - defaultLocale: contains PT_Locale child element
       - metadataScope: ili:ref reference → resolves via key()
       - contact: ili:ref reference → resolves via key()
       - dateInfo: contains CI_Date child element
       - standardUsedBymetadataStandard: ili:ref reference
       - referenceSystemInfo: ili:ref reference
       - identificationInfo: ili:ref reference
       - distributionInfo: ili:ref reference
       - legislationInformation: ili:ref reference
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_MD_Metadata" mode="md-metadata">
    <xsl:variable name="mdTID" select="@ili:tid"/>
    <che:CHE_MD_Metadata gco:isoType="mdb:MD_Metadata">
      
      <!-- metadata identifier (ili:ref reference) -->
      <xsl:apply-templates select="eCH0271_1:metadataIdentifier[@ili:ref]" mode="identifier"/>

      <!-- default locale (inline PT_Locale child) -->
      <xsl:if test="eCH0271_1:defaultLocale">
        <xsl:apply-templates select="eCH0271_1:defaultLocale/eCH0271_1:PT_Locale" mode="locale"/>
      </xsl:if>

      <!-- Metadata scope (ili:ref reference OR direct object OR via association) -->
      <xsl:choose>
        <!-- Priority 1: Direct reference in CHE_MD_Metadata -->
        <xsl:when test="eCH0271_1:metadataScope[@ili:ref]">
          <xsl:apply-templates select="eCH0271_1:metadataScope" mode="metadata-scope"/>
        </xsl:when>
        <!-- Priority 2: Direct MD_MetadataScope object (commented reference case) -->
        <xsl:when test="//eCH0271_1:MD_MetadataScope">
          <xsl:variable name="scopeObj" select="//eCH0271_1:MD_MetadataScope[1]"/>
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
        </xsl:when>
        <!-- Priority 3: Via association MD_MetadataMetadataScope -->
        <xsl:otherwise>
          <xsl:variable name="scopeAssoc"
            select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_MetadataMetadataScope
                    [eCH0271_1:MD_Metadata/@ili:ref = $mdTID]"/>
          <xsl:if test="$scopeAssoc">
            <xsl:variable name="scopeRef" select="$scopeAssoc/eCH0271_1:metadataScope/@ili:ref"/>
            <xsl:variable name="scopeObj" select="key('byTID', $scopeRef)"/>
            <xsl:apply-templates select="$scopeObj" mode="metadata-scope"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Metadata contact (ili:ref reference OR direct object OR via association) -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:contact[@ili:ref]">
          <xsl:apply-templates select="eCH0271_1:contact" mode="contact"/>
        </xsl:when>
        <!-- Direct CI_Responsibility object (commented reference case) -->
        <xsl:when test="//eCH0271_1:CI_Responsibility[@ili:tid='responsibility-001']">
          <xsl:variable name="contactObj" select="//eCH0271_1:CI_Responsibility[@ili:tid='responsibility-001']"/>
          <mdb:contact>
            <xsl:apply-templates select="$contactObj" mode="responsibility"/>
          </mdb:contact>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="contactAssoc"
            select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_Metadatacontact
                    [eCH0271_1:MD_Metadata/@ili:ref = $mdTID]"/>
          <xsl:if test="$contactAssoc">
            <xsl:variable name="contactRef" select="$contactAssoc/eCH0271_1:contact/@ili:ref"/>
            <xsl:variable name="contactObj" select="key('byTID', $contactRef)"/>
            <xsl:apply-templates select="$contactObj" mode="contact"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Metadata date info (inline CI_Date child) -->
      <xsl:if test="eCH0271_1:dateInfo">
        <xsl:apply-templates select="eCH0271_1:dateInfo/eCH0271_1:CI_Date" mode="date-info"/>
      </xsl:if>

      <!-- Metadata standard citation (via association OR direct CI_Citation object) -->
      <xsl:variable name="mdStandardAssoc"
        select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_MetadataStandardUsedBymetadataStandard
                [eCH0271_1:MD_Metadata/@ili:ref = $mdTID]"/>
      <xsl:choose>
        <xsl:when test="$mdStandardAssoc">
          <xsl:variable name="standardRef" select="$mdStandardAssoc/eCH0271_1:standardUsedBymetadataStandard/@ili:ref"/>
          <xsl:variable name="standardObj" select="key('byTID', $standardRef)"/>
          <xsl:apply-templates select="$standardObj" mode="metadata-standard"/>
        </xsl:when>
        <!-- Direct CI_Citation with 'standard' in TID (commented reference case) -->
        <xsl:when test="//eCH0271_1:CI_Citation[@ili:tid='citation-metadata-standard-001']">
          <xsl:variable name="standardObj" select="//eCH0271_1:CI_Citation[@ili:tid='citation-metadata-standard-001']"/>
          <xsl:apply-templates select="$standardObj" mode="metadata-standard"/>
        </xsl:when>
      </xsl:choose>

      <!-- Reference system info (direct ref OR direct MD_ReferenceSystem object OR via association) -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:referenceSystemInfo[@ili:ref]">
          <xsl:apply-templates select="eCH0271_1:referenceSystemInfo" mode="reference-system"/>
        </xsl:when>
        <!-- Direct MD_ReferenceSystem object (commented reference case) -->
        <xsl:when test="//eCH0271_1:MD_ReferenceSystem">
          <xsl:variable name="refSysObj" select="//eCH0271_1:MD_ReferenceSystem[1]"/>
          <xsl:apply-templates select="$refSysObj" mode="reference-system"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="refSysAssoc"
            select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_MetadataReferenceSystemInfo
                    [eCH0271_1:MD_Metadata/@ili:ref = $mdTID]"/>
          <xsl:if test="$refSysAssoc">
            <xsl:variable name="refSysRef" select="$refSysAssoc/eCH0271_1:referenceSystemInfo/@ili:ref"/>
            <xsl:variable name="refSysObj" select="key('byTID', $refSysRef)"/>
            <xsl:apply-templates select="$refSysObj" mode="reference-system"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Data identification (via MD_MetadataidentificationInfo association) -->
      <xsl:variable name="dataIdAssoc"
        select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_MetadataidentificationInfo
                [eCH0271_1:MD_Metadata/@ili:ref = $mdTID]"/>
      <xsl:if test="$dataIdAssoc">
        <xsl:variable name="dataIdRef" select="$dataIdAssoc/eCH0271_1:identificationInfo/@ili:ref"/>
        <xsl:variable name="dataIdObj" select="key('byTID', $dataIdRef)"/>
        <xsl:apply-templates select="$dataIdObj" mode="data-id"/>
      </xsl:if>

      <!-- Distribution info (direct ref OR direct MD_Distribution object OR via association) -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:distributionInfo[@ili:ref]">
          <xsl:apply-templates select="eCH0271_1:distributionInfo" mode="distribution"/>
        </xsl:when>
        <!-- Direct MD_Distribution object (commented reference case) -->
        <xsl:when test="//eCH0271_1:MD_Distribution[@ili:tid='distribution-001']">
          <xsl:variable name="distObj" select="//eCH0271_1:MD_Distribution[@ili:tid='distribution-001']"/>
          <xsl:apply-templates select="$distObj" mode="distribution"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="distAssoc"
            select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_MetadataDistributionInfo
                    [eCH0271_1:MD_Metadata/@ili:ref = $mdTID]"/>
          <xsl:if test="$distAssoc">
            <xsl:variable name="distRef" select="$distAssoc/eCH0271_1:distributionInfo/@ili:ref"/>
            <xsl:variable name="distObj" select="key('byTID', $distRef)"/>
            <xsl:apply-templates select="$distObj" mode="distribution"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Legislative/governance info (direct ref OR direct CHE_MD_Legislation object OR via association) -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:legislationInformation[@ili:ref]">
          <xsl:apply-templates select="eCH0271_1:legislationInformation" mode="legislation"/>
        </xsl:when>
        <!-- Direct CHE_MD_Legislation object (commented reference case) -->
        <xsl:when test="//eCH0271_1:CHE_MD_Legislation[@ili:tid='legislation-001']">
          <xsl:variable name="legObj" select="//eCH0271_1:CHE_MD_Legislation[@ili:tid='legislation-001']"/>
          <xsl:apply-templates select="$legObj" mode="legislation"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="legAssoc"
            select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_MetadataLegislationInformation
                    [eCH0271_1:MD_Metadata/@ili:ref = $mdTID]"/>
          <xsl:if test="$legAssoc">
            <xsl:variable name="legRef" select="$legAssoc/eCH0271_1:legislationInformation/@ili:ref"/>
            <xsl:variable name="legObj" select="key('byTID', $legRef)"/>
            <xsl:apply-templates select="$legObj" mode="legislation"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </che:CHE_MD_Metadata>
  </xsl:template>

  <!-- ================================================================
       metadata-standard: Direct CI_Citation processing (resolved object)
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Citation" mode="metadata-standard">
    <mdb:metadataStandard>
      <cit:CI_Citation>
        <xsl:if test="eCH0271_1:title">
          <cit:title>
            <xsl:apply-templates select="eCH0271_1:title" mode="multilingual-text"/>
          </cit:title>
        </xsl:if>
        <xsl:if test="eCH0271_1:date[@ili:ref]">
          <xsl:variable name="dateRef" select="eCH0271_1:date/@ili:ref"/>
          <xsl:variable name="dateObj" select="key('byTID', $dateRef)"/>
          <xsl:if test="$dateObj/self::eCH0271_1:CI_Date">
            <cit:date>
              <cit:CI_Date>
                <xsl:if test="normalize-space($dateObj/eCH0271_1:date) != ''">
                  <cit:date>
                    <gco:Date>
                      <xsl:value-of select="substring(normalize-space($dateObj/eCH0271_1:date), 1, 10)"/>
                    </gco:Date>
                  </cit:date>
                </xsl:if>
                <xsl:if test="$dateObj/eCH0271_1:dateType">
                  <cit:dateType>
                    <xsl:call-template name="date-type-code">
                      <xsl:with-param name="value" select="normalize-space($dateObj/eCH0271_1:dateType)"/>
                    </xsl:call-template>
                  </cit:dateType>
                </xsl:if>
              </cit:CI_Date>
            </cit:date>
          </xsl:if>
        </xsl:if>
      </cit:CI_Citation>
    </mdb:metadataStandard>
  </xsl:template>

  <!-- ================================================================
       reference-system: Direct MD_ReferenceSystem processing (resolved object)
       ================================================================ -->
  <xsl:template match="eCH0271_1:MD_ReferenceSystem" mode="reference-system">
    <mdb:referenceSystemInfo>
      <mrs:MD_ReferenceSystem>
        <xsl:if test="eCH0271_1:referenceSystemIdentifier[@ili:ref]">
          <xsl:variable name="rsIdentId" select="eCH0271_1:referenceSystemIdentifier/@ili:ref"/>
          <xsl:variable name="rsIdentObj" select="key('byTID', $rsIdentId)"/>
          <xsl:if test="$rsIdentObj">
            <mrs:referenceSystemIdentifier>
              <mcc:MD_Identifier>
                <mcc:code>
                  <xsl:apply-templates select="$rsIdentObj/eCH0271_1:code" mode="multilingual-text"/>
                </mcc:code>
              </mcc:MD_Identifier>
            </mrs:referenceSystemIdentifier>
          </xsl:if>
        </xsl:if>
      </mrs:MD_ReferenceSystem>
    </mdb:referenceSystemInfo>
  </xsl:template>

  <!-- ================================================================
       distribution: Direct MD_Distribution processing (resolved object)
       ================================================================ -->
  <xsl:template match="eCH0271_1:MD_Distribution" mode="distribution">
    <mdb:distributionInfo>
      <mrd:MD_Distribution>
        <!-- Process transferOptions: Priority 1 - associations, Priority 2 - direct TID search -->
        <xsl:variable name="distTID" select="@ili:tid"/>
        <xsl:choose>
          <!-- Direct transferOptions children (if any uncommented) -->
          <xsl:when test="eCH0271_1:transferOptions[@ili:ref]">
            <xsl:for-each select="eCH0271_1:transferOptions[@ili:ref]">
              <xsl:variable name="toRef" select="@ili:ref"/>
              <xsl:variable name="toObj" select="key('byTID', $toRef)"/>
              <xsl:if test="$toObj/self::eCH0271_1:MD_DigitalTransferOptions">
                <mrd:transferOptions>
                  <xsl:apply-templates select="$toObj" mode="transfer-options"/>
                </mrd:transferOptions>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <!-- Association-based (MD_DistributionDistributionTransferOptions) -->
          <xsl:when test="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_DistributionDistributionTransferOptions
                          [eCH0271_1:MD_Distribution/@ili:ref = $distTID]">
            <xsl:for-each select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_DistributionDistributionTransferOptions
                                 [eCH0271_1:MD_Distribution/@ili:ref = $distTID]">
              <xsl:variable name="toRef" select="eCH0271_1:distributionTransferOptions/@ili:ref"/>
              <xsl:variable name="toObj" select="key('byTID', $toRef)"/>
              <xsl:if test="$toObj/self::eCH0271_1:MD_DigitalTransferOptions">
                <mrd:transferOptions>
                  <xsl:apply-templates select="$toObj" mode="transfer-options"/>
                </mrd:transferOptions>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <!-- Direct TID search fallback (commented references case) -->
          <xsl:otherwise>
            <xsl:for-each select="//eCH0271_1:MD_DigitalTransferOptions">
              <mrd:transferOptions>
                <xsl:apply-templates select="." mode="transfer-options"/>
              </mrd:transferOptions>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </mrd:MD_Distribution>
    </mdb:distributionInfo>
  </xsl:template>

  <!-- ================================================================
       transfer-options: Process MD_DigitalTransferOptions
       ================================================================ -->
  <xsl:template match="eCH0271_1:MD_DigitalTransferOptions" mode="transfer-options">
    <mrd:MD_DigitalTransferOptions>
      <!-- Process onLine resources: Priority 1 - direct refs, Priority 2 - associations, Priority 3 - direct TID search -->
      <xsl:variable name="toTID" select="@ili:tid"/>
      
      <xsl:choose>
        <!-- Direct onLine children (if any uncommented) -->
        <xsl:when test="eCH0271_1:onLine[@ili:ref]">
          <xsl:for-each select="eCH0271_1:onLine[@ili:ref]">
            <xsl:variable name="olRef" select="@ili:ref"/>
            <xsl:variable name="olObj" select="key('byTID', $olRef)"/>
            <xsl:if test="$olObj/self::eCH0271_1:CI_OnlineResource">
              <mrd:onLine>
                <xsl:apply-templates select="$olObj" mode="online-resource"/>
              </mrd:onLine>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <!-- Association-based (MD_DigitalTransferOptionsOnLine) -->
        <xsl:when test="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_DigitalTransferOptionsOnLine
                        [eCH0271_1:MD_DigitalTransferOptions/@ili:ref = $toTID]">
          <xsl:for-each select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_DigitalTransferOptionsOnLine
                               [eCH0271_1:MD_DigitalTransferOptions/@ili:ref = $toTID]">
            <xsl:variable name="olRef" select="eCH0271_1:onLine/@ili:ref"/>
            <xsl:variable name="olObj" select="key('byTID', $olRef)"/>
            <xsl:if test="$olObj/self::eCH0271_1:CI_OnlineResource">
              <mrd:onLine>
                <xsl:apply-templates select="$olObj" mode="online-resource"/>
              </mrd:onLine>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <!-- Direct TID search fallback (commented references case) -->
        <xsl:otherwise>
          <!-- Extract suffix from transfer-options-NNN and search for matching online-resource-NNN -->
          <xsl:variable name="toSuffix" select="substring-after($toTID, 'transfer-options-')"/>
          <xsl:if test="$toSuffix != ''">
            <xsl:variable name="expectedOlTID" select="concat('online-resource-', $toSuffix)"/>
            <xsl:variable name="matchingOlObj" select="key('byTID', $expectedOlTID)"/>
            <xsl:if test="$matchingOlObj/self::eCH0271_1:CI_OnlineResource">
              <mrd:onLine>
                <xsl:apply-templates select="$matchingOlObj" mode="online-resource"/>
              </mrd:onLine>
            </xsl:if>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </mrd:MD_DigitalTransferOptions>
  </xsl:template>

  <!-- ================================================================
       legislation: Direct CHE_MD_Legislation processing (resolved object)
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_MD_Legislation" mode="legislation">
    <che:legislationInformation>
      <che:CHE_MD_Legislation>
        <!-- country (ISO 3166) - convert CHE to CH -->
        <xsl:if test="normalize-space(eCH0271_1:country) != ''">
          <che:country>
            <xsl:variable name="countryCode" select="normalize-space(eCH0271_1:country)"/>
            <xsl:variable name="mappedCountry">
              <xsl:choose>
                <xsl:when test="$countryCode = 'CHE'">CH</xsl:when>
                <xsl:otherwise><xsl:value-of select="$countryCode"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <lan:CountryCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#Country" codeListValue="{$mappedCountry}"/>
          </che:country>
        </xsl:if>

        <!-- legislationType - convert otherLegalProvision to cantonalLaw -->
        <xsl:if test="normalize-space(eCH0271_1:legislationType) != ''">
          <che:legislationType>
            <xsl:variable name="legType" select="normalize-space(eCH0271_1:legislationType)"/>
            <xsl:variable name="mappedType">
              <xsl:choose>
                <xsl:when test="$legType = 'otherLegalProvision'">cantonalLaw</xsl:when>
                <xsl:otherwise><xsl:value-of select="$legType"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <che:CHE_CI_LegislationTypeCode codeList="legislationCode" codeListValue="{$mappedType}"/>
          </che:legislationType>
        </xsl:if>

        <!-- internalReference (e.g., BLV 740.24) -->
        <xsl:if test="normalize-space(eCH0271_1:internalReference) != ''">
          <che:internalReference>
            <gco:CharacterString>
              <xsl:value-of select="normalize-space(eCH0271_1:internalReference)"/>
            </gco:CharacterString>
          </che:internalReference>
        </xsl:if>

        <!-- legislationCitation (direct ili:ref child element) -->
        <xsl:if test="eCH0271_1:legislationCitation[@ili:ref]">
          <xsl:variable name="citRef" select="eCH0271_1:legislationCitation/@ili:ref"/>
          <xsl:variable name="citRecord" select="key('byTID', $citRef)"/>
          <xsl:if test="$citRecord/self::eCH0271_1:CI_Citation">
            <che:legislationCitation>
              <cit:CI_Citation>
                <xsl:if test="$citRecord/eCH0271_1:title">
                  <cit:title>
                    <xsl:apply-templates select="$citRecord/eCH0271_1:title" mode="multilingual-text"/>
                  </cit:title>
                </xsl:if>
                <!-- Get date via CI_Citationdate association -->
                <xsl:variable name="citTID" select="$citRecord/@ili:tid"/>
                <xsl:variable name="dateAssoc" select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:CI_Citationdate
                                                       [eCH0271_1:CI_Citation/@ili:ref = $citTID]"/>
                <xsl:if test="$dateAssoc">
                  <xsl:variable name="dateRef" select="$dateAssoc/eCH0271_1:date/@ili:ref"/>
                  <xsl:variable name="dateObj" select="key('byTID', $dateRef)"/>
                  <xsl:if test="$dateObj/self::eCH0271_1:CI_Date">
                    <cit:date>
                      <cit:CI_Date>
                        <xsl:if test="normalize-space($dateObj/eCH0271_1:date) != ''">
                          <cit:date>
                            <gco:Date>
                              <xsl:value-of select="substring(normalize-space($dateObj/eCH0271_1:date), 1, 10)"/>
                            </gco:Date>
                          </cit:date>
                        </xsl:if>
                        <xsl:if test="$dateObj/eCH0271_1:dateType">
                          <cit:dateType>
                            <xsl:call-template name="date-type-code">
                              <xsl:with-param name="value" select="normalize-space($dateObj/eCH0271_1:dateType)"/>
                            </xsl:call-template>
                          </cit:dateType>
                        </xsl:if>
                      </cit:CI_Date>
                    </cit:date>
                  </xsl:if>
                </xsl:if>
              </cit:CI_Citation>
            </che:legislationCitation>
          </xsl:if>
        </xsl:if>
      </che:CHE_MD_Legislation>
    </che:legislationInformation>
  </xsl:template>

  <!-- ================================================================
       online-resource: Process CI_OnlineResource
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_OnlineResource" mode="online-resource">
    <cit:CI_OnlineResource>
      <!-- linkage (MultilingualUri -> CharacterString, extract first fr text) -->
      <xsl:if test="eCH0271_1:linkage">
        <cit:linkage>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(
              eCH0271_1:linkage/Localisation_V2:MultilingualUri/Localisation_V2:LocalisedText[1]/
              Localisation_V2:LocalisedUri/Localisation_V2:Text[1]
            )"/>
          </gco:CharacterString>
        </cit:linkage>
      </xsl:if>
      
      <!-- protocol (text or code value) -->
      <xsl:if test="normalize-space(eCH0271_1:protocol) != ''">
        <cit:protocol>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:protocol)"/>
          </gco:CharacterString>
        </cit:protocol>
      </xsl:if>
      
      <!-- name (optional, MultilingualMText) -->
      <xsl:if test="eCH0271_1:name">
        <cit:name>
          <xsl:apply-templates select="eCH0271_1:name" mode="multilingual-text"/>
        </cit:name>
      </xsl:if>
      
      <!-- description (optional, MultilingualMText) -->
      <xsl:if test="eCH0271_1:description">
        <cit:description>
          <xsl:apply-templates select="eCH0271_1:description" mode="multilingual-text"/>
        </cit:description>
      </xsl:if>
      
      <!-- function (optional, code value) -->
      <xsl:if test="normalize-space(eCH0271_1:function) != ''">
        <cit:function>
          <cit:CI_OnLineFunctionCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_OnLineFunctionCode" codeListValue="{normalize-space(eCH0271_1:function)}">
            <xsl:value-of select="normalize-space(eCH0271_1:function)"/>
          </cit:CI_OnLineFunctionCode>
        </cit:function>
      </xsl:if>
    </cit:CI_OnlineResource>
  </xsl:template>

</xsl:stylesheet>
