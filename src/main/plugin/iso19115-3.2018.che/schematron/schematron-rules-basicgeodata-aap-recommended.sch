<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Basic Geodata - AAP recommended rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">Basic Geodata - AAP règles recommandées</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="de">Basic Geodata - AAP empfohlene Regeln</sch:title>
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
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-failure-en" xml:lang="en">
      When Appraisal AAP (CHE_MD_Appraisal_AAP) is used, Duration of Conservation (durationOfConservation) is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-failure-fr" xml:lang="fr">
      Lorsque Évaluation AAP (CHE_MD_Appraisal_AAP) est utilisé, Durée de conservation (durationOfConservation) est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-failure-de" xml:lang="de">
      Wenn Bewertung AAP (CHE_MD_Appraisal_AAP) verwendet wird, ist Aufbewahrungsdauer NV in Jahren (durationOfConservation) obligatorisch.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-success-en" xml:lang="en">
      Duration of Conservation (durationOfConservation) is present in Appraisal AAP (CHE_MD_Appraisal_AAP).
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-success-fr" xml:lang="fr">
      Durée de conservation (durationOfConservation) est présente dans Évaluation AAP (CHE_MD_Appraisal_AAP).
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-success-de" xml:lang="de">
      Aufbewahrungsdauer NV in Jahren (durationOfConservation) ist in Bewertung AAP (CHE_MD_Appraisal_AAP) vorhanden.
    </sch:diagnostic>

    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-failure-en" xml:lang="en">
      When Appraisal AAP (CHE_MD_Appraisal_AAP) is used, Appraisal of Archival Value (appraisalOfArchivalValue) is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-failure-fr" xml:lang="fr">
      Lorsque Évaluation AAP (CHE_MD_Appraisal_AAP) est utilisé, Évaluation de la valeur archivistique (appraisalOfArchivalValue) est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-failure-de" xml:lang="de">
      Wenn Bewertung AAP (CHE_MD_Appraisal_AAP) verwendet wird, ist Bewertung Archivwürdigkeit (appraisalOfArchivalValue) obligatorisch.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-success-en" xml:lang="en">
      Appraisal of Archival Value (appraisalOfArchivalValue) is present in Appraisal AAP (CHE_MD_Appraisal_AAP).
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-success-fr" xml:lang="fr">
      Évaluation de la valeur archivistique (appraisalOfArchivalValue) est présente dans Évaluation AAP (CHE_MD_Appraisal_AAP).
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-success-de" xml:lang="de">
      Bewertung Archivwürdigkeit (appraisalOfArchivalValue) ist in Bewertung AAP (CHE_MD_Appraisal_AAP) vorhanden.
    </sch:diagnostic>

  </sch:diagnostics>

  <sch:pattern id="rule.che.appraisal-aap-duration-mandatory">
    <sch:title xml:lang="en">{If Appraisal AAP (CHE_MD_Appraisal_AAP) is used then Duration of Conservation (CHE_MD_Appraisal_AAP.durationOfConservation) is mandatory}</sch:title>
    <sch:title xml:lang="fr">{Si Évaluation AAP (CHE_MD_Appraisal_AAP) est utilisé alors Durée de conservation (CHE_MD_Appraisal_AAP.durationOfConservation) est obligatoire}</sch:title>
    <sch:title xml:lang="de">{Wenn Bewertung AAP (CHE_MD_Appraisal_AAP) verwendet wird, ist Aufbewahrungsdauer NV in Jahren (CHE_MD_Appraisal_AAP.durationOfConservation) obligatorisch}</sch:title>
    <sch:rule context="//che:CHE_MD_Appraisal_AAP">
      <sch:assert test="che:durationOfConservation/gco:Integer and normalize-space(che:durationOfConservation/gco:Integer) != ''"
                  diagnostics="rule.che.appraisal-aap-duration-mandatory-failure-en rule.che.appraisal-aap-duration-mandatory-failure-fr rule.che.appraisal-aap-duration-mandatory-failure-de"/>
      <sch:report test="che:durationOfConservation/gco:Integer and normalize-space(che:durationOfConservation/gco:Integer) != ''"
                  diagnostics="rule.che.appraisal-aap-duration-mandatory-success-en rule.che.appraisal-aap-duration-mandatory-success-fr rule.che.appraisal-aap-duration-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="rule.che.appraisal-aap-archival-value-mandatory">
    <sch:title xml:lang="en">{If Appraisal AAP (CHE_MD_Appraisal_AAP) is used then Appraisal of Archival Value (CHE_MD_Appraisal_AAP.appraisalOfArchivalValue) is mandatory}</sch:title>
    <sch:title xml:lang="fr">{Si Évaluation AAP (CHE_MD_Appraisal_AAP) est utilisé alors Évaluation de la valeur archivistique (CHE_MD_Appraisal_AAP.appraisalOfArchivalValue) est obligatoire}</sch:title>
    <sch:title xml:lang="de">{Wenn Bewertung AAP (CHE_MD_Appraisal_AAP) verwendet wird, ist Bewertung Archivwürdigkeit (CHE_MD_Appraisal_AAP.appraisalOfArchivalValue) obligatorisch}</sch:title>
    <sch:rule context="//che:CHE_MD_Appraisal_AAP">
      <sch:assert test="che:appraisalOfArchivalValue/che:CHE_AppraisalOfArchivalValueCode/@codeListValue and normalize-space(che:appraisalOfArchivalValue/che:CHE_AppraisalOfArchivalValueCode/@codeListValue) != ''"
                  diagnostics="rule.che.appraisal-aap-archival-value-mandatory-failure-en rule.che.appraisal-aap-archival-value-mandatory-failure-fr rule.che.appraisal-aap-archival-value-mandatory-failure-de"/>
      <sch:report test="che:appraisalOfArchivalValue/che:CHE_AppraisalOfArchivalValueCode/@codeListValue and normalize-space(che:appraisalOfArchivalValue/che:CHE_AppraisalOfArchivalValueCode/@codeListValue) != ''"
                  diagnostics="rule.che.appraisal-aap-archival-value-mandatory-success-en rule.che.appraisal-aap-archival-value-mandatory-success-fr rule.che.appraisal-aap-archival-value-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>

</sch:schema>
