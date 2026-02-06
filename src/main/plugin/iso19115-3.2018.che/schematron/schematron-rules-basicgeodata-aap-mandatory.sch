<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Basic Geodata - AAP mandatory rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">Basic Geodata - AAP règles obligatoires</sch:title>
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
      When basicGeodata is 'true', basicGeodataInformation must be present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-failure-fr" xml:lang="fr">
      Lorsque basicGeodata vaut 'true', basicGeodataInformation doit être présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-success-en" xml:lang="en">
      basicGeodataInformation is present when basicGeodata is 'true'.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodatainformation-mandatory-success-fr" xml:lang="fr">
      basicGeodataInformation est présent lorsque basicGeodata vaut 'true'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-failure-en" xml:lang="en">
      When basicGeodata is 'true', basicGeodataID must be present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-failure-fr" xml:lang="fr">
      Lorsque basicGeodata vaut 'true', basicGeodataID doit être présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-success-en" xml:lang="en">
      basicGeodataID is present when basicGeodata is 'true'.
    </sch:diagnostic>
    <sch:diagnostic id="rule.basicgeodata.basicgeodataid-mandatory-success-fr" xml:lang="fr">
      basicGeodataID est présent lorsque basicGeodata vaut 'true'.
    </sch:diagnostic>

    <sch:diagnostic id="rule.che.topic-subtopic-consistency-failure-en" xml:lang="en">
      Inconsistent topic and subTopicCategory: each che:CHE_MD_SubTopicCategoryCode must start with the selected ISO topicCategory (prefix before '_').
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.topic-subtopic-consistency-failure-fr" xml:lang="fr">
      Incohérence entre la catégorie et la sous-catégorie : chaque che:CHE_MD_SubTopicCategoryCode doit commencer par la topicCategory sélectionnée (préfixe avant « _ »).
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.topic-subtopic-consistency-success-en" xml:lang="en">
      Topic categories and sub topic categories are consistent according to eCH-0166.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.topic-subtopic-consistency-success-fr" xml:lang="fr">
      Les catégories et sous-catégories sont cohérentes conformément à eCH-0166.
    </sch:diagnostic>

  </sch:diagnostics>

  <sch:pattern id="rule.basicgeodata.basicgeodatainformation-mandatory">
    <sch:title xml:lang="en">{basicGeodata = ‘true’ implies basicGeodataInformation is mandatory}</sch:title>
    <sch:title xml:lang="fr">{basicGeodata = ‘true’ implique que basicGeodataInformation est obligatoire}</sch:title>

    <sch:rule context="//che:CHE_MD_Metadata/mdb:identificationInfo/che:CHE_MD_DataIdentification[che:basicGeodata/gco:Boolean = 'true']">
      <sch:assert test="che:basicGeodataInformation"
                  diagnostics="rule.basicgeodata.basicgeodatainformation-mandatory-failure-en rule.basicgeodata.basicgeodatainformation-mandatory-failure-fr"/>
      <sch:report test="che:basicGeodataInformation"
                 diagnostics="rule.basicgeodata.basicgeodatainformation-mandatory-success-en rule.basicgeodata.basicgeodatainformation-mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="rule.basicgeodata.basicgeodataid-mandatory">
    <sch:title xml:lang="en">{basicGeodata = ‘true’ implies basicGeodataID is mandatory}</sch:title>
    <sch:title xml:lang="fr">{basicGeodata = ‘true’ implique que basicGeodataID est obligatoire}</sch:title>
    <sch:rule context="//che:CHE_MD_Metadata/mdb:identificationInfo/che:CHE_MD_DataIdentification[che:basicGeodata/gco:Boolean = 'true']">
      <sch:assert test="che:basicGeodataInformation/che:CHE_MD_BasicGeodataInformation/che:basicGeodataID/gco:CharacterString and normalize-space(che:basicGeodataInformation/che:CHE_MD_BasicGeodataInformation/che:basicGeodataID/gco:CharacterString) != ''"
                  diagnostics="rule.basicgeodata.basicgeodataid-mandatory-failure-en rule.basicgeodata.basicgeodataid-mandatory-failure-fr"/>
      <sch:report test="che:basicGeodataInformation/che:CHE_MD_BasicGeodataInformation/che:basicGeodataID/gco:CharacterString and normalize-space(che:basicGeodataInformation/che:CHE_MD_BasicGeodataInformation/che:basicGeodataID/gco:CharacterString) != ''"
                 diagnostics="rule.basicgeodata.basicgeodataid-mandatory-success-en rule.basicgeodata.basicgeodataid-mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

    <sch:pattern id="rule.che.topic-subtopic-consistency">
      <sch:title xml:lang="en">Ensure consistency between topicCategory and subTopicCategory (eCH-0166)</sch:title>
      <sch:title xml:lang="fr">Assurer la cohérence entre topicCategory et subTopicCategory (eCH-0166)</sch:title>
      <sch:rule context="//che:CHE_MD_DataIdentification">
        <sch:let name="topicCodes" value="mri:topicCategory/mri:MD_TopicCategoryCode/text()"/>
        <sch:let name="invalidSubCount"
                 value="count(che:subTopicCategory/che:CHE_MD_SubTopicCategoryCode[
                           not(substring-before(@codeListValue,'_') = $topicCodes)])"/>
        <sch:assert test="$invalidSubCount = 0"
                    diagnostics="rule.che.topic-subtopic-consistency-failure-en rule.che.topic-subtopic-consistency-failure-fr"/>
        <sch:report test="count(che:subTopicCategory/che:CHE_MD_SubTopicCategoryCode) &gt; 0 and $invalidSubCount = 0"
                    diagnostics="rule.che.topic-subtopic-consistency-success-en rule.che.topic-subtopic-consistency-success-fr"/>
      </sch:rule>
    </sch:pattern>
</sch:schema>
