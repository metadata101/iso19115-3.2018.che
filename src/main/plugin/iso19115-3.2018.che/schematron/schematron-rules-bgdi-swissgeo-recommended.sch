<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">bgdi-swissgeo recommended rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="fr">bgdi-swissgeo règles recommandées</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="de">bgdi-swissgeo empfohlene Regeln</sch:title>
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
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then a Point of contact (mri:pointOfContact) with role 'owner' is recommended.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors un Contact pour la ressource (mri:pointOfContact) avec le rôle 'owner' est recommandé.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-failure-de" xml:lang="de">
      Wenn Stichwort (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', wird ein Kontakt für die Ressource (mri:pointOfContact) mit der Rolle 'owner' empfohlen.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-success-en" xml:lang="en">
      A Point of contact (mri:pointOfContact) with role 'owner' is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-success-fr" xml:lang="fr">
      Un Contact pour la ressource (mri:pointOfContact) avec le rôle 'owner' est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-poc-owner-recommended-success-de" xml:lang="de">
      Ein Kontakt für die Ressource (mri:pointOfContact) mit der Rolle 'owner' ist vorhanden.
    </sch:diagnostic>

    <sch:diagnostic id="rule.che.bgdi-keyword-identifier-code-recommended-failure-en" xml:lang="en">
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Identifier (CHE_MD_DataIdentification.citation.CI_Citation.identifier) must be defined.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-identifier-code-recommended-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors Identifiant (CHE_MD_DataIdentification.citation.CI_Citation.identifier) doit être défini.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-identifier-code-recommended-failure-de" xml:lang="de">
      Wenn Stichwort (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', dann muss Kennung (CHE_MD_DataIdentification.citation.CI_Citation.identifier) definiert sein.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-identifier-code-recommended-success-en" xml:lang="en">
      Identifier (CHE_MD_DataIdentification.citation.CI_Citation.identifier) is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-identifier-code-recommended-success-fr" xml:lang="fr">
      Identifiant (CHE_MD_DataIdentification.citation.CI_Citation.identifier) est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-identifier-code-recommended-success-de" xml:lang="de">
      Kennung (CHE_MD_DataIdentification.citation.CI_Citation.identifier) ist vorhanden.
    </sch:diagnostic>

    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-failure-en" xml:lang="en">
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Status (mri:status) is recommended.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors État (mri:status) est recommandé.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-failure-de" xml:lang="de">
      Wenn Stichwort (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', wird Bearbeitungsstatus (mri:status) empfohlen.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-success-en" xml:lang="en">
      Status (mri:status) is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-success-fr" xml:lang="fr">
      État (mri:status) est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-status-recommended-success-de" xml:lang="de">
      Bearbeitungsstatus (mri:status) ist vorhanden.
    </sch:diagnostic>

    <sch:diagnostic id="rule.che.bgdi-keyword-legal-otherconstraints-recommended-failure-en" xml:lang="en">
      If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure', then Other constraints (mco:otherConstraints) is recommended.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-legal-otherconstraints-recommended-failure-fr" xml:lang="fr">
      Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques', alors Autres contraintes (mco:otherConstraints) est recommandé.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-legal-otherconstraints-recommended-failure-de" xml:lang="de">
      Wenn Stichwort (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur', werden Andere Einschränkungen (mco:otherConstraints) empfohlen.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-legal-otherconstraints-recommended-success-en" xml:lang="en">
      Other constraints (mco:otherConstraints) is present.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-legal-otherconstraints-recommended-success-fr" xml:lang="fr">
      Autres contraintes (mco:otherConstraints) est présent.
    </sch:diagnostic>
    <sch:diagnostic id="rule.che.bgdi-keyword-legal-otherconstraints-recommended-success-de" xml:lang="de">
      Andere Einschränkungen (mco:otherConstraints) sind vorhanden.
    </sch:diagnostic>
  </sch:diagnostics>

  <sch:pattern id="rule.che.bgdi-keyword-poc-owner-recommended">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then a Point of contact (mri:pointOfContact) with role 'owner' is recommended</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors un Contact pour la ressource (mri:pointOfContact) avec le rôle 'owner' est recommandé</sch:title>
    <sch:title xml:lang="de">Wenn Stichwort (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' wird ein Kontakt für die Ressource (mri:pointOfContact) mit der Rolle 'owner' empfohlen</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:report test="mri:pointOfContact/cit:CI_Responsibility/cit:role/cit:CI_RoleCode[@codeListValue='owner']"
        diagnostics="rule.che.bgdi-keyword-poc-owner-recommended-success-en rule.che.bgdi-keyword-poc-owner-recommended-success-fr rule.che.bgdi-keyword-poc-owner-recommended-success-de"/>
      <sch:assert test="mri:pointOfContact/cit:CI_Responsibility/cit:role/cit:CI_RoleCode[@codeListValue='owner']"
        diagnostics="rule.che.bgdi-keyword-poc-owner-recommended-failure-en rule.che.bgdi-keyword-poc-owner-recommended-failure-fr rule.che.bgdi-keyword-poc-owner-recommended-failure-de"/>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="rule.che.bgdi-keyword-identifier-code-recommended">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Identifier (CHE_MD_DataIdentification.citation.CI_Citation.identifier) must be defined</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors Identifiant (CHE_MD_DataIdentification.citation.CI_Citation.identifier) doit être défini</sch:title>
    <sch:title xml:lang="de">Wenn Stichwort (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' dann muss Kennung (CHE_MD_DataIdentification.citation.CI_Citation.identifier) definiert sein</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:assert test="some $id in mri:citation/cit:CI_Citation/cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString satisfies normalize-space($id) != ''"
        diagnostics="rule.che.bgdi-keyword-identifier-code-recommended-failure-en rule.che.bgdi-keyword-identifier-code-recommended-failure-fr rule.che.bgdi-keyword-identifier-code-recommended-failure-de"/>
      <sch:report test="some $id in mri:citation/cit:CI_Citation/cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString satisfies normalize-space($id) != ''"
        diagnostics="rule.che.bgdi-keyword-identifier-code-recommended-success-en rule.che.bgdi-keyword-identifier-code-recommended-success-fr rule.che.bgdi-keyword-identifier-code-recommended-success-de"/>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="rule.che.bgdi-keyword-status-recommended">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Status (mri:status) is recommended</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors État (mri:status) est recommandé</sch:title>
    <sch:title xml:lang="de">Wenn Stichwort (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' wird Bearbeitungsstatus (mri:status) empfohlen</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:report test="mri:status/mcc:MD_ProgressCode and normalize-space(mri:status/mcc:MD_ProgressCode/@codeListValue) != ''"
        diagnostics="rule.che.bgdi-keyword-status-recommended-success-en rule.che.bgdi-keyword-status-recommended-success-fr rule.che.bgdi-keyword-status-recommended-success-de"/>
      <sch:assert test="mri:status/mcc:MD_ProgressCode and normalize-space(mri:status/mcc:MD_ProgressCode/@codeListValue) != ''"
        diagnostics="rule.che.bgdi-keyword-status-recommended-failure-en rule.che.bgdi-keyword-status-recommended-failure-fr rule.che.bgdi-keyword-status-recommended-failure-de"/>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="rule.che.bgdi-keyword-legal-otherconstraints-recommended">
    <sch:title xml:lang="en">If Keyword (MD_Keywords.keyword) = 'FSDI Federal Spatial Data Infrastructure' then Other constraints (mco:otherConstraints) is recommended</sch:title>
    <sch:title xml:lang="fr">Si Mot Clé (MD_Keywords.keyword) = 'IFDG l'Infrastructure Fédérale de données géographiques' alors Autres contraintes (mco:otherConstraints) est recommandé</sch:title>
    <sch:title xml:lang="de">Wenn Stichwort (MD_Keywords.keyword) = 'BGDI Bundesgeodaten-Infrastruktur' werden Andere Einschränkungen (mco:otherConstraints) empfohlen</sch:title>
    <sch:rule context="//che:CHE_MD_DataIdentification[.//mri:MD_Keywords/mri:keyword/gco:CharacterString = 'BGDI Bundesgeodaten-Infrastruktur']">
      <sch:report test="some $oc in mri:resourceConstraints/che:CHE_MD_LegalConstraints/mco:otherConstraints/* satisfies normalize-space($oc) != ''"
        diagnostics="rule.che.bgdi-keyword-legal-otherconstraints-recommended-success-en rule.che.bgdi-keyword-legal-otherconstraints-recommended-success-fr rule.che.bgdi-keyword-legal-otherconstraints-recommended-success-de"/>
      <sch:assert test="some $oc in mri:resourceConstraints/che:CHE_MD_LegalConstraints/mco:otherConstraints/* satisfies normalize-space($oc) != ''"
        diagnostics="rule.che.bgdi-keyword-legal-otherconstraints-recommended-failure-en rule.che.bgdi-keyword-legal-otherconstraints-recommended-failure-fr rule.che.bgdi-keyword-legal-otherconstraints-recommended-failure-de"/>
    </sch:rule>
  </sch:pattern>

</sch:schema>
