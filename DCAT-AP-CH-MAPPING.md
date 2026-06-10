# eCH-0271 to DCAT-AP CH Mapping Documentation

## Overview

This document describes the mapping from eCH-0271 (Swiss geocat.ch metadata standard) to DCAT-AP CH (Data Catalog Vocabulary - Application Profile for Switzerland).

The transformation is implemented in the XSLT stylesheet `dcat-ap-ch-core-dataset.xsl` and produces RDF/XML output conforming to the [DCAT-AP CH specification](https://handbook.opendata.swiss/de/content/glossar/bibliothek/dcat-ap-ch.html).

## Key Features

- **Multilingual support**: Handles all four Swiss national languages (DE, FR, IT, EN) plus Romansh (RM)
- **Organization mapping**: Uses `organization-mapping.xml` to map geocat.ch organizations to opendata.swiss slugs
- **Intelligent slug generation**: Automatically generates publisher slugs from organization acronyms or names
- **License mapping**: Converts ISO constraints to DCAT-AP CH license URIs (terms_open, terms_by, terms_ask, etc.)
- **Format detection**: Automatically detects distribution formats from protocols and file extensions
- **EU vocabulary alignment**: Maps ISO code lists to EU Named Authority Lists

## Dataset Level Mapping

-> See mapping-eCH0271-dcat-ap-ch table (tab dcat_ap_ch_mapping)

## Distribution Level Mapping

Distributions are created for online resources with specific protocols:
- `WWW:DOWNLOAD*` - Download files (also sets `dcat:downloadURL`)
- `WWW:LINK*` - Web links (HTML format)
- `OGC:WMTS` - WMTS tile services
- `OGC:WFS` - WFS feature services
- `OGC:WMS` - WMS map services
- `ESRI:REST` - ArcGIS REST services
- `LINKED:DATA` - Linked data services
- `MAP:Preview` - Map preview pages 

-> See mapping-eCH0271-dcat-ap-ch table (tab dcat_ap_ch_distribution_mapping)

## Code Mappings

### ISO Topic Category to VOCAB-EU-THEME URIs

The ISO 19115-3 topic categories (and their Swiss subtopic variants) are mapped to VOCAB-EU-THEME URIs as used by DCAT-AP CH. This mapping ensures consistent categorization across the DCAT-AP vocabulary landscape while remaining compatible with EU data theme standards.

| ISO Topic Category | EU Data Theme Code | Theme URI |
|-------------------|-------------------|-----------|
| imageryBaseMapsEarthCover* | REGI | http://publications.europa.eu/resource/authority/data-theme/REGI |
| imageryBaseMapsEarthCover* | ENVI | http://publications.europa.eu/resource/authority/data-theme/ENVI |
| location | REGI, ENVI | http://publications.europa.eu/resource/authority/data-theme/REGI, http://publications.europa.eu/resource/authority/data-theme/ENVI |
| elevation | REGI, ENVI | http://publications.europa.eu/resource/authority/data-theme/REGI, http://publications.europa.eu/resource/authority/data-theme/ENVI |
| boundaries | REGI, ENVI | http://publications.europa.eu/resource/authority/data-theme/REGI, http://publications.europa.eu/resource/authority/data-theme/ENVI |
| planningCadastre* | REGI, ENVI | http://publications.europa.eu/resource/authority/data-theme/REGI, http://publications.europa.eu/resource/authority/data-theme/ENVI |
| geoscientificInformation* | REGI, ENVI | http://publications.europa.eu/resource/authority/data-theme/REGI, http://publications.europa.eu/resource/authority/data-theme/ENVI |
| structure | ECON | http://publications.europa.eu/resource/authority/data-theme/ECON |
| environment* | ENVI | http://publications.europa.eu/resource/authority/data-theme/ENVI |
| biota | AGRI, ENVI | http://publications.europa.eu/resource/authority/data-theme/AGRI, http://publications.europa.eu/resource/authority/data-theme/ENVI |
| oceans | ENVI | http://publications.europa.eu/resource/authority/data-theme/ENVI |
| inlandWaters | ENVI | http://publications.europa.eu/resource/authority/data-theme/ENVI |
| climatologyMeteorologyAtmosphere | ENVI | http://publications.europa.eu/resource/authority/data-theme/ENVI |
| society | EDUC, SOCI | http://publications.europa.eu/resource/authority/data-theme/EDUC, http://publications.europa.eu/resource/authority/data-theme/SOCI |
| health | HEAL | http://publications.europa.eu/resource/authority/data-theme/HEAL |
| transportation | TRAN | http://publications.europa.eu/resource/authority/data-theme/TRAN |
| utilitiesCommunication | ENER, ENVI, EDUC | http://publications.europa.eu/resource/authority/data-theme/ENER, http://publications.europa.eu/resource/authority/data-theme/ENVI, http://publications.europa.eu/resource/authority/data-theme/EDUC |
| utilitiesCommunication_Energy | ENER | http://publications.europa.eu/resource/authority/data-theme/ENER |
| utilitiesCommunication_Utilities | ENVI | http://publications.europa.eu/resource/authority/data-theme/ENVI |
| utilitiesCommunication_Communication | EDUC | http://publications.europa.eu/resource/authority/data-theme/EDUC |
| intelligenceMilitary | GOVE | http://publications.europa.eu/resource/authority/data-theme/GOVE |
| farming | AGRI | http://publications.europa.eu/resource/authority/data-theme/AGRI |
| economy | ECON | http://publications.europa.eu/resource/authority/data-theme/ECON |

**Theme Prioritization**: When both parent topic and subtopic are present, the **subtopic takes priority** to avoid redundant theme assignments. For example, if a dataset has topic `biota` with subtopic `biota_*` variant, the subtopic mapping is used to prevent duplicate theme URIs in the output.

### ISO Maintenance Frequency to EU Frequency

| ISO Frequency Code | EU Frequency Code | Label |
|-------------------|-------------------|-------|
| continual | CONT | Continuous |
| daily | DAILY | Daily |
| weekly | WEEKLY | Weekly |
| fortnightly | BIWEEKLY | Biweekly |
| monthly | MONTHLY | Monthly |
| quarterly | QUARTERLY | Quarterly |
| biannually | ANNUAL_2 | Semiannual |
| annually | ANNUAL | Annual |
| asNeeded, irregular | IRREG | Irregular |
| (empty/unknown) | UNKNOWN | Unknown |

### ISO 639 Language Codes

| ISO 639-2 (3-letter) | ISO 639-1 (2-letter) | EU Code |
|---------------------|---------------------|---------|
| ger, deu | de | DEU |
| fre, fra | fr | FRA |
| ita | it | ITA |
| eng | en | ENG |
| roh | rm | ROH |

### Distribution Format Mapping

| Protocol/Extension | Format Code | URI |
|-------------------|-------------|-----|
| OGC:WMS* | WMS_SRVC | http://publications.europa.eu/resource/authority/file-type/WMS_SRVC |
| OGC:WMTS* | WMTS_SRVC | http://publications.europa.eu/resource/authority/file-type/WMTS_SRVC |
| OGC:WFS* | WFS_SRVC | http://publications.europa.eu/resource/authority/file-type/WFS_SRVC |
| ESRI:REST* | REST | http://publications.europa.eu/resource/authority/file-type/REST |
| WWW:LINK* | HTML | http://publications.europa.eu/resource/authority/file-type/HTML |
| MAP:Preview* | MAP_PRVW | http://publications.europa.eu/resource/authority/file-type/MAP_PRVW |
| *.shp | SHP | http://publications.europa.eu/resource/authority/file-type/SHP |
| *.gpkg | GPKG | http://publications.europa.eu/resource/authority/file-type/GPKG |
| *.geojson | GEOJSON | http://publications.europa.eu/resource/authority/file-type/GEOJSON |
| *.json | JSON | http://publications.europa.eu/resource/authority/file-type/JSON |
| *.gml | GML | http://publications.europa.eu/resource/authority/file-type/GML |
| *.kml | KML | http://publications.europa.eu/resource/authority/file-type/KML |
| *.csv | CSV | http://publications.europa.eu/resource/authority/file-type/CSV |
| *.xml, *.ili, *.xtf, *.itf | XML | http://publications.europa.eu/resource/authority/file-type/XML |
| *.zip | ZIP | http://publications.europa.eu/resource/authority/file-type/ZIP |
| *.pdf | PDF | http://publications.europa.eu/resource/authority/file-type/PDF |
| *.html, *.htm | HTML | http://publications.europa.eu/resource/authority/file-type/HTML |
| WWW:DOWNLOAD* (no extension) | HTML | http://publications.europa.eu/resource/authority/file-type/HTML |
| (unknown) | UNSPECIFIED | http://publications.europa.eu/resource/authority/file-type/UNSPECIFIED |

### License Mapping

Constraints text in `mco:useLimitation` or `mco:otherConstraints` is analyzed to determine the license:

| Constraint Text Contains | License URI |
|-------------------------|-------------|
| "Opendata BY-ASK" | http://dcat-ap.ch/vocabulary/licenses/terms_by_ask |
| "Opendata BY" | http://dcat-ap.ch/vocabulary/licenses/terms_by |
| "Opendata ASK" | http://dcat-ap.ch/vocabulary/licenses/terms_ask |
| "Opendata OPEN", "Utilisation libre", "Freie Nutzung" | http://dcat-ap.ch/vocabulary/licenses/terms_open |
| "CC0" | https://creativecommons.org/publicdomain/zero/1.0/ |
| "CC BY 4.0" | https://creativecommons.org/licenses/by/4.0/ |
| (default fallback) | http://dcat-ap.ch/vocabulary/licenses/terms_open |

## Organization Publisher Mapping

The transformation uses a configurable `organization-mapping.xml` file to map geocat.ch organization names to opendata.swiss publisher slugs. This ensures consistent publisher identifiers across both platforms.

### Mapping Priority

1. **Exact match**: geocat.ch organization name matches `@geocatName` in mapping file
2. **Base name exact match**: Organization name before comma matches `@geocatName`
3. **Contains match**: `@geocatName` contains the organization name
4. **Acronym fallback**: Use organization acronym from `che:organisationAcronym` (slugified)
5. **Name fallback**: Use organization name (slugified)

### Slug Generation

The `local:slugify()` function normalizes organization names:
- German umlauts: ü→u, ö→o, ä→a, ß→ss
- French accents: é/è/ê→e, à/â→a, ç→c
- Convert to lowercase
- Replace non-alphanumeric characters with hyphens
- Remove leading/trailing hyphens and consecutive hyphens

Example: "Bundesamt für Umwelt (BAFU)" → "bafu" or "bundesamt-fur-umwelt"

## URI Patterns

### Dataset URI
```
https://ckan.opendata.swiss/perma/{uuid}@{publisher-slug}
```

Example:
```
https://ckan.opendata.swiss/perma/550e8400-e29b-41d4-a716-446655440000@bafu
```

### Publisher URI
```
https://opendata.swiss/organization/{publisher-slug}
```

Example:
```
https://opendata.swiss/organization/bafu
```

### geocat.ch Relation URI
```
https://www.geocat.ch/geonetwork/srv/ger/catalog.search#/metadata/{uuid}
```

Example:
```
https://www.geocat.ch/geonetwork/srv/ger/catalog.search#/metadata/550e8400-e29b-41d4-a716-446655440000
```

## Multilingual Handling

All text fields (title, description, keywords) support multilingual content:

1. **Default language**: Extracted from `gco:CharacterString` with language from `mdb:defaultLocale/*/lan:language`
2. **Alternative languages**: Extracted from `lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString/@locale`

The transformation:
- Resolves locale IDs to language codes via `mdb:locale` or `mdb:otherLocale`
- Converts ISO 639-2 (3-letter) codes to ISO 639-1 (2-letter) for xml:lang attributes
- Skips unsupported or unmapped language codes (returns empty string instead of 'und')

Example output:
```xml
<dct:title xml:lang="de">Deutscher Titel</dct:title>
<dct:title xml:lang="fr">Titre français</dct:title>
<dct:title xml:lang="it">Titolo italiano</dct:title>
<dct:title xml:lang="en">English title</dct:title>
```

## Date Handling

All dates are formatted as ISO 8601 DateTime with timezone:

- Input formats accepted: `YYYY-MM-DD` or `YYYY-MM-DDTHH:MM:SS` (with or without timezone)
- Output format: `YYYY-MM-DDTHH:MM:SS+00:00`
- Timezone 'Z' is converted to '+00:00' for better DCAT-AP CH compatibility

## Implementation Notes

### XPath Selection Priority

For contact/publisher organization selection:
1. pointOfContact with role "publisher"
2. pointOfContact with role "owner"
3. pointOfContact with role "pointOfContact"
4. First metadata contact

### Distribution Filtering

Only online resources with specific protocol prefixes are converted to distributions:
- `WWW:DOWNLOAD*` - downloadable files (also sets `dcat:downloadURL`)
- `WWW:LINK*` - web links, included as distributions with format `HTML`
- `OGC:WMTS`, `OGC:WFS`, `OGC:WMS` - OGC web services
- `ESRI:REST` - ArcGIS services
- `LINKED:DATA` - linked data endpoints
- `MAP:Preview` - map preview pages (format `HTML`)

Note: `WWW:LINK*` resources are used **both** as distributions (if present in `mrd:onLine`) and as the dataset landing page (`dcat:landingPage`). The first `WWW:LINK` URL found is used as landing page.

### Mandatory Fields Handling

The transformation ensures all mandatory DCAT-AP CH properties are present:
- If no issued date exists, creation date is used as fallback
- If no license is found, defaults to `terms_open`
- If no format can be determined, uses `UNSPECIFIED`
- Contact point requires at least email address to be included

## References

- [DCAT-AP CH Specification](https://handbook.opendata.swiss/de/content/glossar/bibliothek/dcat-ap-ch.html)
- [ISO 19115-3 Standard](https://www.iso.org/standard/32579.html)
- [EU Named Authority Lists](http://publications.europa.eu/mdr/authority/)
- [geocat.ch Metadata Catalog](https://www.geocat.ch/)
- [opendata.swiss Open Data Portal](https://opendata.swiss/)

## Version History

- **Current version**: Based on XSLT stylesheet in iso19115-3.2018.che plugin
- **Target DCAT version**: DCAT 2.0 / DCAT-AP CH
- **Last updated**: June 2026

### Changelog

**June 2026** (`feature-dcat-ap-ch-v3`):
- **Theme mapping corrected**: Replaced EU data-theme codes (REGI, ENVI, AGRI, etc.) with DCAT-AP CH themes (geography, territory, agriculture, culture, health, mobility, etc.)
- **New mapping function**: Implemented `local:map-topic-to-dcat-ch-themes()` function based on legacy ISO 19139-che `swisstopo_to_ogdch_group_mapping`
- **Subtopic priority logic**: When both parent topic and subtopic are present, subtopic takes priority to avoid redundant theme outputs
- **Duplicate prevention**: Parent topics are excluded if they have corresponding subtopics
- **INTERLIS format support**: Added mapping for Swiss INTERLIS formats (*.ili, *.xtf, *.itf) → XML format
- **WWW:DOWNLOAD fallback**: Resources with `WWW:DOWNLOAD*` protocol but no file extension now default to HTML format (web page/download form)
- All SHACL validation tests pass (16/16 conforming to DCAT-AP 2.1.1 base and DCAT-AP-CH shapes)

**May 2026** (`feature-dcat-ap-ch-v3`):
- `WWW:LINK*` resources now also created as distributions (format `HTML`), in addition to being used as landing page
- `MAP:Preview` distributions: `dct:title` is now the plain `cit:name` (prefix `Map (Preview) ` is handled by CKAN geocat harvester)
- `MAP:Preview` distributions: `dct:format MAP_PRVW` (`http://publications.europa.eu/resource/authority/file-type/MAP_PRVW`) — no `dcat:mediaType` emitted
- Fixed format mapping for `OGC:WMS` with version suffixes (e.g. `OGC:WMS-1.3.0-http-get-map`)
