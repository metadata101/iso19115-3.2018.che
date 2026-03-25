<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">ISO rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">Règles ISO</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="de">ISO-Regeln</sch:title>
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
  <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"/>
  <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/2.0"/>
  <sch:ns prefix="gex" uri="http://standards.iso.org/iso/19115/-3/gex/1.0"/>
  <sch:ns prefix="mco" uri="http://standards.iso.org/iso/19115/-3/mco/1.0"/>
  <sch:ns prefix="mdb" uri="http://standards.iso.org/iso/19115/-3/mdb/2.0"/>
  <sch:ns prefix="mex" uri="http://standards.iso.org/iso/19115/-3/mex/1.0"/>
  <sch:ns prefix="mmi" uri="http://standards.iso.org/iso/19115/-3/mmi/1.0"/>
  <sch:ns prefix="gmw" uri="http://standards.iso.org/iso/19115/-3/gmw/1.0"/>
  <sch:ns prefix="mrc" uri="http://standards.iso.org/iso/19115/-3/mrc/2.0"/>
  <sch:ns prefix="mrd" uri="http://standards.iso.org/iso/19115/-3/mrd/1.0"/>
  <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"/>
  <sch:ns prefix="mrs" uri="http://standards.iso.org/iso/19115/-3/mrs/1.0"/>
  <sch:ns prefix="mcc" uri="http://standards.iso.org/iso/19115/-3/mcc/1.0"/>
  <sch:ns prefix="lan" uri="http://standards.iso.org/iso/19115/-3/lan/1.0"/>
  <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"/>
  <sch:ns prefix="mrl" uri="http://standards.iso.org/iso/19115/-3/mrl/2.0"/>
  <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <sch:ns prefix="che" uri="http://geocat.ch/che"/>

  <sch:diagnostics>

    <sch:diagnostic id="rule.gex.extenthasoneelement-failure-en" xml:lang="en">
      The extent does not contain a description or a geographicElement.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-failure-fr" xml:lang="fr">
      L'étendue ne contient aucun élement.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-failure-de" xml:lang="de">
      Die Ausdehnung enthält keine Beschreibung oder kein geografisches Element.
    </sch:diagnostic>


    <sch:diagnostic id="rule.gex.extenthasoneelement-desc-success-en"
                    xml:lang="en">The extent contains a description.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-desc-success-fr"
                    xml:lang="fr">L'étendue contient une description.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-desc-success-de"
                    xml:lang="de">Die Ausdehnung enthält eine Beschreibung.
    </sch:diagnostic>


    <sch:diagnostic id="rule.gex.extenthasoneelement-id-success-en"
                    xml:lang="en">The extent contains a geographic identifier.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-id-success-fr"
                    xml:lang="fr">L'étendue contient un identifiant
      géographique.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-id-success-de"
                    xml:lang="de">Die Ausdehnung enthält einen geografischen Identifikator.
    </sch:diagnostic>


    <sch:diagnostic id="rule.gex.extenthasoneelement-box-success-en"
                    xml:lang="en">The extent contains a bounding box element.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-box-success-fr"
                    xml:lang="fr">L'étendue contient une emprise géographique.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-box-success-de"
                    xml:lang="de">Die Ausdehnung enthält ein geografisches Begrenzungsrechteck.
    </sch:diagnostic>


    <sch:diagnostic id="rule.gex.extenthasoneelement-poly-success-en"
                    xml:lang="en">The extent contains a bounding polygon.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-poly-success-fr"
                    xml:lang="fr">L'étendue contient un polygone englobant.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-poly-success-de"
                    xml:lang="de">Die Ausdehnung enthält ein Begrenzungspolygon.
    </sch:diagnostic>


    <sch:diagnostic id="rule.gex.extenthasoneelement-vertical-success-en"
                    xml:lang="en">The extent contains a vertical element.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-vertical-success-fr"
                    xml:lang="fr">L'étendue contient une étendue verticale.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-vertical-success-de"
                    xml:lang="de">Die Ausdehnung enthält ein vertikales Element.
    </sch:diagnostic>


    <sch:diagnostic id="rule.gex.extenthasoneelement-temporal-success-en"
                    xml:lang="en">The extent contains a temporal element.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-temporal-success-fr"
                    xml:lang="fr">L'étendue contient une étendue temporelle.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.extenthasoneelement-temporal-success-de"
                    xml:lang="de">Die Ausdehnung enthält ein zeitliches Element.
    </sch:diagnostic>


  </sch:diagnostics>
  <sch:diagnostics>
    <sch:diagnostic id="rule.mri.maintenance-frequency-when-scope-dss-failure-en" xml:lang="en">
      When resourceScope is 'dataset', 'series' or 'service', maintenanceAndUpdateFrequency MUST be provided in the identification section.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.maintenance-frequency-when-scope-dss-failure-fr" xml:lang="fr">
      Lorsque resourceScope vaut 'dataset', 'series' ou 'service', maintenanceAndUpdateFrequency DOIT être renseigné dans la section d’identification.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.maintenance-frequency-when-scope-dss-failure-de" xml:lang="de">
      Wenn resourceScope 'dataset', 'series' oder 'service' ist, MUSS maintenanceAndUpdateFrequency im Identifikationsabschnitt angegeben sein.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.maintenance-frequency-when-scope-dss-success-en" xml:lang="en">
      maintenanceAndUpdateFrequency is present for resources with scope dataset/series/service.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.maintenance-frequency-when-scope-dss-success-fr" xml:lang="fr">
      maintenanceAndUpdateFrequency est présent pour les ressources de type dataset/series/service.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.maintenance-frequency-when-scope-dss-success-de" xml:lang="de">
      maintenanceAndUpdateFrequency ist für Ressourcen vom Typ dataset/series/service vorhanden.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mri.maintenance-frequency-required-when-dataset-series-service">

    <sch:title xml:lang="en">maintenanceAndUpdateFrequency is mandatory when resourceScope = dataset, series or service</sch:title>

    <sch:title xml:lang="fr">maintenanceAndUpdateFrequency est obligatoire lorsque resourceScope = dataset, series ou service</sch:title>
    
    <sch:title xml:lang="de">maintenanceAndUpdateFrequency ist obligatorisch wenn resourceScope = dataset, series oder service</sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[
                        mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
                        mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
                        mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']">

      <!-- Count maintenanceAndUpdateFrequency declarations with a code element -->
      <sch:let name="maintenanceFreqCount"
               value="count(//che:CHE_MD_MaintenanceInformation/mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode)"/>

      <sch:assert test="$maintenanceFreqCount &gt; 0"
                  diagnostics="rule.mri.maintenance-frequency-when-scope-dss-failure-en rule.mri.maintenance-frequency-when-scope-dss-failure-fr rule.mri.maintenance-frequency-when-scope-dss-failure-de"/>

      <sch:report test="$maintenanceFreqCount &gt; 0"
                  diagnostics="rule.mri.maintenance-frequency-when-scope-dss-success-en rule.mri.maintenance-frequency-when-scope-dss-success-fr rule.mri.maintenance-frequency-when-scope-dss-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.contact-address-when-scope-dss-failure-en" xml:lang="en">
      When resourceScope is 'dataset', 'series' or 'service', every metadata contact party (mdb:contact/cit:party/*) MUST provide an address (cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address).
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-address-when-scope-dss-failure-fr" xml:lang="fr">
      Lorsque resourceScope vaut 'dataset', 'series' ou 'service', chaque partie de contact des métadonnées (mdb:contact/cit:party/*) DOIT fournir une adresse (cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address).
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-address-when-scope-dss-failure-de" xml:lang="de">
      Wenn resourceScope 'dataset', 'series' oder 'service' ist, MUSS jede Kontaktpartei der Metadaten (mdb:contact/cit:party/*) eine Adresse (cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address) angeben.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-address-when-scope-dss-success-en" xml:lang="en">
      All metadata contact parties provide an address for resources with scope dataset/series/service.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-address-when-scope-dss-success-fr" xml:lang="fr">
      Toutes les parties de contact des métadonnées fournissent une adresse pour les ressources de type dataset/series/service.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-address-when-scope-dss-success-de" xml:lang="de">
      Alle Kontaktparteien der Metadaten stellen eine Adresse für Ressourcen vom Typ dataset/series/service bereit.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.contact-email-when-scope-dss-failure-en" xml:lang="en">
      When resourceScope is 'dataset', 'series' or 'service', every metadata contact party (mdb:contact/cit:party/*) MUST provide an electronic mail address (cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address/cit:electronicMailAddress).
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-email-when-scope-dss-failure-fr" xml:lang="fr">
      Lorsque resourceScope vaut 'dataset', 'series' ou 'service', chaque partie de contact des métadonnées (mdb:contact/cit:party/*) DOIT fournir une adresse électronique (cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address/cit:electronicMailAddress).
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-email-when-scope-dss-failure-de" xml:lang="de">
      Wenn resourceScope 'dataset', 'series' oder 'service' ist, MUSS jede Kontaktpartei der Metadaten (mdb:contact/cit:party/*) eine E-Mail-Adresse (cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address/cit:electronicMailAddress) angeben.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-email-when-scope-dss-success-en" xml:lang="en">
      All metadata contact parties provide an electronic mail address for resources with scope dataset/series/service.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-email-when-scope-dss-success-fr" xml:lang="fr">
      Toutes les parties de contact des métadonnées fournissent une adresse électronique pour les ressources de type dataset/series/service.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-email-when-scope-dss-success-de" xml:lang="de">
      Alle Kontaktparteien der Metadaten stellen eine E-Mail-Adresse für Ressourcen vom Typ dataset/series/service bereit.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mdb.contact-email-required-when-dataset-series-service">

    <sch:title xml:lang="en">Metadata contact parties must have an electronicMailAddress when resourceScope = dataset, series or service</sch:title>

    <sch:title xml:lang="fr">Les parties de contact des métadonnées doivent avoir une adresse électronique lorsque resourceScope = dataset, series ou service</sch:title>
    
    <sch:title xml:lang="de">Kontaktparteien der Metadaten müssen eine E-Mail-Adresse haben wenn resourceScope = dataset, series oder service</sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']">

      <!-- All parties defined under metadata contacts, excluding GeoNetwork helper nodes -->
      <sch:let name="parties"
               value="mdb:contact/cit:CI_Responsibility/cit:party/*[namespace-uri(.) != 'http://www.fao.org/geonetwork']"/>

      <!-- Count parties missing at least one electronicMailAddress under CI_Address -->
      <sch:let name="missingEmailCount"
               value="count($parties[not(cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address/cit:electronicMailAddress)])"/>

      <!-- If parties are defined, all must provide an electronicMailAddress -->
      <sch:assert test="count($parties) = 0 or $missingEmailCount = 0"
                  diagnostics="rule.mdb.contact-email-when-scope-dss-failure-en rule.mdb.contact-email-when-scope-dss-failure-fr rule.mdb.contact-email-when-scope-dss-failure-de"/>

      <sch:report test="count($parties) &gt; 0 and $missingEmailCount = 0"
                  diagnostics="rule.mdb.contact-email-when-scope-dss-success-en rule.mdb.contact-email-when-scope-dss-success-fr rule.mdb.contact-email-when-scope-dss-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:pattern id="rule.mdb.contact-address-required-when-dataset-series-service">

    <sch:title xml:lang="en">Metadata contact parties must have an address when resourceScope = dataset, series or service</sch:title>

    <sch:title xml:lang="fr">Les parties de contact des métadonnées doivent avoir une adresse lorsque resourceScope = dataset, series ou service</sch:title>
    
    <sch:title xml:lang="de">Kontaktparteien der Metadaten müssen eine Adresse haben wenn resourceScope = dataset, series oder service</sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']">

      <!-- All parties defined under metadata contacts, excluding GeoNetwork helper nodes -->
      <sch:let name="parties"
               value="mdb:contact/cit:CI_Responsibility/cit:party/*[namespace-uri(.) != 'http://www.fao.org/geonetwork']"/>

      <!-- Count parties missing a postal address element under CI_Contact -->
      <sch:let name="missingAddressCount"
               value="count($parties[not(cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address)])"/>

      <!-- If parties are defined, all must provide an address -->
      <sch:assert test="count($parties) = 0 or $missingAddressCount = 0"
                  diagnostics="rule.mdb.contact-address-when-scope-dss-failure-en rule.mdb.contact-address-when-scope-dss-failure-fr rule.mdb.contact-address-when-scope-dss-failure-de"/>

      <sch:report test="count($parties) &gt; 0 and $missingAddressCount = 0"
                  diagnostics="rule.mdb.contact-address-when-scope-dss-success-en rule.mdb.contact-address-when-scope-dss-success-fr rule.mdb.contact-address-when-scope-dss-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.contact-contactinfo-when-scope-dss-failure-en" xml:lang="en">
      When resourceScope is 'dataset', 'series' or 'service', every metadata contact party (mdb:contact/cit:party/*) MUST provide a contactInfo (cit:contactInfo/cit:CI_Contact).
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-contactinfo-when-scope-dss-failure-fr" xml:lang="fr">
      Lorsque resourceScope vaut 'dataset', 'series' ou 'service', chaque partie de contact des métadonnées (mdb:contact/cit:party/*) DOIT fournir un contactInfo (cit:contactInfo/cit:CI_Contact).
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-contactinfo-when-scope-dss-failure-de" xml:lang="de">
      Wenn resourceScope 'dataset', 'series' oder 'service' ist, MUSS jeder Verantwortliche Akteur der Metadaten (mdb:contact/cit:party/*) ein contactInfo (cit:contactInfo/cit:CI_Contact) angeben.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-contactinfo-when-scope-dss-success-en" xml:lang="en">
      All metadata contact parties provide a contactInfo for resources with scope dataset/series/service.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-contactinfo-when-scope-dss-success-fr" xml:lang="fr">
      Toutes les parties de contact des métadonnées fournissent un contactInfo pour les ressources de type dataset/series/service.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.contact-contactinfo-when-scope-dss-success-de" xml:lang="de">
      Alle Verantwortlichen Akteure der Metadaten stellen ein contactInfo für Ressourcen vom Typ dataset/series/service bereit.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mdb.contact-contactinfo-required-when-dataset-series-service">

    <sch:title xml:lang="en">Metadata contact parties must have contactInfo when resourceScope = dataset, series or service</sch:title>

    <sch:title xml:lang="fr">Les parties de contact des métadonnées doivent avoir un contactInfo lorsque resourceScope = dataset, series ou service</sch:title>
    
    <sch:title xml:lang="de">Verantwortliche Akteure der Metadaten müssen ein contactInfo haben wenn resourceScope = dataset, series oder service</sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
              mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']">

      <!-- All parties defined under metadata contacts -->
      <sch:let name="parties"
               value="mdb:contact/cit:CI_Responsibility/cit:party/*[namespace-uri(.) != 'http://www.fao.org/geonetwork']"/>

      <!-- Count parties missing contactInfo/CI_Contact -->
      <sch:let name="missingContactInfoCount"
               value="count($parties[not(cit:contactInfo/cit:CI_Contact)])"/>

      <!-- If parties are defined, all must provide a contactInfo -->
      <sch:assert test="count($parties) = 0 or $missingContactInfoCount = 0"
                  diagnostics="rule.mdb.contact-contactinfo-when-scope-dss-failure-en rule.mdb.contact-contactinfo-when-scope-dss-failure-fr rule.mdb.contact-contactinfo-when-scope-dss-failure-de"/>

      <sch:report test="count($parties) &gt; 0 and $missingContactInfoCount = 0"
                  diagnostics="rule.mdb.contact-contactinfo-when-scope-dss-success-en rule.mdb.contact-contactinfo-when-scope-dss-success-fr rule.mdb.contact-contactinfo-when-scope-dss-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.gex.verticalcrsid-when-dataset-failure-en" xml:lang="en">
      When resourceScope is 'dataset' and a vertical extent is used, each vertical extent MUST provide a verticalCRSId (gex:verticalCRSId).
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalcrsid-when-dataset-failure-fr" xml:lang="fr">
      Lorsque resourceScope vaut 'dataset' et qu'une étendue verticale est utilisée, chaque étendue verticale DOIT fournir un verticalCRSId (gex:verticalCRSId).
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalcrsid-when-dataset-failure-de" xml:lang="de">
      Wenn resourceScope 'dataset' ist und eine vertikale Ausdehnung verwendet wird, MUSS jede vertikale Ausdehnung eine verticalCRSId (gex:verticalCRSId) angeben.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalcrsid-when-dataset-success-en" xml:lang="en">
      All vertical extents provide a verticalCRSId for dataset resources.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalcrsid-when-dataset-success-fr" xml:lang="fr">
      Toutes les étendues verticales fournissent un verticalCRSId pour les jeux de données.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalcrsid-when-dataset-success-de" xml:lang="de">
      Alle vertikalen Ausdehnungen stellen eine verticalCRSId für Datensätze bereit.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.gex.verticalcrsid-required-when-dataset">

    <sch:title xml:lang="en">verticalCRSId is mandatory for vertical extents when resourceScope = dataset</sch:title>

    <sch:title xml:lang="fr">verticalCRSId est obligatoire pour les étendues verticales lorsque resourceScope = dataset</sch:title>
    
    <sch:title xml:lang="de">verticalCRSId ist obligatorisch für vertikale Ausdehnungen wenn resourceScope = dataset</sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[
                        mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset'
                      ]/mdb:identificationInfo/che:CHE_MD_DataIdentification/mri:extent/gex:EX_Extent/gex:verticalElement">

      <!-- All vertical extents declared in identification extent -->
      <sch:let name="verticalExtents"
               value="gex:EX_VerticalExtent"/>

      <!-- Count vertical extents missing gex:verticalCRSId -->
      <sch:let name="missingCrsIdCount"
               value="count($verticalExtents[not(gex:verticalCRSId)])"/>

      <!-- If vertical extents are used, then each must provide a verticalCRSId -->
      <sch:assert test="count($verticalExtents) = 0 or $missingCrsIdCount = 0"
                  diagnostics="rule.gex.verticalcrsid-when-dataset-failure-en rule.gex.verticalcrsid-when-dataset-failure-fr rule.gex.verticalcrsid-when-dataset-failure-de"/>

      <sch:report test="count($verticalExtents) &gt; 0 and $missingCrsIdCount = 0"
                  diagnostics="rule.gex.verticalcrsid-when-dataset-success-en rule.gex.verticalcrsid-when-dataset-success-fr rule.gex.verticalcrsid-when-dataset-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mrs.refsys-identifier-when-dataset-failure-en" xml:lang="en">
      When resourceScope is 'dataset', at least one referenceSystemIdentifier (mcc:MD_Identifier code) MUST be provided in CHE_MD_Metadata.referenceSystemInfo.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrs.refsys-identifier-when-dataset-failure-fr" xml:lang="fr">
      Lorsque resourceScope vaut 'dataset', au moins un referenceSystemIdentifier (code de mcc:MD_Identifier) DOIT être renseigné dans CHE_MD_Metadata.referenceSystemInfo.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrs.refsys-identifier-when-dataset-failure-de" xml:lang="de">
      Wenn resourceScope 'dataset' ist, MUSS mindestens ein referenceSystemIdentifier (mcc:MD_Identifier code) in CHE_MD_Metadata.referenceSystemInfo angegeben werden.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrs.refsys-identifier-when-dataset-success-en" xml:lang="en">
      Reference system identifier is present for dataset resources.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrs.refsys-identifier-when-dataset-success-fr" xml:lang="fr">
      Un identifiant de système de référence est présent pour les jeux de données.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrs.refsys-identifier-when-dataset-success-de" xml:lang="de">
      Ein Referenzsystemidentifikator ist für Datensätze vorhanden.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mrs.refsys-identifier-required-when-dataset">

    <sch:title xml:lang="en">referenceSystemIdentifier is mandatory when resourceScope = dataset</sch:title>

    <sch:title xml:lang="fr">referenceSystemIdentifier est obligatoire lorsque resourceScope = dataset</sch:title>
    
    <sch:title xml:lang="de">referenceSystemIdentifier ist obligatorisch wenn resourceScope = dataset</sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset']/mdb:referenceSystemInfo">

      <!-- Count reference system identifiers with a non-empty MD_Identifier code -->
      <sch:let name="refIdCount"
               value="count(mrs:MD_ReferenceSystem/
                             mrs:referenceSystemIdentifier/mcc:MD_Identifier[
                               mcc:code/*[normalize-space(.) != '']
                             ])"/>

      <sch:assert test="$refIdCount &gt; 0"
                  diagnostics="rule.mrs.refsys-identifier-when-dataset-failure-en rule.mrs.refsys-identifier-when-dataset-failure-fr rule.mrs.refsys-identifier-when-dataset-failure-de"/>

      <sch:report test="$refIdCount &gt; 0"
                  diagnostics="rule.mrs.refsys-identifier-when-dataset-success-en rule.mrs.refsys-identifier-when-dataset-success-fr rule.mrs.refsys-identifier-when-dataset-success-de"/>

    </sch:rule>

  </sch:pattern>
  
  <sch:diagnostics>

    <sch:diagnostic id="rule.mrl.statement-when-dataset-failure-en" xml:lang="en">
      When resourceScope is 'dataset', the lineage statement (mrl:statement) MUST be provided in CHE_MD_Metadata.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrl.statement-when-dataset-failure-fr" xml:lang="fr">
      Lorsque resourceScope vaut 'dataset', l’élément d’historique mrl:statement DOIT être renseigné dans CHE_MD_Metadata.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrl.statement-when-dataset-failure-de" xml:lang="de">
        Wenn resourceScope 'dataset' ist, MUSS die Herkunftsaussage (mrl:statement) in CHE_MD_Metadata angegeben werden.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrl.statement-when-dataset-success-en" xml:lang="en">
      Lineage statement is present for dataset resources.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrl.statement-when-dataset-success-fr" xml:lang="fr">
      L’élément d’historique (statement) est présent pour les jeux de données.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrl.statement-when-dataset-success-de" xml:lang="de">
      Die Herkunftsaussage (statement) ist für Datensätze vorhanden.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mrl.statement-required-when-dataset">

    <sch:title xml:lang="en">Lineage statement is mandatory when lineage and resourceScope = dataset</sch:title>

    <sch:title xml:lang="fr">Le statement (historique) est obligatoire lorsque lineage and resourceScope = dataset</sch:title>
    
    <sch:title xml:lang="de">Das statement (Herkunft) ist obligatorisch wenn lineage und resourceScope = dataset</sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' and mdb:resourceLineage/mrl:LI_Lineage]">

      <!-- Non-empty lineage statement anywhere under resourceLineage/LI_Lineage/statement -->
      <sch:let name="statement"
               value="mdb:resourceLineage/mrl:LI_Lineage/mrl:statement/*[normalize-space(.) != '']"/>

      <sch:let name="hasStatement" value="count($statement) &gt; 0"/>

      <sch:assert test="$hasStatement"
                  diagnostics="rule.mrl.statement-when-dataset-failure-en rule.mrl.statement-when-dataset-failure-fr rule.mrl.statement-when-dataset-failure-de"/>

      <sch:report test="$hasStatement"
                  diagnostics="rule.mrl.statement-when-dataset-success-en rule.mrl.statement-when-dataset-success-fr rule.mrl.statement-when-dataset-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:pattern id="rule.gex.extenthasoneelement">

    <sch:title xml:lang="en">Extent MUST have one description or one geographic,
      temporal or vertical element
    </sch:title>

    <sch:title xml:lang="fr">Une étendue DOIT avoir une description ou un
      élément géographique, temporel ou vertical
    </sch:title>

    <sch:title xml:lang="de">Eine Ausdehnung MUSS eine Beschreibung oder ein
      geografisches, zeitliches oder vertikales Element enthalten
    </sch:title>


    <sch:rule context="//gex:EX_Extent">

      <!-- Check that element exist and is not empty ones.
      TODO improve nonEmpty checks -->

      <sch:let name="description" value="gex:description[text() != '']"/>

      <sch:let name="geographicId"
               value="gex:geographicElement/gex:EX_GeographicDescription/                          gex:geographicIdentifier[normalize-space(mcc:*) != '']"/>

      <sch:let name="geographicBox"
               value="gex:geographicElement/                          gex:EX_GeographicBoundingBox[                          normalize-space(gex:westBoundLongitude/gco:Decimal) != '' and                          normalize-space(gex:eastBoundLongitude/gco:Decimal) != '' and                          normalize-space(gex:southBoundLatitude/gco:Decimal) != '' and                          normalize-space(gex:northBoundLatitude/gco:Decimal) != ''                          ]"/>

      <sch:let name="geographicPoly"
               value="gex:geographicElement/gex:EX_BoundingPolygon[                          count(gex:polygon[normalize-space() != '']) > 0]"/>

      <sch:let name="temporal"
               value="gex:temporalElement/gex:EX_TemporalExtent[                          normalize-space(gex:extent) != '']"/>

      <sch:let name="vertical"
               value="gex:verticalElement/gex:EX_VerticalExtent[                          normalize-space(gex:minimumValue) != '' and                          normalize-space(gex:maximumValue) != '']"/>


      <sch:let name="hasAtLeastOneElement"
               value="count($description) +         count($geographicId) +         count($geographicBox) +         count($geographicPoly) +         count($temporal) +         count($vertical) &gt; 0         "/>


      <sch:assert test="$hasAtLeastOneElement"
                  diagnostics="rule.gex.extenthasoneelement-failure-en                       rule.gex.extenthasoneelement-failure-fr rule.gex.extenthasoneelement-failure-de"/>


      <sch:report test="count($description)"
                  diagnostics="rule.gex.extenthasoneelement-desc-success-en                       rule.gex.extenthasoneelement-desc-success-fr rule.gex.extenthasoneelement-desc-success-de"/>

      <sch:report test="count($geographicId)"
                  diagnostics="rule.gex.extenthasoneelement-id-success-en                       rule.gex.extenthasoneelement-id-success-fr rule.gex.extenthasoneelement-id-success-de"/>

      <sch:report test="count($geographicBox)"
                  diagnostics="rule.gex.extenthasoneelement-box-success-en                       rule.gex.extenthasoneelement-box-success-fr rule.gex.extenthasoneelement-box-success-de"/>

      <sch:report test="count($geographicPoly)"
                  diagnostics="rule.gex.extenthasoneelement-poly-success-en                       rule.gex.extenthasoneelement-poly-success-fr rule.gex.extenthasoneelement-poly-success-de"/>

      <sch:report test="count($temporal)"
                  diagnostics="rule.gex.extenthasoneelement-temporal-success-en                       rule.gex.extenthasoneelement-temporal-success-fr rule.gex.extenthasoneelement-temporal-success-de"/>

      <sch:report test="count($vertical)"
                  diagnostics="rule.gex.extenthasoneelement-vertical-success-en                       rule.gex.extenthasoneelement-vertical-success-fr rule.gex.extenthasoneelement-vertical-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.gex.verticalhascrsorcrsid-failure-en"
                    xml:lang="en">The vertical extent does not contains CRS or
      CRS identifier.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalhascrsorcrsid-failure-fr"
                    xml:lang="fr">L'étendue verticale ne contient pas de CRS ou
      d'identifiant de CRS.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalhascrsorcrsid-failure-de"
                    xml:lang="de">Die vertikale Ausdehnung enthält kein CRS oder keinen CRS-Identifikator.
    </sch:diagnostic>


    <sch:diagnostic id="rule.gex.verticalhascrsorcrsid-success-en"
                    xml:lang="en">The vertical extent contains CRS information.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalhascrsorcrsid-success-fr"
                    xml:lang="fr">L'étendue verticale contient les informations
      sur le CRS.
    </sch:diagnostic>

    <sch:diagnostic id="rule.gex.verticalhascrsorcrsid-success-de"
                    xml:lang="de">Die vertikale Ausdehnung enthält CRS-Informationen.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.gex.verticalhascrsorcrsid">

    <sch:title xml:lang="en">Vertical element MUST contains a CRS or CRS
      identifier
    </sch:title>

    <sch:title xml:lang="fr">Une étendue verticale DOIT contenir un CRS ou un
      identifiant de CRS
    </sch:title>

    <sch:title xml:lang="de">Eine vertikale Ausdehnung MUSS ein CRS oder einen
      CRS-Identifikator enthalten
    </sch:title>


    <sch:rule context="//gex:EX_VerticalExtent">


      <sch:let name="crs" value="gex:verticalCRS"/>

      <sch:let name="crsId" value="gex:verticalCRSId"/>

      <sch:let name="hasCrsOrCrsId" value="count($crs) + count($crsId) &gt; 0"/>


      <sch:assert test="$hasCrsOrCrsId"
                  diagnostics="rule.gex.verticalhascrsorcrsid-failure-en                       rule.gex.verticalhascrsorcrsid-failure-fr rule.gex.verticalhascrsorcrsid-failure-de"/>


      <sch:report test="$hasCrsOrCrsId"
                  diagnostics="rule.gex.verticalhascrsorcrsid-success-en                       rule.gex.verticalhascrsorcrsid-success-fr rule.gex.verticalhascrsorcrsid-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mco-legalconstraintdetails-failure-en"
                    xml:lang="en">
      The legal constraint is incomplete.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mco-legalconstraintdetails-failure-fr"
                    xml:lang="fr">
      La contrainte légale est incomplète.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mco-legalconstraintdetails-failure-de"
                    xml:lang="de">
      Die Rechtsbeschränkung ist unvollständig.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mco-legalconstraintdetails-success-en"
                    xml:lang="en">
      The legal constraint is complete.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mco-legalconstraintdetails-success-fr"
                    xml:lang="fr">
      La contrainte légale est complète.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mco-legalconstraintdetails-success-de"
                    xml:lang="de">
      Die Rechtsbeschränkung ist vollständig.
    </sch:diagnostic>


  </sch:diagnostics>
  <sch:pattern id="rule.mco-legalconstraintdetails">

    <sch:title xml:lang="en">Legal constraint MUST
      specified an access, use or other constraint or
      use limitation
    </sch:title>

    <sch:title xml:lang="fr">Une contrainte légale DOIT
      définir un type de contrainte (d'accès, d'utilisation ou autre)
      ou bien une limite d'utilisation
    </sch:title>

    <sch:title xml:lang="de">Eine Rechtsbeschränkung MUSS eine Zugangs-, Nutzungs-
      oder weitere Einschränkung oder eine Nutzungslimitierung definieren
    </sch:title>


    <sch:rule context="//che:CHE_MD_LegalConstraints">


      <sch:let name="accessConstraints"
               value="mco:accessConstraints[                 normalize-space(.) != '' or                 count(.//@codeListValue[. != '']) &gt; 0]"/>


      <sch:let name="useConstraints"
               value="mco:useConstraints/*[                  normalize-space(.) != '' or                  count(.//@codeListValue[. != '']) &gt; 0]"/>


      <sch:let name="otherConstraints"
               value="mco:otherConstraints/*[                  normalize-space(.) != '']"/>


      <sch:let name="useLimitation"
               value="mco:useLimitation/*[                  normalize-space(.) != '' or                  count(.//@codeListValue[. != '']) &gt; 0]"/>


      <sch:let name="hasDetails"
               value="count($accessConstraints) +                        count($useConstraints) +                        count($otherConstraints) +                        count($useLimitation)                     &gt; 0"/>


      <sch:assert test="$hasDetails"
                  diagnostics="rule.mco-legalconstraintdetails-failure-en                       rule.mco-legalconstraintdetails-failure-fr rule.mco-legalconstraintdetails-failure-de"/>


      <sch:report test="$hasDetails"
                  diagnostics="rule.mco-legalconstraintdetails-success-en                       rule.mco-legalconstraintdetails-success-fr rule.mco-legalconstraintdetails-success-de"/>


    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mco-legalconstraint-other-failure-en"
                    xml:lang="en">
      The legal constraint does not specified other constraints
      while access and use constraint is set to other restriction.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mco-legalconstraint-other-failure-fr"
                    xml:lang="fr">
      La contrainte légale ne précise pas les autres contraintes
      bien que les contraintes d'accès ou d'usage indiquent
      que d'autres restrictions s'appliquent.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mco-legalconstraint-other-failure-de"
                    xml:lang="de">
      Die Rechtsbeschränkung gibt keine weiteren Einschränkungen an, obwohl die Zugangs- oder Nutzungsbeschränkungen auf weitere Einschränkungen hinweisen.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mco-legalconstraint-other-success-en"
                    xml:lang="en">
      The legal constraint other constraints is
      "<sch:value-of select="$otherConstraints"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mco-legalconstraint-other-success-fr"
                    xml:lang="fr">
      Les autres contraintes de la contrainte légale sont
      "<sch:value-of select="$otherConstraints"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mco-legalconstraint-other-success-de"
                    xml:lang="de">
      Die weiteren Einschränkungen der Rechtsbeschränkung sind
      "<sch:value-of select="$otherConstraints"/>".
    </sch:diagnostic>


  </sch:diagnostics>
  <sch:pattern id="rule.mco-legalconstraint-other">

    <sch:title xml:lang="en">Legal constraint defining
      other restrictions for access or use constraint MUST
      specified other constraint.
    </sch:title>

    <sch:title xml:lang="fr">Une contrainte légale indiquant
      d'autres restrictions d'utilisation ou d'accès DOIT
      préciser ces autres restrictions
    </sch:title>

    <sch:title xml:lang="de">Eine Rechtsbeschränkung, die weitere Nutzungs- oder
      Zugangsbeschränkungen angibt, MUSS diese weiteren Einschränkungen angeben
    </sch:title>


    <sch:rule
            context="//che:CHE_MD_LegalConstraints[       mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue = 'otherRestrictions' or       mco:useConstraints/mco:MD_RestrictionCode/@codeListValue = 'otherRestrictions'       ]">


      <sch:let name="otherConstraints"
               value="mco:otherConstraints/*[normalize-space(.) != '']"/>


      <sch:let name="hasOtherConstraints"
               value="count($otherConstraints) &gt; 0"/>


      <sch:assert test="$hasOtherConstraints"
                  diagnostics="rule.mco-legalconstraint-other-failure-en                       rule.mco-legalconstraint-other-failure-fr rule.mco-legalconstraint-other-failure-de"/>


      <sch:report test="$hasOtherConstraints"
                  diagnostics="rule.mco-legalconstraint-other-success-en                       rule.mco-legalconstraint-other-success-fr rule.mco-legalconstraint-other-success-de"/>


    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.root-element-failure-en" xml:lang="en">The root
      element must be CHE_MD_Metadata.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.root-element-failure-fr" xml:lang="fr">Modifier
      l'élément racine du document pour que ce
      soit un élément CHE_MD_Metadata.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.root-element-failure-de" xml:lang="de">Das Wurzelelement des Dokuments muss CHE_MD_Metadata sein.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mdb.root-element-success-en" xml:lang="en">Root
      element CHE_MD_Metadata found.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.root-element-success-fr" xml:lang="fr">Élément
      racine CHE_MD_Metadata défini.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.root-element-success-de" xml:lang="de">Wurzelelement CHE_MD_Metadata gefunden.
    </sch:diagnostic>

  </sch:diagnostics>
  <!-- currently disabled
  <sch:pattern id="rule.mdb.root-element">

    <sch:title xml:lang="en">Metadata document root element</sch:title>

    <sch:title xml:lang="fr">Élément racine du document</sch:title>


    <sch:p xml:lang="en">A metadata instance document conforming to
      this specification SHALL have a root CHE_MD_Metadata element
      defined in the http://geocat.ch/che namespace.
    </sch:p>

    <sch:p xml:lang="fr">Une fiche de métadonnées conforme au standard
      ISO19115-3.2018.che DOIT avoir un élément racine CHE_MD_Metadata (défini dans l'espace
      de nommage "http://geocat.ch/che").
    </sch:p>

    <sch:rule context="/">

      <sch:let name="hasOneMD_MetadataElement"
               value="count(/che:CHE_MD_Metadata) = 1"/>


      <sch:assert test="$hasOneMD_MetadataElement"
                  diagnostics="rule.mdb.root-element-failure-en                     rule.mdb.root-element-failure-fr rule.mdb.root-element-failure-de"/>


      <sch:report test="$hasOneMD_MetadataElement"
                  diagnostics="rule.mdb.root-element-success-en                       rule.mdb.root-element-success-fr rule.mdb.root-element-success-de"/>

    </sch:rule>
  </sch:pattern>
  -->
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.defaultlocale-failure-en" xml:lang="en">The
      default locale character encoding is "UTF-8". Current value is
      "<sch:value-of select="$encoding"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-failure-fr" xml:lang="fr">
      L'encodage ne doit pas être vide. La valeur par défaut est
      "UTF-8". La valeur actuelle est "<sch:value-of select="$encoding"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-failure-de" xml:lang="de">
      Die Zeichenkodierung darf nicht leer sein. Der Standardwert ist
      "UTF-8". Der aktuelle Wert ist "<sch:value-of select="$encoding"/>".
    </sch:diagnostic>


    <sch:diagnostic id="rule.mdb.defaultlocale-success-en" xml:lang="en">The
      characeter encoding is "<sch:value-of select="$encoding"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-success-fr" xml:lang="fr">
      L'encodage est "<sch:value-of select="$encoding"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-success-de" xml:lang="de">
      Die Zeichenkodierung ist "<sch:value-of select="$encoding"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  <!-- currently disabled
  <sch:pattern id="rule.mdb.defaultlocale">

    <sch:title xml:lang="en">Default locale</sch:title>

    <sch:title xml:lang="fr">Langue du document</sch:title>


    <sch:p xml:lang="en">The default locale MUST be documented if
      not defined by the encoding. The default value for the character
      encoding is "UTF-8".
    </sch:p>

    <sch:p xml:lang="fr">La langue doit être documentée
      si non définie par l'encodage. L'encodage par défaut doit être "UTF-8".
    </sch:p>


    <sch:rule
            context="/che:CHE_MD_Metadata/mdb:defaultLocale|                        /che:CHE_MD_Metadata/mdb:identificationInfo/*/mri:defaultLocale">


      <sch:let name="encoding"
               value="string(lan:PT_Locale/lan:characterEncoding/                   lan:MD_CharacterSetCode/@codeListValue)"/>


      <sch:let name="hasEncoding" value="normalize-space($encoding) != ''"/>


      <sch:assert test="$hasEncoding"
                  diagnostics="rule.mdb.defaultlocale-failure-en                      rule.mdb.defaultlocale-failure-fr rule.mdb.defaultlocale-failure-de"/>


      <sch:report test="$hasEncoding"
                  diagnostics="rule.mdb.defaultlocale-success-en                      rule.mdb.defaultlocale-success-fr rule.mdb.defaultlocale-success-de"/>

    </sch:rule>

  </sch:pattern>
  -->
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.scope-name-failure-en" xml:lang="en">Specify a
      name for the metadata scope
      (required if the scope code is not "dataset", in that case
      "<sch:value-of select="$scopeCode"/>").
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.scope-name-failure-fr" xml:lang="fr">Préciser
      la description du domaine d'application
      (car le document décrit une ressource qui n'est pas un "jeu de données",
      la ressource est de type "<sch:value-of select="$scopeCode"/>").
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.scope-name-failure-de" xml:lang="de">Bitte den Namen des Metadatenbereichs angeben
      (da die Ressource kein "dataset" ist, sondern vom Typ "<sch:value-of select="$scopeCode"/>" ist).
    </sch:diagnostic>


    <sch:diagnostic id="rule.mdb.scope-name-success-en" xml:lang="en">Scope name
      "
      <sch:value-of select="$scopeCodeName"/>
      <sch:value-of select="$nilReason"/>"
      is defined for resource with type "<sch:value-of select="$scopeCode"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.scope-name-success-fr" xml:lang="fr">La
      description du domaine d'application
      "
      <sch:value-of select="$scopeCodeName"/>
      <sch:value-of select="$nilReason"/>"
      est renseignée pour la ressource de type "<sch:value-of
              select="$scopeCode"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.scope-name-success-de" xml:lang="de">Der Name des Metadatenbereichs
      "
      <sch:value-of select="$scopeCodeName"/>
      <sch:value-of select="$nilReason"/>"
      ist für die Ressource vom Typ "<sch:value-of select="$scopeCode"/>" angegeben.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mdb.scope-name">

    <sch:title xml:lang="en">Metadata scope Name</sch:title>

    <sch:title xml:lang="fr">Description du domaine d'application</sch:title>
    <sch:title xml:lang="de">Name des Metadatenbereichs</sch:title>


    <sch:p xml:lang="en">If a MD_MetadataScope element is present,
      the name property MUST have a value if resourceScope is not equal to
      "dataset"
    </sch:p>

    <sch:p xml:lang="fr">Si un élément domaine d'application (MD_MetadataScope)
      est défini, sa description (name) DOIT avoir une valeur
      si ce domaine n'est pas "jeu de données" (ie. "dataset").
    </sch:p>


    <sch:rule
            context="/che:CHE_MD_Metadata/mdb:metadataScope/                           mdb:MD_MetadataScope[not(mdb:resourceScope/                             mcc:MD_ScopeCode/@codeListValue = 'dataset')]">


      <sch:let name="scopeCode"
               value="string(mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue)"/>


      <sch:let name="scopeCodeName" value="normalize-space(mdb:name)"/>

      <sch:let name="hasScopeCodeName"
               value="normalize-space($scopeCodeName) != ''"/>


      <sch:let name="nilReason" value="string(mdb:name/@gco:nilReason)"/>

      <sch:let name="hasNilReason" value="$nilReason != ''"/>


      <sch:assert test="$hasScopeCodeName or $hasNilReason"
                  diagnostics="rule.mdb.scope-name-failure-en                      rule.mdb.scope-name-failure-fr rule.mdb.scope-name-failure-de"/>


      <sch:report test="$hasScopeCodeName or $hasNilReason"
                  diagnostics="rule.mdb.scope-name-success-en                      rule.mdb.scope-name-success-fr rule.mdb.scope-name-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.create-date-failure-en" xml:lang="en">Specify a
      creation date for the metadata record
      in the metadata section.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.create-date-failure-fr" xml:lang="fr">Définir
      une date de création pour le document
      dans la section sur les métadonnées.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.create-date-failure-de" xml:lang="de">Ein Erstellungsdatum für das Dokument
      im Metadatenabschnitt angeben.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mdb.create-date-success-en" xml:lang="en">
      Metadata creation date:<sch:value-of select="$creationDates"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.create-date-success-fr" xml:lang="fr">
      Date de création du document :<sch:value-of select="$creationDates"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.create-date-success-de" xml:lang="de">
      Erstellungsdatum des Dokuments:<sch:value-of select="$creationDates"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mdb.create-date">

    <sch:title xml:lang="en">Metadata create date</sch:title>

    <sch:title xml:lang="fr">Date de création du document</sch:title>
    
    <sch:title xml:lang="de">Erstellungsdatum des Dokuments</sch:title>


    <sch:p xml:lang="en">A dateInfo property value with data type = "creation"
      MUST be present in every MD_Metadata instance.
    </sch:p>

    <sch:p xml:lang="fr">Tout document DOIT avoir une date de création
      définie (en utilisant un élément dateInfo avec un type de date
      "creation").
    </sch:p>

    <sch:p xml:lang="de">Jedes Dokument MUSS ein Erstellungsdatum haben
      (definiert mit einem dateInfo-Element mit dem Datumstyp "creation").
    </sch:p>

    <sch:rule context="che:CHE_MD_Metadata">

      <sch:let name="creationDates"
               value="./mdb:dateInfo/cit:CI_Date[(normalize-space(cit:date/gco:DateTime) != '' or normalize-space(cit:date/gco:Date) != '') and                      cit:dateType/cit:CI_DateTypeCode/@codeListValue = 'creation']/                   cit:date[./gco:DateTime|./gco:Date]/*"/>

      <!-- Check at least one non empty creation date element is defined. -->

      <sch:let name="hasAtLeastOneCreationDate"
               value="count(./mdb:dateInfo/cit:CI_Date[(normalize-space(cit:date/gco:DateTime) != '' or normalize-space(cit:date/gco:Date) != '') and                      cit:dateType/cit:CI_DateTypeCode/@codeListValue = 'creation']                     ) &gt; 0"/>


      <sch:assert test="$hasAtLeastOneCreationDate"
                  diagnostics="rule.mdb.create-date-failure-en                      rule.mdb.create-date-failure-fr rule.mdb.create-date-failure-de"/>

      <sch:report test="$hasAtLeastOneCreationDate"
                  diagnostics="rule.mdb.create-date-success-en                      rule.mdb.create-date-success-fr rule.mdb.create-date-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.metadataidentifier-mandatory-failure-en" xml:lang="en">
      Metadata identifier is mandatory when resource scope is 'dataset', 'series' or 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.metadataidentifier-mandatory-failure-fr" xml:lang="fr">
      L'identifiant des métadonnées est obligatoire quand la portée de la ressource est 'dataset', 'series' ou 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.metadataidentifier-mandatory-failure-de" xml:lang="de">
      Der Metadatenidentifikator ist obligatorisch wenn der Ressourcenbereich 'dataset', 'series' oder 'service' ist.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.metadataidentifier-mandatory-success-en" xml:lang="en">
      Metadata identifier is defined: "<sch:value-of select="$metadataIdentifier"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.metadataidentifier-mandatory-success-fr" xml:lang="fr">
      L'identifiant des métadonnées est défini : "<sch:value-of select="$metadataIdentifier"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.metadataidentifier-mandatory-success-de" xml:lang="de">
      Der Metadatenidentifikator ist definiert: "<sch:value-of select="$metadataIdentifier"/>".
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mdb.metadataidentifier-mandatory">

    <sch:title xml:lang="en">Metadata identifier mandatory</sch:title>

    <sch:title xml:lang="fr">Identifiant des métadonnées obligatoire</sch:title>
    
    <sch:title xml:lang="de">Metadatenidentifikator obligatorisch</sch:title>

    <sch:p xml:lang="en">When metadata scope resourceScope is 'dataset', 'series' or 'service',
      the metadata identifier MUST be specified.
    </sch:p>

    <sch:p xml:lang="fr">Quand la portée des métadonnées (resourceScope) est 'dataset', 'series' ou 'service',
      l'identifiant des métadonnées DOIT être spécifié.
    </sch:p>

    <sch:p xml:lang="de">Wenn die Metadatenbereichsressource 'dataset', 'series' oder 'service' ist,
      muss der Metadatenidentifikator angegeben werden.
    </sch:p>

    <sch:rule context="che:CHE_MD_Metadata[
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']">

      <sch:let name="metadataIdentifier"
               value="normalize-space(mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString)"/>

      <sch:let name="hasMetadataIdentifier" value="$metadataIdentifier != ''"/>

      <sch:assert test="$hasMetadataIdentifier"
                  diagnostics="rule.mdb.metadataidentifier-mandatory-failure-en
                              rule.mdb.metadataidentifier-mandatory-failure-fr rule.mdb.metadataidentifier-mandatory-failure-de"/>

      <sch:report test="$hasMetadataIdentifier"
                  diagnostics="rule.mdb.metadataidentifier-mandatory-success-en
                              rule.mdb.metadataidentifier-mandatory-success-fr rule.mdb.metadataidentifier-mandatory-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mdb.defaultlocale-mandatory-failure-en" xml:lang="en">
      Default locale is mandatory when resource scope is 'dataset', 'series' or 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-mandatory-failure-fr" xml:lang="fr">
      La langue par défaut est obligatoire quand la portée de la ressource est 'dataset', 'series' ou 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-mandatory-failure-de" xml:lang="de">
      Die Standardsprache ist obligatorisch wenn der Ressourcenbereich 'dataset', 'series' oder 'service' ist.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-mandatory-success-en" xml:lang="en">
      Default locale is defined with language: "<sch:value-of select="$language"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-mandatory-success-fr" xml:lang="fr">
      La langue par défaut est définie avec la langue : "<sch:value-of select="$language"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mdb.defaultlocale-mandatory-success-de" xml:lang="de">
      Die Standardsprache ist mit der Sprache "<sch:value-of select="$language"/>" definiert.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mdb.defaultlocale-mandatory">

    <sch:title xml:lang="en">Default locale mandatory</sch:title>

    <sch:title xml:lang="fr">Langue par défaut obligatoire</sch:title>

    <sch:title xml:lang="de">Standardsprache obligatorisch</sch:title>

    <sch:p xml:lang="en">When metadata scope resourceScope is 'dataset', 'series' or 'service',
      the default locale MUST be specified.
    </sch:p>

    <sch:p xml:lang="fr">Quand la portée des métadonnées (resourceScope) est 'dataset', 'series' ou 'service',
      la langue par défaut DOIT être spécifiée.
    </sch:p>

    <sch:p xml:lang="de">Wenn die Metadatenbereichsressource 'dataset', 'series' oder 'service' ist,
        muss die Standardsprache angegeben werden.
    </sch:p>

    <sch:rule context="che:CHE_MD_Metadata[
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or  
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']">

      <sch:let name="language"
               value="normalize-space(mdb:defaultLocale/lan:PT_Locale/lan:language/lan:LanguageCode/@codeListValue)"/>

      <sch:let name="hasDefaultLocale" value="$language != ''"/>

      <sch:assert test="$hasDefaultLocale"
                  diagnostics="rule.mdb.defaultlocale-mandatory-failure-en
                              rule.mdb.defaultlocale-mandatory-failure-fr rule.mdb.defaultlocale-mandatory-failure-de"/>

      <sch:report test="$hasDefaultLocale"
                  diagnostics="rule.mdb.defaultlocale-mandatory-success-en
                              rule.mdb.defaultlocale-mandatory-success-fr rule.mdb.defaultlocale-mandatory-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mex.datatypedetails-maxocc-failure-en"
                    xml:lang="en">
      Extended element information "<sch:value-of select="$name"/>"
      of type "<sch:value-of select="$dataType"/>"
      does not specified max occurence.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.datatypedetails-maxocc-failure-fr"
                    xml:lang="fr">
      L'élément d'extension "<sch:value-of select="$name"/>"
      de type "<sch:value-of select="$dataType"/>"
      ne précise pas le nombre d'occurences maximum.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.datatypedetails-maxocc-failure-de"
                    xml:lang="de">
      Das Erweiterungselement "<sch:value-of select="$name"/>"
      vom Typ "<sch:value-of select="$dataType"/>"
      gibt kein maximales Vorkommen an.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mex.datatypedetails-maxocc-success-en"
                    xml:lang="en">
      Extended element information "<sch:value-of select="$name"/>"
      of type "<sch:value-of select="$dataType"/>"
      has max occurence: "<sch:value-of select="$maximumOccurrence"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.datatypedetails-maxocc-success-fr"
                    xml:lang="fr">
      L'élément d'extension "<sch:value-of select="$name"/>"
      de type "<sch:value-of select="$dataType"/>"
      a pour nombre d'occurences maximum : "<sch:value-of
            select="$maximumOccurrence"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.datatypedetails-maxocc-success-de"
                    xml:lang="de">
      Das Erweiterungselement "<sch:value-of select="$name"/>"
      vom Typ "<sch:value-of select="$dataType"/>"
      hat das maximale Vorkommen: "<sch:value-of select="$maximumOccurrence"/>".
    </sch:diagnostic>


    <sch:diagnostic id="rule.mex.datatypedetails-domain-failure-en"
                    xml:lang="en">
      Extended element information "<sch:value-of select="$name"/>"
      of type "<sch:value-of select="$dataType"/>"
      does not specified domain value.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.datatypedetails-domain-failure-fr"
                    xml:lang="fr">
      L'élément d'extension "<sch:value-of select="$name"/>"
      de type "<sch:value-of select="$dataType"/>"
      ne précise pas la valeur du domaine.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.datatypedetails-domain-failure-de"
                    xml:lang="de">
      Das Erweiterungselement "<sch:value-of select="$name"/>"
      vom Typ "<sch:value-of select="$dataType"/>"
      gibt keinen Domänenwert an.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mex.datatypedetails-domain-success-en"
                    xml:lang="en">
      Extended element information "<sch:value-of select="$name"/>"
      of type "<sch:value-of select="$dataType"/>"
      has domain value: "<sch:value-of select="$domainValue"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.datatypedetails-domain-success-fr"
                    xml:lang="fr">
      L'élément d'extension "<sch:value-of select="$name"/>"
      de type "<sch:value-of select="$dataType"/>"
      a pour valeur du domaine : "<sch:value-of select="$domainValue"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.datatypedetails-domain-success-de"
                    xml:lang="de">
      Das Erweiterungselement "<sch:value-of select="$name"/>"
      vom Typ "<sch:value-of select="$dataType"/>"
      hat den Domänenwert: "<sch:value-of select="$domainValue"/>".
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mex.datatypedetails">

    <sch:title xml:lang="en">Extended element information
      which are not codelist, enumeration or codelistElement
      MUST specified max occurence and domain value
    </sch:title>

    <sch:title xml:lang="fr">Un élément d'extension qui n'est
      ni une codelist, ni une énumération, ni un élément de codelist
      DOIT préciser le nombre maximum d'occurences
      ainsi que la valeur du domaine
    </sch:title>

    <sch:title xml:lang="de">Ein Erweiterungselement, das keine Codeliste, keine
      Aufzählung und kein Codelistenelement ist, MUSS das maximale
      Vorkommen und den Domänenwert angeben
    </sch:title>


    <sch:rule
            context="//mex:MD_ExtendedElementInformation[       mex:dataType/mex:MD_DatatypeCode/@codeListValue != 'codelist' and       mex:dataType/mex:MD_DatatypeCode/@codeListValue != 'enumeration' and       mex:dataType/mex:MD_DatatypeCode/@codeListValue != 'codelistElement'       ]">


      <sch:let name="name" value="normalize-space(mex:name/*)"/>


      <sch:let name="dataType"
               value="normalize-space(mex:dataType/mex:MD_DatatypeCode/@codeListValue)"/>


      <sch:let name="maximumOccurrence"
               value="normalize-space(mex:maximumOccurrence/*)"/>


      <sch:let name="hasMaximumOccurrence" value="$maximumOccurrence != ''"/>


      <sch:assert test="$hasMaximumOccurrence"
                  diagnostics="rule.mex.datatypedetails-maxocc-failure-en                       rule.mex.datatypedetails-maxocc-failure-fr rule.mex.datatypedetails-maxocc-failure-de"/>


      <sch:report test="$hasMaximumOccurrence"
                  diagnostics="rule.mex.datatypedetails-maxocc-success-en                       rule.mex.datatypedetails-maxocc-success-fr rule.mex.datatypedetails-maxocc-success-de"/>


      <sch:let name="domainValue" value="normalize-space(mex:domainValue/*)"/>


      <sch:let name="hasDomainValue" value="$domainValue != ''"/>


      <sch:assert test="$hasDomainValue"
                  diagnostics="rule.mex.datatypedetails-domain-failure-en                       rule.mex.datatypedetails-domain-failure-fr rule.mex.datatypedetails-domain-failure-de"/>


      <sch:report test="$hasDomainValue"
                  diagnostics="rule.mex.datatypedetails-domain-success-en                       rule.mex.datatypedetails-domain-success-fr rule.mex.datatypedetails-domain-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mex.conditional-failure-en" xml:lang="en">
      The conditional extended element "<sch:value-of select="$name"/>"
      does not specified the condition.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.conditional-failure-fr" xml:lang="fr">
      L'élément d'extension conditionnel "<sch:value-of select="$name"/>"
      ne précise pas les termes de la condition.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.conditional-failure-de" xml:lang="de">
      Das bedingte Erweiterungselement "<sch:value-of select="$name"/>"
      gibt die Bedingung nicht an.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mex.conditional-success-en" xml:lang="en">
      The conditional extended element "<sch:value-of select="$name"/>"
      has for condition: "<sch:value-of select="$condition"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.conditional-success-fr" xml:lang="fr">
      L'élément d'extension conditionnel "<sch:value-of select="$name"/>"
      a pour condition : "<sch:value-of select="$condition"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.conditional-success-de" xml:lang="de">
      Das bedingte Erweiterungselement "<sch:value-of select="$name"/>"
      hat die Bedingung: "<sch:value-of select="$condition"/>".
    </sch:diagnostic>


  </sch:diagnostics>
  <sch:pattern id="rule.mex.conditional">

    <sch:title xml:lang="en">Extended element information
      which are conditional MUST explained the condition
    </sch:title>

    <sch:title xml:lang="fr">Un élément d'extension conditionnel
      DOIT préciser les termes de la condition
    </sch:title>

    <sch:title xml:lang="de">Ein bedingtes Erweiterungselement
      MUSS die Bedingung angeben
    </sch:title>


    <sch:rule
            context="//mex:MD_ExtendedElementInformation[       mex:obligation/mex:MD_ObligationCode = 'conditional'       ]">


      <sch:let name="name" value="normalize-space(mex:name/*)"/>


      <sch:let name="condition" value="normalize-space(mex:condition/*)"/>


      <sch:let name="hasCondition" value="$condition != ''"/>


      <sch:assert test="$hasCondition"
                  diagnostics="rule.mex.conditional-failure-en                       rule.mex.conditional-failure-fr rule.mex.conditional-failure-de"/>


      <sch:report test="$hasCondition"
                  diagnostics="rule.mex.conditional-success-en                       rule.mex.conditional-success-fr rule.mex.conditional-success-de"/>


    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mex.mandatorycode-failure-en" xml:lang="en">
      The extended element "<sch:value-of select="$name"/>"
      of type "<sch:value-of select="$dataType"/>"
      does not specified a code.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.mandatorycode-failure-fr" xml:lang="fr">
      L'élément d'extension "<sch:value-of select="$name"/>"
      de type "<sch:value-of select="$dataType"/>"
      ne précise pas de code.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.mandatorycode-failure-de" xml:lang="de">
      Das Erweiterungselement "<sch:value-of select="$name"/>"
      vom Typ "<sch:value-of select="$dataType"/>"
      gibt keinen Code an.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mex.mandatorycode-success-en" xml:lang="en">
      The extended element "<sch:value-of select="$name"/>"
      of type "<sch:value-of select="$dataType"/>"
      has for code: "<sch:value-of select="$code"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.mandatorycode-success-fr" xml:lang="fr">
      L'élément d'extension "<sch:value-of select="$name"/>"
      de type "<sch:value-of select="$dataType"/>"
      a pour code : "<sch:value-of select="$code"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.mandatorycode-success-de" xml:lang="de">
      Das Erweiterungselement "<sch:value-of select="$name"/>"
      vom Typ "<sch:value-of select="$dataType"/>"
      hat den Code: "<sch:value-of select="$code"/>".
    </sch:diagnostic>


    <sch:diagnostic id="rule.mex.mex.mandatoryconceptname-failure-en"
                    xml:lang="en">
      The extended element "<sch:value-of select="$name"/>"
      of type "<sch:value-of select="$dataType"/>"
      does not specified a concept name.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.mex.mandatoryconceptname-failure-fr"
                    xml:lang="fr">
      L'élément d'extension "<sch:value-of select="$name"/>"
      de type "<sch:value-of select="$dataType"/>"
      ne précise pas de nom de concept.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.mex.mandatoryconceptname-failure-de"
                    xml:lang="de">
      Das Erweiterungselement "<sch:value-of select="$name"/>"
      vom Typ "<sch:value-of select="$dataType"/>"
      gibt keinen Konzeptnamen an.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mex.mex.mandatoryconceptname-success-en"
                    xml:lang="en">
      The extended element "<sch:value-of select="$name"/>"
      of type "<sch:value-of select="$dataType"/>"
      has for concept name: "<sch:value-of select="$conceptName"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.mex.mandatoryconceptname-success-fr"
                    xml:lang="fr">
      L'élément d'extension "<sch:value-of select="$name"/>"
      de type "<sch:value-of select="$dataType"/>"
      a pour nom de concept : "<sch:value-of select="$conceptName"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mex.mex.mandatoryconceptname-success-de"
                    xml:lang="de">
      Das Erweiterungselement "<sch:value-of select="$name"/>"
      vom Typ "<sch:value-of select="$dataType"/>"
      hat den Konzeptnamen: "<sch:value-of select="$conceptName"/>".
    </sch:diagnostic>


  </sch:diagnostics>
  <sch:pattern id="rule.mex.mandatorycode">

    <sch:title xml:lang="en">Extended element information
      which are codelist, enumeration or codelistElement
      MUST specified a code and a concept name
    </sch:title>

    <sch:title xml:lang="fr">Un élément d'extension qui est
      une codelist, une énumération, un élément de codelist
      DOIT préciser un code et un nom de concept
    </sch:title>

    <sch:title xml:lang="de">Ein Erweiterungselement, das eine Codeliste,
      Aufzählung oder ein Codelistenelement ist, MUSS einen Code
      und einen Konzeptnamen angeben
    </sch:title>


    <sch:rule
            context="//mex:MD_ExtendedElementInformation[       mex:dataType/mex:MD_DatatypeCode/@codeListValue = 'codelist' or       mex:dataType/mex:MD_DatatypeCode/@codeListValue = 'enumeration' or       mex:dataType/mex:MD_DatatypeCode/@codeListValue = 'codelistElement'       ]">


      <sch:let name="name" value="normalize-space(mex:name/*)"/>


      <sch:let name="dataType"
               value="normalize-space(mex:dataType/mex:MD_DatatypeCode/@codeListValue)"/>


      <sch:let name="code" value="normalize-space(mex:code/*)"/>


      <sch:let name="hasCode" value="$code != ''"/>


      <sch:assert test="$hasCode"
                  diagnostics="rule.mex.mandatorycode-failure-en                       rule.mex.mandatorycode-failure-fr rule.mex.mandatorycode-failure-de"/>


      <sch:report test="$hasCode"
                  diagnostics="rule.mex.mandatorycode-success-en                       rule.mex.mandatorycode-success-fr rule.mex.mandatorycode-success-de"/>


      <sch:let name="conceptName" value="normalize-space(mex:conceptName/*)"/>


      <sch:let name="hasConceptName" value="$conceptName != ''"/>


      <sch:assert test="$hasConceptName"
                  diagnostics="rule.mex.mex.mandatoryconceptname-failure-en                       rule.mex.mex.mandatoryconceptname-failure-fr rule.mex.mex.mandatoryconceptname-failure-de"/>


      <sch:report test="$hasConceptName"
                  diagnostics="rule.mex.mex.mandatoryconceptname-success-en                       rule.mex.mex.mandatoryconceptname-success-fr rule.mex.mex.mandatoryconceptname-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mrc.sampledimension-failure-en" xml:lang="en">The
      sample dimension does not provide max, min or mean value.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.sampledimension-failure-fr" xml:lang="fr">La
      dimension ne précise pas de valeur maximum ou minimum ni de moyenne.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.sampledimension-failure-de" xml:lang="de">Die
      Dimension gibt keinen Maximal-, Minimal- oder Mittelwert an.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mrc.sampledimension-max-success-en" xml:lang="en">
      The sample dimension max value is
      "<sch:value-of select="normalize-space($max)"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.sampledimension-max-success-fr" xml:lang="fr">
      La valeur maximum de la dimension de l'échantillon est
      "<sch:value-of select="normalize-space($max)"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.sampledimension-max-success-de" xml:lang="de">
      Der Maximalwert der Stichprobendimension ist
      "<sch:value-of select="normalize-space($max)"/>".
    </sch:diagnostic>


    <sch:diagnostic id="rule.mrc.sampledimension-min-success-en" xml:lang="en">
      The sample dimension min value is
      "<sch:value-of select="normalize-space($min)"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.sampledimension-min-success-fr" xml:lang="fr">
      La valeur minimum de la dimension de l'échantillon est
      "<sch:value-of select="normalize-space($min)"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.sampledimension-min-success-de" xml:lang="de">
      Der Minimalwert der Stichprobendimension ist
      "<sch:value-of select="normalize-space($min)"/>".
    </sch:diagnostic>


    <sch:diagnostic id="rule.mrc.sampledimension-mean-success-en" xml:lang="en">
      The sample dimension mean value is
      "<sch:value-of select="normalize-space($mean)"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.sampledimension-mean-success-fr" xml:lang="fr">
      La valeur moyenne de la dimension de l'échantillon est
      "<sch:value-of select="normalize-space($mean)"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.sampledimension-mean-success-de" xml:lang="de">
      Der Mittelwert der Stichprobendimension ist
      "<sch:value-of select="normalize-space($mean)"/>".
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mrc.sampledimension">

    <sch:title xml:lang="en">Sample dimension MUST provide a max,
      a min or a mean value
    </sch:title>

    <sch:title xml:lang="fr">La dimension de l'échantillon DOIT préciser
      une valeur maximum, une valeur minimum ou une moyenne
    </sch:title>

    <sch:title xml:lang="de">Die Stichprobendimension MUSS einen Maximal-,
      Minimal- oder Mittelwert angeben
    </sch:title>


    <sch:rule context="//mrc:MD_SampleDimension">


      <sch:let name="max" value="mrc:maxValue[normalize-space(*) != '']"/>

      <sch:let name="min" value="mrc:minValue[normalize-space(*) != '']"/>

      <sch:let name="mean" value="mrc:meanValue[normalize-space(*) != '']"/>


      <sch:let name="hasMaxOrMinOrMean"
               value="count($max) + count($min) + count($mean) &gt; 0"/>


      <sch:assert test="$hasMaxOrMinOrMean"
                  diagnostics="rule.mrc.sampledimension-failure-en                       rule.mrc.sampledimension-failure-fr rule.mrc.sampledimension-failure-de"/>


      <sch:report test="count($max)"
                  diagnostics="rule.mrc.sampledimension-max-success-en                       rule.mrc.sampledimension-max-success-fr rule.mrc.sampledimension-max-success-de"/>

      <sch:report test="count($min)"
                  diagnostics="rule.mrc.sampledimension-min-success-en                       rule.mrc.sampledimension-min-success-fr rule.mrc.sampledimension-min-success-de"/>

      <sch:report test="count($mean)"
                  diagnostics="rule.mrc.sampledimension-mean-success-en                       rule.mrc.sampledimension-mean-success-fr rule.mrc.sampledimension-mean-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mrc.bandunit-failure-en" xml:lang="en">The band
      defined a bound without unit.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.bandunit-failure-fr" xml:lang="fr">La bande
      définit une borne minimum et/ou maximum
      sans préciser d'unité.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.bandunit-failure-de" xml:lang="de">Das Band
      definiert eine untere und/oder obere Grenze ohne Einheitsangabe.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mrc.bandunit-success-en" xml:lang="en">
      The band bound [<sch:value-of select="$min"/>-<sch:value-of
            select="$max"/>] unit is
      "<sch:value-of select="$units"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.bandunit-success-fr" xml:lang="fr">
      L'unité de la borne [<sch:value-of select="$min"/>-<sch:value-of
            select="$max"/>] est
      "<sch:value-of select="$units"/>".
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrc.bandunit-success-de" xml:lang="de">
      Die Einheit der Grenze [<sch:value-of select="$min"/>-<sch:value-of
            select="$max"/>] ist
      "<sch:value-of select="$units"/>".
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mrc.bandunit">

    <sch:title xml:lang="en">Band MUST specified bounds units
      when a bound max or bound min is defined
    </sch:title>

    <sch:title xml:lang="fr">Une bande DOIT préciser l'unité
      lorsqu'une borne maximum ou minimum est définie
    </sch:title>

    <sch:title xml:lang="de">Ein Band MUSS die Einheit angeben,
      wenn eine obere oder untere Grenze definiert ist
    </sch:title>


    <sch:rule
            context="//mrc:MD_Band[       normalize-space(mrc:boundMax/*) != '' or        normalize-space(mrc:boundMin/*) != ''       ]">


      <sch:let name="max" value="normalize-space(mrc:boundMax/*)"/>

      <sch:let name="min" value="normalize-space(mrc:boundMin/*)"/>

      <sch:let name="units"
               value="normalize-space(mrc:boundUnits[normalize-space(*) != ''])"/>


      <sch:let name="hasUnits" value="$units != ''"/>


      <sch:assert test="$hasUnits"
                  diagnostics="rule.mrc.bandunit-failure-en          rule.mrc.bandunit-failure-fr rule.mrc.bandunit-failure-de"/>


      <sch:report test="$hasUnits"
                  diagnostics="rule.mrc.bandunit-success-en                       rule.mrc.bandunit-success-fr rule.mrc.bandunit-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mrd.mediumunit-failure-en" xml:lang="en">The medium
      define a density without unit.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrd.mediumunit-failure-fr" xml:lang="fr">La densité
      du média est définie sans unité.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrd.mediumunit-failure-de" xml:lang="de">Die Dichte
      des Mediums ist ohne Einheit angegeben.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mrd.mediumunit-success-en" xml:lang="en">
      Medium density is "<sch:value-of select="$density"/>" (unit:
      "<sch:value-of select="$units"/>").
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrd.mediumunit-success-fr" xml:lang="fr">
      La densité du média est "<sch:value-of select="$density"/>" (unité :
      "<sch:value-of select="$units"/>").
    </sch:diagnostic>

    <sch:diagnostic id="rule.mrd.mediumunit-success-de" xml:lang="de">
      Die Dichte des Mediums ist "<sch:value-of select="$density"/>" (Einheit:
      "<sch:value-of select="$units"/>").
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mrd.mediumunit">

    <sch:title xml:lang="en">Medium having density MUST specified density
      units
    </sch:title>

    <sch:title xml:lang="fr">Un média précisant une densité DOIT préciser
      l'unité
    </sch:title>

    <sch:title xml:lang="de">Ein Medium, das eine Dichte angibt,
      MUSS die Einheit angeben
    </sch:title>


    <sch:rule context="//mrd:MD_Medium[mrd:density]">


      <sch:let name="density" value="normalize-space(mrd:density/*)"/>

      <sch:let name="units"
               value="normalize-space(mrd:densityUnits[normalize-space(*) != ''])"/>


      <sch:let name="hasUnits" value="$units != ''"/>


      <sch:assert test="$hasUnits"
                  diagnostics="rule.mrd.mediumunit-failure-en                       rule.mrd.mediumunit-failure-fr rule.mrd.mediumunit-failure-de"/>


      <sch:report test="$hasUnits"
                  diagnostics="rule.mrd.mediumunit-success-en                       rule.mrd.mediumunit-success-fr rule.mrd.mediumunit-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mri.datasetextent-failure-en" xml:lang="en">
      dataset or series description MUST provide a bounding box.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.datasetextent-failure-fr" xml:lang="fr">La description d'un jeu
      de données ou d'une collection DOIT comprendre une emprise.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.datasetextent-failure-de" xml:lang="de">Die Beschreibung eines
      Datensatzes oder einer Serie MUSS eine Begrenzungsbox enthalten.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mri.datasetextentbox-success-en" xml:lang="en">The
      dataset geographic bounding box is:
      [W:<sch:value-of select="$geobox/gex:westBoundLongitude/*/text()"/>,
      S:<sch:value-of select="$geobox/gex:southBoundLatitude/*/text()"/>],
      [E:<sch:value-of select="$geobox/gex:eastBoundLongitude/*/text()"/>,
      N:<sch:value-of select="$geobox/gex:northBoundLatitude/*/text()"/>],
      .
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.datasetextentbox-success-fr" xml:lang="fr">
      L'emprise géographique du jeu de données est
      [W:<sch:value-of select="$geobox/gex:westBoundLongitude/*/text()"/>,
      S:<sch:value-of select="$geobox/gex:southBoundLatitude/*/text()"/>],
      [E:<sch:value-of select="$geobox/gex:eastBoundLongitude/*/text()"/>,
      N:<sch:value-of select="$geobox/gex:northBoundLatitude/*/text()"/>]
      .
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.datasetextentbox-success-de" xml:lang="de">
      Das geografische Begrenzungsrechteck des Datensatzes ist
      [W:<sch:value-of select="$geobox/gex:westBoundLongitude/*/text()"/>,
      S:<sch:value-of select="$geobox/gex:southBoundLatitude/*/text()"/>],
      [E:<sch:value-of select="$geobox/gex:eastBoundLongitude/*/text()"/>,
      N:<sch:value-of select="$geobox/gex:northBoundLatitude/*/text()"/>]
      .
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mri.datasetextent">

    <sch:title xml:lang="en">Dataset extent</sch:title>

    <sch:title xml:lang="fr">Emprise du jeu de données</sch:title>

    <sch:title xml:lang="de">Ausdehnung des Datensatzes</sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series']/                           mdb:identificationInfo/che:CHE_MD_DataIdentification">


      <sch:let name="geobox"
               value="mri:extent/gex:EX_Extent/gex:geographicElement/                   gex:EX_GeographicBoundingBox[                   normalize-space(gex:westBoundLongitude/gco:Decimal) != '' and                   normalize-space(gex:eastBoundLongitude/gco:Decimal) != '' and                   normalize-space(gex:southBoundLatitude/gco:Decimal) != '' and                   normalize-space(gex:northBoundLatitude/gco:Decimal) != ''                   ]"/>


      <sch:let name="hasGeoextent"
               value="count($geobox) &gt; 0"/>


      <sch:assert test="$hasGeoextent"
                  diagnostics="rule.mri.datasetextent-failure-en                       rule.mri.datasetextent-failure-fr rule.mri.datasetextent-failure-de"/>

      <!-- TODO: Improve reporting when having multiple elements -->

      <sch:report test="count($geobox) &gt; 0"
                  diagnostics="rule.mri.datasetextentbox-success-en                       rule.mri.datasetextentbox-success-fr rule.mri.datasetextentbox-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mri.topicategoryfordsandseries-failure-en"
                    xml:lang="en">A topic category MUST be specified for
      dataset or series.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.topicategoryfordsandseries-failure-fr"
                    xml:lang="fr">Un thème principal (ISO) DOIT être défini
      quand
      la ressource est un jeu de donnée ou une série.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.topicategoryfordsandseries-failure-de"
                    xml:lang="de">Ein Themenbereich (ISO) MUSS angegeben werden,
      wenn die Ressource ein Datensatz oder eine Serie ist.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mri.topicategoryfordsandseries-success-en"
                    xml:lang="en">Number of topic category identified:
      <sch:value-of select="count($topics)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.topicategoryfordsandseries-success-fr"
                    xml:lang="fr">Nombre de thèmes :
      <sch:value-of select="count($topics)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.topicategoryfordsandseries-success-de"
                    xml:lang="de">Anzahl der Themenbereiche:
      <sch:value-of select="count($topics)"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mri.topicategoryfordsandseries">

    <sch:title xml:lang="en">Topic category for dataset and series</sch:title>

    <sch:title xml:lang="fr">Thème principal d'un jeu de données ou d'une
      série
    </sch:title>

    <sch:title xml:lang="de">Themenbereich eines Datensatzes oder einer
      Serie
    </sch:title>


    <sch:rule
            context="/che:CHE_MD_Metadata[mdb:metadataScope/                          mdb:MD_MetadataScope/mdb:resourceScope/                          mcc:MD_ScopeCode/@codeListValue = 'dataset' or                           mdb:metadataScope/                          mdb:MD_MetadataScope/mdb:resourceScope/                          mcc:MD_ScopeCode/@codeListValue = 'series']/                          mdb:identificationInfo/che:CHE_MD_DataIdentification">

      <!-- The topic category is the enumeration value and
      not the human readable one. -->

      <sch:let name="topics"
               value="mri:topicCategory/mri:MD_TopicCategoryCode"/>

      <sch:let name="hasTopics" value="count($topics) &gt; 0"/>


      <sch:assert test="$hasTopics"
                  diagnostics="rule.mri.topicategoryfordsandseries-failure-en                       rule.mri.topicategoryfordsandseries-failure-fr rule.mri.topicategoryfordsandseries-failure-de"/>


      <sch:report test="$hasTopics"
                  diagnostics="rule.mri.topicategoryfordsandseries-success-en                       rule.mri.topicategoryfordsandseries-success-fr rule.mri.topicategoryfordsandseries-success-de"/>


    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mri.citationdate-mandatory-failure-en" xml:lang="en">
      Citation date is mandatory when resource scope is 'dataset', 'series' or 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.citationdate-mandatory-failure-fr" xml:lang="fr">
      La date de citation est obligatoire quand la portée de la ressource est 'dataset', 'series' ou 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.citationdate-mandatory-failure-de" xml:lang="de">
      Das Referenzinformationendatum ist obligatorisch wenn der Ressourcenbereich 'dataset', 'series' oder 'service' ist.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.citationdate-mandatory-success-en" xml:lang="en">
      Number of citation dates defined: <sch:value-of select="count($citationDates)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.citationdate-mandatory-success-fr" xml:lang="fr">
      Nombre de dates de citation définies : <sch:value-of select="count($citationDates)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.citationdate-mandatory-success-de" xml:lang="de">
      Anzahl der definierten Referenzinformationendaten: <sch:value-of select="count($citationDates)"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mri.citationdate-mandatory">

    <sch:title xml:lang="en">Citation date mandatory for dataset, series and service</sch:title>

    <sch:title xml:lang="fr">Date de citation obligatoire pour les jeux de données, séries et services</sch:title>

    <sch:title xml:lang="de">Referenzinformationendatum obligatorisch für Datensätze, Serien und Dienste</sch:title>

    <sch:p xml:lang="en">When metadata scope resourceScope is 'dataset', 'series' or 'service',
      the citation date in dataIdentification section MUST be specified.
    </sch:p>

    <sch:p xml:lang="fr">Quand la portée des métadonnées (resourceScope) est 'dataset', 'series' ou 'service',
      la date de citation dans la section dataIdentification DOIT être spécifiée.
    </sch:p>

    <sch:p xml:lang="de">Wenn der Ressourcenbereich der Metadaten (resourceScope) 'dataset', 'series' oder 'service' ist,
      muss das Referenzinformationendatum im Abschnitt dataIdentification angegeben werden.
    </sch:p>

    <sch:rule context="che:CHE_MD_Metadata[
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']
      /mdb:identificationInfo/*[name() = 'che:CHE_MD_DataIdentification' or name() = 'srv:SV_ServiceIdentification']">

      <sch:let name="citationDates"
               value="mri:citation/cit:CI_Citation/cit:date/cit:CI_Date/cit:date[normalize-space(gco:DateTime) != '' or normalize-space(gco:Date) != '']"/>

      <sch:let name="hasCitationDate" value="count($citationDates) &gt; 0"/>

      <sch:assert test="$hasCitationDate"
                  diagnostics="rule.mri.citationdate-mandatory-failure-en
                              rule.mri.citationdate-mandatory-failure-fr rule.mri.citationdate-mandatory-failure-de"/>

      <sch:report test="$hasCitationDate"
                  diagnostics="rule.mri.citationdate-mandatory-success-en
                              rule.mri.citationdate-mandatory-success-fr rule.mri.citationdate-mandatory-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mri.servicetaxonomy-failure-en" xml:lang="en">A
      service metadata SHALL refer to the service
      taxonomy defined in ISO19119 defining one or more value in the
      keyword section.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.servicetaxonomy-failure-fr" xml:lang="fr">Une
      métadonnée de service DEVRAIT référencer
      un type de service tel que défini dans l'ISO19119 dans la
      section mot clé.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.servicetaxonomy-failure-de" xml:lang="de">Eine
      Dienstmetadaten SOLLTE einen Diensttyp gemäss ISO19119
      im Schlüsselwortabschnitt referenzieren.
    </sch:diagnostic>


    <sch:diagnostic id="rule.mri.servicetaxonomy-success-en" xml:lang="en">
      Number of service taxonomy specified:
      <sch:value-of select="count($serviceTaxonomies)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.servicetaxonomy-success-fr" xml:lang="fr">
      Nombre de types de service :
      <sch:value-of select="count($serviceTaxonomies)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.servicetaxonomy-success-de" xml:lang="de">
      Anzahl der Diensttypen:
      <sch:value-of select="count($serviceTaxonomies)"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mri.descriptivekeywords-mandatory-failure-en" xml:lang="en">
      Descriptive keywords are mandatory when resource scope is 'dataset', 'series' or 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.descriptivekeywords-mandatory-failure-fr" xml:lang="fr">
      La description d'un 'dataset', d'une 'series' ou d'un 'service' doit comprendre au moins un mot-clé (descriptive keyword).
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.descriptivekeywords-mandatory-failure-de" xml:lang="de">
      Die Beschreibung eines 'dataset', einer 'series' oder eines 'service' muss mindestens ein deskriptives Schlüsselwort (descriptive keyword) enthalten.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.descriptivekeywords-mandatory-success-en" xml:lang="en">
      Number of descriptive keywords groups defined: <sch:value-of select="count($descriptiveKeywords)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.descriptivekeywords-mandatory-success-fr" xml:lang="fr">
      Nombre de groupes de mots-clés descriptifs définis : <sch:value-of select="count($descriptiveKeywords)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.descriptivekeywords-mandatory-success-de" xml:lang="de">
      Anzahl der definierten deskriptiven Schlüsselwortgruppen: <sch:value-of select="count($descriptiveKeywords)"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mri.descriptivekeywords-mandatory">

    <sch:title xml:lang="en">Descriptive keyword mandatory for dataset, series and service</sch:title>

    <sch:title xml:lang="fr">Mot-clé descriptif obligatoire pour les jeux de données, séries et services</sch:title>

    <sch:title xml:lang="de">Deskriptives Schlüsselwort obligatorisch für Datensätze, Serien und Dienste</sch:title>

    <sch:p xml:lang="en">When metadata scope resourceScope is 'dataset', 'series' or 'service',
      descriptive keywords MUST be specified.
    </sch:p>

    <sch:p xml:lang="fr">Quand la portée des métadonnées (resourceScope) est 'dataset', 'series' ou 'service',
      un mot-clé descriptif DOIT être spécifié.
    </sch:p>

    <sch:rule context="che:CHE_MD_Metadata[
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']
      /mdb:identificationInfo/*[name() = 'che:CHE_MD_DataIdentification' or name() = 'srv:SV_ServiceIdentification']">

      <sch:let name="descriptiveKeywords"
               value="mri:descriptiveKeywords/mri:MD_Keywords[
                 count(mri:keyword[
                   normalize-space(gco:CharacterString) != '' or
                   count(lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[normalize-space(.) != '']) > 0
                 ]) > 0]"/>

      <sch:let name="hasDescriptiveKeywords" value="count($descriptiveKeywords) &gt; 0"/>

      <sch:assert test="$hasDescriptiveKeywords"
                  diagnostics="rule.mri.descriptivekeywords-mandatory-failure-en
                              rule.mri.descriptivekeywords-mandatory-failure-fr rule.mri.descriptivekeywords-mandatory-failure-de"/>

      <sch:report test="$hasDescriptiveKeywords"
                  diagnostics="rule.mri.descriptivekeywords-mandatory-success-en
                              rule.mri.descriptivekeywords-mandatory-success-fr rule.mri.descriptivekeywords-mandatory-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mri.pointofcontact-mandatory-failure-en" xml:lang="en">
      Point of contact is mandatory when resource scope is 'dataset', 'series' or 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.pointofcontact-mandatory-failure-fr" xml:lang="fr">
      Le point de contact est obligatoire quand la portée de la ressource est 'dataset', 'series' ou 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.pointofcontact-mandatory-failure-de" xml:lang="de">
      Der Kontaktpunkt ist obligatorisch wenn der Ressourcenbereich 'dataset', 'series' oder 'service' ist.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.pointofcontact-mandatory-success-en" xml:lang="en">
      Number of point of contact defined: <sch:value-of select="count($pointOfContact)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.pointofcontact-mandatory-success-fr" xml:lang="fr">
      Nombre de points de contact définis : <sch:value-of select="count($pointOfContact)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.pointofcontact-mandatory-success-de" xml:lang="de">
      Anzahl der definierten Kontaktpunkte: <sch:value-of select="count($pointOfContact)"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mri.pointofcontact-mandatory">

    <sch:title xml:lang="en">Point of contact mandatory for dataset, series and service</sch:title>

    <sch:title xml:lang="fr">Point de contact obligatoire pour les jeux de données, séries et services</sch:title>

    <sch:title xml:lang="de">Kontaktpunkt obligatorisch für Datensätze, Serien und Dienste</sch:title>

    <sch:p xml:lang="en">When metadata scope resourceScope is 'dataset', 'series' or 'service',
      point of contact MUST be specified.
    </sch:p>

    <sch:p xml:lang="fr">Quand la portée des métadonnées (resourceScope) est 'dataset', 'series' ou 'service',
      le point de contact DOIT être spécifié.
    </sch:p>

    <sch:rule context="che:CHE_MD_Metadata[
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']
      /mdb:identificationInfo/*[name() = 'che:CHE_MD_DataIdentification' or name() = 'srv:SV_ServiceIdentification']">

      <sch:let name="pointOfContact"
               value="mri:pointOfContact[*]"/>

      <sch:let name="hasPointOfContact" value="count($pointOfContact) &gt; 0"/>

      <sch:assert test="$hasPointOfContact"
                  diagnostics="rule.mri.pointofcontact-mandatory-failure-en
                              rule.mri.pointofcontact-mandatory-failure-fr rule.mri.pointofcontact-mandatory-failure-de"/>

      <sch:report test="$hasPointOfContact"
                  diagnostics="rule.mri.pointofcontact-mandatory-success-en
                              rule.mri.pointofcontact-mandatory-success-fr rule.mri.pointofcontact-mandatory-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:diagnostics>

    <sch:diagnostic id="rule.mri.resourcemaintenance-mandatory-failure-en" xml:lang="en">
      Resource maintenance is mandatory when resource scope is 'dataset', 'series' or 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.resourcemaintenance-mandatory-failure-fr" xml:lang="fr">
      La maintenance de la ressource est obligatoire quand la portée de la ressource est 'dataset', 'series' ou 'service'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.resourcemaintenance-mandatory-failure-de" xml:lang="de">
      Die Ressourcenwartung ist obligatorisch wenn der Ressourcenbereich 'dataset', 'series' oder 'service' ist.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.resourcemaintenance-mandatory-success-en" xml:lang="en">
      Number of resource maintenance defined: <sch:value-of select="count($resourceMaintenance)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.resourcemaintenance-mandatory-success-fr" xml:lang="fr">
      Nombre de maintenances de ressource définies : <sch:value-of select="count($resourceMaintenance)"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.resourcemaintenance-mandatory-success-de" xml:lang="de">
      Anzahl der definierten Ressourcenwartungen: <sch:value-of select="count($resourceMaintenance)"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  <sch:pattern id="rule.mri.resourcemaintenance-mandatory">

    <sch:title xml:lang="en">Resource maintenance mandatory for dataset, series and service</sch:title>

    <sch:title xml:lang="fr">Maintenance de la ressource obligatoire pour les jeux de données, séries et services</sch:title>

    <sch:title xml:lang="de">Ressourcenwartung obligatorisch für Datensätze, Serien und Dienste</sch:title>

    <sch:p xml:lang="en">When metadata scope resourceScope is 'dataset', 'series' or 'service',
      resource maintenance MUST be specified.
    </sch:p>

    <sch:p xml:lang="fr">Quand la portée des métadonnées (resourceScope) est 'dataset', 'series' ou 'service',
      la maintenance de la ressource DOIT être spécifiée.
    </sch:p>

    <sch:rule context="che:CHE_MD_Metadata[
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'dataset' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'service']
      /mdb:identificationInfo/*[name() = 'che:CHE_MD_DataIdentification' or name() = 'srv:SV_ServiceIdentification']">

      <sch:let name="resourceMaintenance"
               value="mri:resourceMaintenance[*]"/>

      <sch:let name="hasResourceMaintenance" value="count($resourceMaintenance) &gt; 0"/>

      <sch:assert test="$hasResourceMaintenance"
                  diagnostics="rule.mri.resourcemaintenance-mandatory-failure-en
                              rule.mri.resourcemaintenance-mandatory-failure-fr rule.mri.resourcemaintenance-mandatory-failure-de"/>

      <sch:report test="$hasResourceMaintenance"
                  diagnostics="rule.mri.resourcemaintenance-mandatory-success-en
                              rule.mri.resourcemaintenance-mandatory-success-fr rule.mri.resourcemaintenance-mandatory-success-de"/>

    </sch:rule>

  </sch:pattern>
  <sch:pattern id="rule.srv.servicetaxonomy">

    <sch:title xml:lang="en">Service taxonomy</sch:title>

    <sch:title xml:lang="fr">Taxonomie des services</sch:title>
    <sch:title xml:lang="de">Diensttaxonomie</sch:title>

    <!--
    QUESTION-TODO: Is this the list to check against ?
      The list is not multilingual ?
    -->

    <sch:rule context="//srv:SV_ServiceIdentification">

      <sch:let name="listOfTaxonomy"
               value="'Geographic human interaction services,Catalogue viewer,Geographic viewer,Geographic spreadsheet viewer,Service editor,Chain definition editor,Workflow enactment manager,Geographic feature editor,Geographic symbol editor,Feature generalisation editor,Geographic data-structure viewer,Geographic model/information management service,Feature access service,Map access service,Coverage access service,Sensor description service,Product access service,Feature type service,Catalogue service,Registry Service,Gazetteer service,Order handling service,Standing order service,Geographic workflow/task management services,Chain definition service,Workflow enactment service,Subscription service,Geographic processing services – spatial,Coordinate conversion service,Coordinate transformation service,Coverage/vector conversion service,Image coordinate conversion service,Rectification service,Orthorectification service,Sensor geometry model adjustment service,Image geometry model conversion service,Subsetting service,Sampling service,Tiling change service,Dimension measurement service,Feature manipulation services,Feature matching service,Feature generalisation service,Route determination service,Positioning service,Proximity analysis service,Geographic processing services – thematic,Geoparameter calculation service,Thematic classification service,Feature generalisation service,Subsetting service,Spatial counting service,Change detection service,Geographic information extraction services,Image processing service,Reduced resolution generation service,Image Manipulation Services,Image understanding services,Image synthesis services,Multiband image manipulation,Object detection service,Geoparsing service,Geocoding service,Geographic processing services – temporal,Temporal reference system transformation service,Subsetting service,Sampling service,Temporal proximity analysis service,Geographic processing services – metadata,Statistical calculation service,Geographic annotation services,Geographic communication services,Encoding service,Transfer service,Geographic compression service,Geographic format conversion service,Messaging service,Remote file and executable management'"/>

      <sch:let name="serviceTaxonomies"
               value="mri:descriptiveKeywords/mri:MD_Keywords/mri:keyword[         geonet:contains-any-of(lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#EN']/text(), tokenize($listOfTaxonomy, ','))]"/>

      <sch:let name="hasAtLeastOneTaxonomy"
               value="count($serviceTaxonomies) &gt; 0"/>

      <!-- <sch:assert test="$hasAtLeastOneTaxonomy"
        diagnostics="rule.mri.servicetaxonomy-failure-en
                     rule.mri.servicetaxonomy-failure-fr rule.mri.servicetaxonomy-failure-de"/> -->


      <sch:report test="$hasAtLeastOneTaxonomy"
                  diagnostics="rule.mri.servicetaxonomy-success-en                       rule.mri.servicetaxonomy-success-fr rule.mri.servicetaxonomy-success-de"/>

    </sch:rule>

  </sch:pattern>
</sch:schema>
