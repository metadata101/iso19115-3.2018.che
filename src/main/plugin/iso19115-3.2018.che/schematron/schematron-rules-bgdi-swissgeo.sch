<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">bgdi-swissgeo rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">règles bgdi-swissgeo</sch:title>
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
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-failure-en" xml:lang="en">
      If MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur', then CHE_MD_DataIdentification.citation.CI_Citation.title for locale '#DE' is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-failure-fr" xml:lang="fr">
      Si MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur', alors CHE_MD_DataIdentification.citation.CI_Citation.title pour la locale '#DE' est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-success-en" xml:lang="en">
      CHE_MD_DataIdentification.citation.CI_Citation.title for locale '#DE' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-success-fr" xml:lang="fr">
      CHE_MD_DataIdentification.citation.CI_Citation.title pour la locale '#DE' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-failure-en" xml:lang="en">
      If MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur', then CHE_MD_DataIdentification.citation.CI_Citation.title for locale '#FR' is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-failure-fr" xml:lang="fr">
      Si MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur', alors CHE_MD_DataIdentification.citation.CI_Citation.title pour la locale '#FR' est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-success-en" xml:lang="en">
      CHE_MD_DataIdentification.citation.CI_Citation.title for locale '#FR' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-success-fr" xml:lang="fr">
      CHE_MD_DataIdentification.citation.CI_Citation.title pour la locale '#FR' est présent.
    </sch:diagnostic>
  </sch:diagnostics>

  <sch:pattern id="rule.che.bgdi-keyword-title-de-mandatory">
    <sch:title xml:lang="en">If MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur' then CHE_MD_DataIdentification.citation.CI_Citation.title for locale '#DE' is mandatory</sch:title>
    <sch:title xml:lang="fr">Si MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur' alors CHE_MD_DataIdentification.citation.CI_Citation.title pour la locale '#DE' est obligatoire</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#DE' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-title-de-mandatory-failure-en rule.che.bgdi-keyword-title-de-mandatory-failure-fr"/>
      <sch:report test="mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#DE' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-title-de-mandatory-success-en rule.che.bgdi-keyword-title-de-mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="rule.che.bgdi-keyword-title-fr-mandatory">
    <sch:title xml:lang="en">If MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur' then CHE_MD_DataIdentification.citation.CI_Citation.title for locale '#FR' is mandatory</sch:title>
    <sch:title xml:lang="fr">Si MD_Keywords.keyword = 'BGDI Bundesgeodaten-Infrastruktur' alors CHE_MD_DataIdentification.citation.CI_Citation.title pour la locale '#FR' est obligatoire</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-title-fr-mandatory-failure-en rule.che.bgdi-keyword-title-fr-mandatory-failure-fr"/>
      <sch:report test="mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-title-fr-mandatory-success-en rule.che.bgdi-keyword-title-fr-mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>
</sch:schema>
