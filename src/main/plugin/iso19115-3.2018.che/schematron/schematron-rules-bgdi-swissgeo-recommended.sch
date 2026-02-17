<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">bgdi-swissgeo recommended rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">bgdi-swissgeo règles recommandées</sch:title>
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
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-failure-en" xml:lang="en">
      If MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur', then a pointOfContact with role 'owner' is recommended.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-failure-fr" xml:lang="fr">
      Si MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur', alors un pointOfContact avec le rôle 'owner' est recommandé.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-success-en" xml:lang="en">
      A pointOfContact with role 'owner' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-success-fr" xml:lang="fr">
      Un pointOfContact avec le rôle 'owner' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-failure-en" xml:lang="en">
      If MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur', then mri:status/mcc:MD_ProgressCode is recommended.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-failure-fr" xml:lang="fr">
      Si MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur', alors mri:status/mcc:MD_ProgressCode est recommandé.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-success-en" xml:lang="en">
      mri:status/mcc:MD_ProgressCode is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-success-fr" xml:lang="fr">
      mri:status/mcc:MD_ProgressCode est présent.
    </sch:diagnostic>
  </sch:diagnostics>

  <sch:pattern id="rule.che.bgdi-keyword-poc-owner-recommended">
    <sch:title xml:lang="en">If MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur' then a pointOfContact with role 'owner' is recommended</sch:title>
    <sch:title xml:lang="fr">Si MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur' alors un pointOfContact avec le rôle 'owner' est recommandé</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:report test="mri:pointOfContact/cit:CI_Responsibility/cit:role/cit:CI_RoleCode[@codeListValue='owner']"
        diagnostics="rule.che.bgdi-keyword-poc-owner-recommended-success-en rule.che.bgdi-keyword-poc-owner-recommended-success-fr"/>
      <sch:assert test="mri:pointOfContact/cit:CI_Responsibility/cit:role/cit:CI_RoleCode[@codeListValue='owner']"
        diagnostics="rule.che.bgdi-keyword-poc-owner-recommended-failure-en rule.che.bgdi-keyword-poc-owner-recommended-failure-fr"/>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="rule.che.bgdi-keyword-status-recommended">
    <sch:title xml:lang="en">If MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur' then mri:status/mcc:MD_ProgressCode is recommended</sch:title>
    <sch:title xml:lang="fr">Si MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur' alors mri:status/mcc:MD_ProgressCode est recommandé</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:report test="mri:status/mcc:MD_ProgressCode and normalize-space(mri:status/mcc:MD_ProgressCode/@codeListValue) != ''"
        diagnostics="rule.che.bgdi-keyword-status-recommended-success-en rule.che.bgdi-keyword-status-recommended-success-fr"/>
      <sch:assert test="mri:status/mcc:MD_ProgressCode and normalize-space(mri:status/mcc:MD_ProgressCode/@codeListValue) != ''"
        diagnostics="rule.che.bgdi-keyword-status-recommended-failure-en rule.che.bgdi-keyword-status-recommended-failure-fr"/>
    </sch:rule>
  </sch:pattern>


</sch:schema>
