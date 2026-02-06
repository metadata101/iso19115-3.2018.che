<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Basic Geodata - AAP recommended rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">Basic Geodata - AAP règles recommandées</sch:title>
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
      When CHE_MD_Appraisal_AAP is used, durationOfConservation is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-failure-fr" xml:lang="fr">
      Lorsque CHE_MD_Appraisal_AAP est utilisé, durationOfConservation est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-success-en" xml:lang="en">
      durationOfConservation is present in CHE_MD_Appraisal_AAP.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-duration-mandatory-success-fr" xml:lang="fr">
      durationOfConservation est présent dans CHE_MD_Appraisal_AAP.
    </sch:diagnostic>

    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-failure-en" xml:lang="en">
      When CHE_MD_Appraisal_AAP is used, appraisalOfArchivalValue is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-failure-fr" xml:lang="fr">
      Lorsque CHE_MD_Appraisal_AAP est utilisé, appraisalOfArchivalValue est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-success-en" xml:lang="en">
      appraisalOfArchivalValue is present in CHE_MD_Appraisal_AAP.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.appraisal-aap-archival-value-mandatory-success-fr" xml:lang="fr">
      appraisalOfArchivalValue est présent dans CHE_MD_Appraisal_AAP.
    </sch:diagnostic>

  </sch:diagnostics>

  <sch:pattern id="rule.che.appraisal-aap-duration-mandatory">
    <sch:title xml:lang="en">{If CHE_MD_Appraisal_AAP is used then CHE_MD_Appraisal_AAP.durationOfConservation is mandatory}</sch:title>
    <sch:title xml:lang="fr">{Si CHE_MD_Appraisal_AAP est utilisé alors CHE_MD_Appraisal_AAP.durationOfConservation est obligatoire}</sch:title>
    <sch:rule context="//che:CHE_MD_Appraisal_AAP">
      <sch:assert test="che:durationOfConservation/gco:Integer and normalize-space(che:durationOfConservation/gco:Integer) != ''"
                  diagnostics="rule.che.appraisal-aap-duration-mandatory-failure-en rule.che.appraisal-aap-duration-mandatory-failure-fr"/>
      <sch:report test="che:durationOfConservation/gco:Integer and normalize-space(che:durationOfConservation/gco:Integer) != ''"
                  diagnostics="rule.che.appraisal-aap-duration-mandatory-success-en rule.che.appraisal-aap-duration-mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="rule.che.appraisal-aap-archival-value-mandatory">
    <sch:title xml:lang="en">{If CHE_MD_Appraisal_AAP is used then CHE_MD_Appraisal_AAP.appraisalOfArchivalValue is mandatory}</sch:title>
    <sch:title xml:lang="fr">{Si CHE_MD_Appraisal_AAP est utilisé alors CHE_MD_Appraisal_AAP.appraisalOfArchivalValue est obligatoire}</sch:title>
    <sch:rule context="//che:CHE_MD_Appraisal_AAP">
      <sch:assert test="che:appraisalOfArchivalValue/che:CHE_AppraisalOfArchivalValueCode/@codeListValue and normalize-space(che:appraisalOfArchivalValue/che:CHE_AppraisalOfArchivalValueCode/@codeListValue) != ''"
                  diagnostics="rule.che.appraisal-aap-archival-value-mandatory-failure-en rule.che.appraisal-aap-archival-value-mandatory-failure-fr"/>
      <sch:report test="che:appraisalOfArchivalValue/che:CHE_AppraisalOfArchivalValueCode/@codeListValue and normalize-space(che:appraisalOfArchivalValue/che:CHE_AppraisalOfArchivalValueCode/@codeListValue) != ''"
                  diagnostics="rule.che.appraisal-aap-archival-value-mandatory-success-en rule.che.appraisal-aap-archival-value-mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

</sch:schema>
