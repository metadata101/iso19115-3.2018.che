<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Basic Geodata - AAP mandatory rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">Basic Geodata - AAP règles obligatoires</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="de">Basic Geodata - AAP obligatorische Regeln</sch:title>
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
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-failure-en" xml:lang="en">
      When Basic Geodata is activated (basicGeodata='true'), Basic Geodata Information (basicGeodataInformation) must be present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-failure-fr" xml:lang="fr">
      Lorsque Géodonnées de base est activé (basicGeodata='true'), Informations sur les Géodonnées de base (basicGeodataInformation) doit être présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-failure-de" xml:lang="de">
      Wenn Geobasisdaten aktiviert ist (basicGeodata='true'), muss Informationen zu Geobasisdaten (basicGeodataInformation) vorhanden sein.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-success-en" xml:lang="en">
      Basic Geodata Information (basicGeodataInformation) is present when Basic Geodata is activated (basicGeodata='true').
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-success-fr" xml:lang="fr">
      Informations sur les Géodonnées de base (basicGeodataInformation) est présent lorsque Géodonnées de base est activé (basicGeodata='true').
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-success-de" xml:lang="de">
      Informationen zu Geobasisdaten (basicGeodataInformation) ist vorhanden, wenn Geobasisdaten aktiviert ist (basicGeodata='true').
    </sch:diagnostic>

    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-failure-en" xml:lang="en">
      When Basic Geodata is activated (basicGeodata='true'), Basic Geodata ID (basicGeodataID) must be present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-failure-fr" xml:lang="fr">
      Lorsque Géodonnées de base (basicGeodata='true') est activé, Identifiant Géodonnées de base (basicGeodataID) doit être présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-failure-de" xml:lang="de">
      Wenn Geobasisdaten aktiviert ist (basicGeodata='true'), muss Identifikator des Geobasisdatensatzes (basicGeodataID) vorhanden sein.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-success-en" xml:lang="en">
      Basic Geodata ID (basicGeodataID) is present when Basic Geodata is activated (basicGeodata='true').
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-success-fr" xml:lang="fr">
      Identifiant Géodonnées de base (basicGeodataID) est présent lorsque Géodonnées de base est activé (basicGeodata='true').
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-success-de" xml:lang="de">
      Identifikator des Geobasisdatensatzes (basicGeodataID) ist vorhanden, wenn Geobasisdaten aktiviert ist (basicGeodata='true').
    </sch:diagnostic>

    <sch:diagnostic id="rule.che.topic-subtopic-consistency-failure-en" xml:lang="en">
      Inconsistent Topic category (topicCategory) and Subtopic Category (subTopicCategory): each Subtopic Category (che:CHE_MD_SubTopicCategoryCode) must start with the selected ISO topicCategory (prefix before '_').
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.topic-subtopic-consistency-failure-fr" xml:lang="fr">
      Incohérence entre la Catégorie de thème (topicCategory) et la Catégorie de sous-thème (subTopicCategory) : chaque Catégorie de sous-thème (che:CHE_MD_SubTopicCategoryCode) doit commencer par la Catégorie de thème (topicCategory) sélectionnée (préfixe avant « _ »).
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.topic-subtopic-consistency-failure-de" xml:lang="de">
      Inkonsistenz zwischen Thematik (topicCategory) und Thematische Unterkategorien (subTopicCategory): jeder Thematische Unterkategorien (che:CHE_MD_SubTopicCategoryCode) muss mit der ausgewählten ISO-Themenkategorie (Präfix vor '_') beginnen.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.topic-subtopic-consistency-success-en" xml:lang="en">
      Topic categories (topicCategory) and sub topic categories (subTopicCategory) are consistent according to eCH-0166.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.topic-subtopic-consistency-success-fr" xml:lang="fr">
      Les catégories de thème (topicCategory) et catégories de sous-thème (subTopicCategory) sont cohérentes conformément à eCH-0166.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.topic-subtopic-consistency-success-de" xml:lang="de">
      Themenkategorien (topicCategory) und Thematische Unterkategorien (subTopicCategory) sind gemäss eCH-0166 konsistent.
    </sch:diagnostic>

  </sch:diagnostics>

  <sch:pattern id="rule.basicgeodata.basicgeodatainformation-mandatory">
    <sch:title xml:lang="en">Basic Geodata activated (basicGeodata = ‘true’) implies Basic Geodata Information (basicGeodataInformation) is mandatory</sch:title>
    <sch:title xml:lang="fr">Géodonnées de base activées (basicGeodata = ‘true’) implique que Informations sur les Géodonnées (basicGeodataInformation) est obligatoire</sch:title>
    <sch:title xml:lang="de">Geobasisdaten aktiviert (basicGeodata = ‘true’) impliziert, dass Informationen zu Geobasisdaten (basicGeodataInformation) obligatorisch sind</sch:title>
    <sch:rule context="//che:CHE_MD_Metadata/mdb:identificationInfo/che:CHE_MD_DataIdentification[che:basicGeodata/gco:Boolean = 'true']">
      <sch:assert test="che:basicGeodataInformation"
                  diagnostics="rule.basicgeodata.basicgeodatainformation-mandatory-failure-en rule.basicgeodata.basicgeodatainformation-mandatory-failure-fr rule.basicgeodata.basicgeodatainformation-mandatory-failure-de"/>
      <sch:report test="che:basicGeodataInformation"
                 diagnostics="rule.basicgeodata.basicgeodatainformation-mandatory-success-en rule.basicgeodata.basicgeodatainformation-mandatory-success-fr rule.basicgeodata.basicgeodatainformation-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="rule.basicgeodata.basicgeodataid-mandatory">
    <sch:title xml:lang="en">Basic Geodata activated (basicGeodata = ‘true’) implies Basic Geodata ID (basicGeodataID) is mandatory</sch:title>
    <sch:title xml:lang="fr">Géodonnées de base activées (basicGeodata = ‘true’) implique que l'identifiant Géodonnées de base (basicGeodataID) est obligatoire</sch:title>
    <sch:title xml:lang="de">Geobasisdaten aktiviert (basicGeodata = ‘true’) impliziert, dass Identifikator des Geobasisdatensatzes (basicGeodataID) obligatorisch ist</sch:title>
    <sch:rule context="//che:CHE_MD_Metadata/mdb:identificationInfo/che:CHE_MD_DataIdentification[che:basicGeodata/gco:Boolean = 'true']">
      <sch:assert test="some $id in che:basicGeodataInformation/che:CHE_MD_BasicGeodataInformation/che:basicGeodataID/gco:CharacterString satisfies normalize-space($id) != ''"
                  diagnostics="rule.basicgeodata.basicgeodataid-mandatory-failure-en rule.basicgeodata.basicgeodataid-mandatory-failure-fr rule.basicgeodata.basicgeodataid-mandatory-failure-de"/>
      <sch:report test="some $id in che:basicGeodataInformation/che:CHE_MD_BasicGeodataInformation/che:basicGeodataID/gco:CharacterString satisfies normalize-space($id) != ''"
                 diagnostics="rule.basicgeodata.basicgeodataid-mandatory-success-en rule.basicgeodata.basicgeodataid-mandatory-success-fr rule.basicgeodata.basicgeodataid-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>

    <sch:pattern id="rule.che.topic-subtopic-consistency">
      <sch:title xml:lang="en">Ensure consistency between Topic categories (topicCategory) and Subtopic categories (subTopicCategory) (eCH-0166)</sch:title>
      <sch:title xml:lang="fr">Assurer la cohérence entre Les catégories de thème (topicCategory) et les catégories de sous-thème (subTopicCategory) (eCH-0166)</sch:title>
      <sch:title xml:lang="de">Sicherstellen der Konsistenz zwischen Themenkategorien (topicCategory) und Thematische Unterkategorien (subTopicCategory) (eCH-0166)</sch:title>
      <sch:rule context="//che:CHE_MD_DataIdentification">
        <sch:let name="topicCodes" value="mri:topicCategory/mri:MD_TopicCategoryCode/text()"/>
        <sch:let name="invalidSubCount"
                 value="count(che:subTopicCategory/che:CHE_MD_SubTopicCategoryCode[
                           not(substring-before(@codeListValue,'_') = $topicCodes)])"/>
        <sch:assert test="$invalidSubCount = 0"
                    diagnostics="rule.che.topic-subtopic-consistency-failure-en rule.che.topic-subtopic-consistency-failure-fr rule.che.topic-subtopic-consistency-failure-de"/>
        <sch:report test="count(che:subTopicCategory/che:CHE_MD_SubTopicCategoryCode) &gt; 0 and $invalidSubCount = 0"
                    diagnostics="rule.che.topic-subtopic-consistency-success-en rule.che.topic-subtopic-consistency-success-fr rule.che.topic-subtopic-consistency-success-de"/>
      </sch:rule>
    </sch:pattern>
</sch:schema>
