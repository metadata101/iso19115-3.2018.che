<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">bgdi-swissgeo mandatory rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">règles obligatoires bgdi-swissgeo</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="de">bgdi-swissgeo obligatorische Regeln</sch:title>
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
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Title (CHE_MD_DataIdentification.citation.CI_Citation.title) for locale '#DE' is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors Titre (CHE_MD_DataIdentification.citation.CI_Citation.title) pour la locale '#DE' est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-failure-de" xml:lang="de">
      Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', dann ist Titel (CHE_MD_DataIdentification.citation.CI_Citation.title) für die Locale '#DE' obligatorisch.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-success-en" xml:lang="en">
      Title (CHE_MD_DataIdentification.citation.CI_Citation.title) for locale '#DE' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-success-fr" xml:lang="fr">
      Titre (CHE_MD_DataIdentification.citation.CI_Citation.title) pour la locale '#DE' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-de-mandatory-success-de" xml:lang="de">
      Titel (CHE_MD_DataIdentification.citation.CI_Citation.title) für die Locale '#DE' ist vorhanden.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-failure-en" xml:lang="en">
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Title (CHE_MD_DataIdentification.citation.CI_Citation.title) for locale '#FR' is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors Titre (CHE_MD_DataIdentification.citation.CI_Citation.title) pour la locale '#FR' est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-failure-de" xml:lang="de">
      Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', dann ist Titel (CHE_MD_DataIdentification.citation.CI_Citation.title) für die Locale '#FR' obligatorisch.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-success-en" xml:lang="en">
      Title (CHE_MD_DataIdentification.citation.CI_Citation.title) for locale '#FR' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-success-fr" xml:lang="fr">
      Titre (CHE_MD_DataIdentification.citation.CI_Citation.title) pour la locale '#FR' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-title-fr-mandatory-success-de" xml:lang="de">
      Titel (CHE_MD_DataIdentification.citation.CI_Citation.title) für die Locale '#FR' ist vorhanden.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-de-mandatory-failure-en" xml:lang="en">
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Alternate title (cit:alternateTitle) for locale '#DE' is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-de-mandatory-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors Autre titre (cit:alternateTitle) pour la locale '#DE' est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-de-mandatory-failure-de" xml:lang="de">
      Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', dann ist Alternativtitel (cit:alternateTitle) für die Locale '#DE' obligatorisch.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-de-mandatory-success-en" xml:lang="en">
      Alternate title (cit:alternateTitle) for locale '#DE' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-de-mandatory-success-fr" xml:lang="fr">
      Autre titre (cit:alternateTitle) pour la locale '#DE' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-de-mandatory-success-de" xml:lang="de">
      Alternativtitel (cit:alternateTitle) für die Locale '#DE' ist vorhanden.
    </sch:diagnostic>
    <!-- Règle : Si le mot-clé 'BGDI Bundesgeodaten-Infrastruktur' est positionné, alors l'alternateTitle de la citation est obligatoire en français (#FR) -->
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-fr-mandatory-failure-en" xml:lang="en">
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Alternate title (cit:alternateTitle) for locale '#FR' is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-fr-mandatory-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors Autre titre (cit:alternateTitle) pour la locale '#FR' est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-fr-mandatory-failure-de" xml:lang="de">
      Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', dann ist Alternativtitel (cit:alternateTitle) für die Locale '#FR' obligatorisch.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-fr-mandatory-success-en" xml:lang="en">
      Alternate title (cit:alternateTitle) for locale '#FR' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-fr-mandatory-success-fr" xml:lang="fr">
      Autre titre (cit:alternateTitle) pour la locale '#FR' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-alternatetitle-fr-mandatory-success-de" xml:lang="de">
      Alternativtitel (cit:alternateTitle) für die Locale '#FR' ist vorhanden.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-de-mandatory-failure-en" xml:lang="en">
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Abstract (mri:abstract) for locale '#DE' is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-de-mandatory-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors Résumé (mri:abstract) pour la locale '#DE' est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-de-mandatory-failure-de" xml:lang="de">
      Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', dann ist Kurzbeschreibung (mri:abstract) für die Locale '#DE' obligatorisch.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-de-mandatory-success-en" xml:lang="en">
      Abstract (mri:abstract) for locale '#DE' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-de-mandatory-success-fr" xml:lang="fr">
      Résumé (mri:abstract) pour la locale '#DE' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-de-mandatory-success-de" xml:lang="de">
      Kurzbeschreibung (mri:abstract) für die Locale '#DE' ist vorhanden.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-fr-mandatory-failure-en" xml:lang="en">
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Abstract (mri:abstract) for locale '#FR' is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-fr-mandatory-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors Résumé (mri:abstract) pour la locale '#FR' est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-fr-mandatory-failure-de" xml:lang="de">
      Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', dann ist Kurzbeschreibung (mri:abstract) für die Locale '#FR' obligatorisch.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-fr-mandatory-success-en" xml:lang="en">
      Abstract (mri:abstract) for locale '#FR' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-fr-mandatory-success-fr" xml:lang="fr">
      Résumé (mri:abstract) pour la locale '#FR' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-abstract-fr-mandatory-success-de" xml:lang="de">
      Kurzbeschreibung (mri:abstract) für die Locale '#FR' ist vorhanden.
    </sch:diagnostic>
  </sch:diagnostics>

  <sch:pattern id="rule.che.bgdi-keyword-title-de-mandatory">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Title (CHE_MD_DataIdentification.citation.CI_Citation.title) for locale '#DE' is mandatory</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors Titre (CHE_MD_DataIdentification.citation.CI_Citation.title) pour la locale '#DE' est obligatoire</sch:title>
    <sch:title xml:lang="de">Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' dann ist Titel (CHE_MD_DataIdentification.citation.CI_Citation.title) für die Locale '#DE' obligatorisch</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#DE' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-title-de-mandatory-failure-en rule.che.bgdi-keyword-title-de-mandatory-failure-fr rule.che.bgdi-keyword-title-de-mandatory-failure-de"/>
      <sch:report test="mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#DE' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-title-de-mandatory-success-en rule.che.bgdi-keyword-title-de-mandatory-success-fr rule.che.bgdi-keyword-title-de-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="rule.che.bgdi-keyword-title-fr-mandatory">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Title (CHE_MD_DataIdentification.citation.CI_Citation.title) for locale '#FR' is mandatory</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors Titre (CHE_MD_DataIdentification.citation.CI_Citation.title) pour la locale '#FR' est obligatoire</sch:title>
    <sch:title xml:lang="de">Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' dann ist Titel (CHE_MD_DataIdentification.citation.CI_Citation.title) für die Locale '#FR' obligatorisch</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-title-fr-mandatory-failure-en rule.che.bgdi-keyword-title-fr-mandatory-failure-fr rule.che.bgdi-keyword-title-fr-mandatory-failure-de"/>
      <sch:report test="mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-title-fr-mandatory-success-en rule.che.bgdi-keyword-title-fr-mandatory-success-fr rule.che.bgdi-keyword-title-fr-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="rule.che.bgdi-keyword-alternatetitle-de-mandatory">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Alternate title (cit:alternateTitle) for locale '#DE' is mandatory</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors Autre titre (cit:alternateTitle) pour la locale '#DE' est obligatoire</sch:title>
    <sch:title xml:lang="de">Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' dann ist Alternativtitel (cit:alternateTitle) für die Locale '#DE' obligatorisch</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="mri:citation/cit:CI_Citation/cit:alternateTitle/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#DE' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-alternatetitle-de-mandatory-failure-en rule.che.bgdi-keyword-alternatetitle-de-mandatory-failure-fr rule.che.bgdi-keyword-alternatetitle-de-mandatory-failure-de"/>
      <sch:report test="mri:citation/cit:CI_Citation/cit:alternateTitle/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#DE' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-alternatetitle-de-mandatory-success-en rule.che.bgdi-keyword-alternatetitle-de-mandatory-success-fr rule.che.bgdi-keyword-alternatetitle-de-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="rule.che.bgdi-keyword-alternatetitle-fr-mandatory">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Alternate title (cit:alternateTitle) for locale '#FR' is mandatory</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors Autre titre (cit:alternateTitle) pour la locale '#FR' est obligatoire</sch:title>
    <sch:title xml:lang="de">Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' dann ist Alternativtitel (cit:alternateTitle) für die Locale '#FR' obligatorisch</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="mri:citation/cit:CI_Citation/cit:alternateTitle/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-alternatetitle-fr-mandatory-failure-en rule.che.bgdi-keyword-alternatetitle-fr-mandatory-failure-fr rule.che.bgdi-keyword-alternatetitle-fr-mandatory-failure-de"/>
      <sch:report test="mri:citation/cit:CI_Citation/cit:alternateTitle/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-alternatetitle-fr-mandatory-success-en rule.che.bgdi-keyword-alternatetitle-fr-mandatory-success-fr rule.che.bgdi-keyword-alternatetitle-fr-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="rule.che.bgdi-keyword-abstract-de-mandatory">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Abstract (mri:abstract) for locale '#DE' is mandatory</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors Résumé (mri:abstract) pour la locale '#DE' est obligatoire</sch:title>
    <sch:title xml:lang="de">Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' dann ist Kurzbeschreibung (mri:abstract) für die Locale '#DE' obligatorisch</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="mri:abstract/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#DE' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-abstract-de-mandatory-failure-en rule.che.bgdi-keyword-abstract-de-mandatory-failure-fr rule.che.bgdi-keyword-abstract-de-mandatory-failure-de"/>
      <sch:report test="mri:abstract/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#DE' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-abstract-de-mandatory-success-en rule.che.bgdi-keyword-abstract-de-mandatory-success-fr rule.che.bgdi-keyword-abstract-de-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="rule.che.bgdi-keyword-abstract-fr-mandatory">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Abstract (mri:abstract) for locale '#FR' is mandatory</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors Résumé (mri:abstract) pour la locale '#FR' est obligatoire</sch:title>
    <sch:title xml:lang="de">Wenn Schlüsselwörter (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' dann ist Kurzbeschreibung (mri:abstract) für die Locale '#FR' obligatorisch</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="mri:abstract/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-abstract-fr-mandatory-failure-en rule.che.bgdi-keyword-abstract-fr-mandatory-failure-fr rule.che.bgdi-keyword-abstract-fr-mandatory-failure-de"/>
      <sch:report test="mri:abstract/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR' and normalize-space(text())!='']"
        diagnostics="rule.che.bgdi-keyword-abstract-fr-mandatory-success-en rule.che.bgdi-keyword-abstract-fr-mandatory-success-fr rule.che.bgdi-keyword-abstract-fr-mandatory-success-de"/>
    </sch:rule>
  </sch:pattern>
</sch:schema>
