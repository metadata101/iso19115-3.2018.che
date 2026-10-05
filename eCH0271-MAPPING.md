# eCH-0271 to ISO 19115-3:2018 CHE Mapping Documentation

## Overview

This document describes the mapping from **eCH-0271** (Swiss INTERLIS XTF 2.4 geocat.ch metadata standard) to **ISO 19115-3:2018 CHE** (modern ISO metadata with Swiss extensions).

The transformation is implemented in the XSLT stylesheet suite in `/convert/eCH-0271/` and produces XML output conforming to the ISO 19115-3:2018 CHE specification with proper namespace declarations.

## Architecture

### Main Stylesheet: `fromECH0271.xsl`
Entry point for bidirectional transformation. Includes modular mapping files for different metadata elements.

### Modular Mapping Files (`mapping/`)

| File | Purpose | Maps |
|------|---------|------|
| `CI_Citation.xsl` | Citation data | eCH0271_1:CI_Citation → ISO cit:CI_Citation |
| `CI_Responsibility.xsl` | Contact/responsibility info | eCH0271_1:CI_Responsibility → ISO cit:CI_Responsibility |
| `CI_Date.xsl` | Date handling | eCH0271_1:CI_Date → ISO cit:CI_Date |
| `CI_Identifier.xsl` | Identifiers | eCH0271_1:MD_Identifier → ISO mcc:MD_Identifier |
| `PT_Locale.xsl` | Language/locale information | eCH0271_1:PT_Locale → ISO lan:PT_Locale |
| `CHE_MD_Metadata.xsl` | Root metadata element | eCH0271_1:CHE_MD_Metadata → ISO che:CHE_MD_Metadata |
| `CHE_MD_DataIdentification.xsl` | Dataset identification | eCH0271_1:CHE_MD_DataIdentification → ISO mri:MD_DataIdentification |
| `CHE_MD_MaintenanceInformation.xsl` | Resource maintenance | eCH0271_1:CHE_MD_MaintenanceInformation → ISO mmi:MD_MaintenanceInformation |
| `distribution.xsl` | Distribution/online resources | eCH0271_1:MD_Distribution → ISO mrd:MD_Distribution |
| `extent.xsl` | Geographic/temporal extent | eCH0271_1:EX_Extent → ISO gex:EX_Extent |
| `legislation.xsl` | Legal/legislative information | eCH0271_1:CHE_MD_Legislation → ISO che:CHE_MD_Legislation |
| `resolve-refs.xsl` | Reference resolution utilities | ili:ref/@ili:tid lookup helpers |

### Utility Files (`utility/`)

| File | Purpose |
|------|---------|
| `create19115-3Namespaces.xsl` | Namespace declarations for ISO 19115-3 metadata |
| `dateTime.xsl` | Date/time format transformations |
| `multilingual-text.xsl` | Multilingual text (MultilingualMText → CharacterString/PT_FreeText) handling |

## Key Transformation Patterns

### 1. Reference Resolution (ili:ref → Object Lookup)

eCH-0271 uses INTERLIS flat format with `ili:tid` identifiers and `ili:ref` references:

```xml
<!-- Source: eCH0271 XTF 2.4 -->
<eCH0271_1:citation ili:ref="citation-001"/>

<!-- Resolved object -->
<eCH0271_1:CI_Citation ili:tid="citation-001">
  <eCH0271_1:title>...</eCH0271_1:title>
  <eCH0271_1:date ili:ref="date-001"/>
</eCH0271_1:CI_Citation>
```

**XSLT Resolution**:
```xsl
<xsl:key name="byTID" 
  match="/ili:transfer/ili:datasection/eCH0271_1:eCH0271//*[@ili:tid]"
  use="@ili:tid"/>

<xsl:variable name="citationObj" select="key('byTID', 'citation-001')"/>
```

For nested references, absolute XPath is used:
```xsl
<!-- Direct lookup via absolute path (more reliable than key() in some contexts) -->
<xsl:variable name="dateObj" 
  select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:CI_Date[@ili:tid=$dateRef]"/>
```

### 2. Namespace Mapping

| eCH-0271 | ISO 19115-3:2018 | Purpose |
|----------|-----------------|---------|
| (no namespace) | `mdb:` | MetaDataBase |
| (no namespace) | `mri:` | MetaData for Resource Identification |
| (no namespace) | `cit:` | CITation |
| (no namespace) | `mmi:` | MetaData for Maintenance |
| (no namespace) | `mco:` | MetaData for COnstraints |
| (no namespace) | `mrd:` | MetaData for Resource Distribution |
| (no namespace) | `gex:` | Geospatial EXtent |
| (no namespace) | `lan:` | LANguage |
| (no namespace) | `che:` | CHE (Swiss extensions) |

### 3. Multilingual Text Handling

**Source**: eCH-0271 uses `MultilingualMText`:
```xml
<eCH0271_1:title>
  <eCH0271_1:MultilingualMText>Données géographiques</eCH0271_1:MultilingualMText>
</eCH0271_1:title>
```

**Output**: ISO 19115-3 `gco:CharacterString`:
```xml
<cit:title>
  <gco:CharacterString>Données géographiques</gco:CharacterString>
</cit:title>
```

**Future**: Support for `lan:PT_FreeText` with localized text variants.

### 4. Conditional Element Output

ISO 19115-3 requires certain elements to be always present (even if empty):

**Example - characterEncoding in PT_Locale**:
- If present in source: `<lan:characterEncoding><lan:MD_CharacterSetCode>utf8</lan:MD_CharacterSetCode></lan:characterEncoding>`
- If missing: `<lan:characterEncoding gco:nilReason="unknown" />`

### 5. Citation Date Resolution

**Source structure** (flat INTERLIS):
```xml
<eCH0271_1:CI_Citation ili:tid="citation-001">
  <eCH0271_1:title>...</eCH0271_1:title>
  <eCH0271_1:date ili:ref="date-001"/>
</eCH0271_1:CI_Citation>

<eCH0271_1:CI_Date ili:tid="date-001">
  <eCH0271_1:date>2019-09-30T00:00:00.0</eCH0271_1:date>
  <eCH0271_1:dateType>creation</eCH0271_1:dateType>
</eCH0271_1:CI_Date>
```

**Transformation logic**:
1. Resolve reference via absolute XPath: `key('byTID', @ili:ref)` or `/ili:transfer/.../eCH0271_1:CI_Date[@ili:tid=$ref]`
2. Extract YYYY-MM-DD portion: `substring(normalize-space(date), 1, 10)`
3. Resolve dateType and map to ISO code
4. Generate ISO structure with proper namespaces

## Element Level Mappings

### Metadata Level (CHE_MD_Metadata)

| eCH-0271 Element | ISO 19115-3 Element | Notes |
|-----------------|-------------------|-------|
| `metadataIdentifier[@ili:ref]` | `mdb:metadataIdentifier` → `mcc:MD_Identifier` | Reference resolution required |
| `defaultLocale` | `mdb:defaultLocale` → `lan:PT_Locale` | Language + charset encoding |
| `metadataScope[@ili:ref]` | `mdb:metadataScope` → `mdb:MD_MetadataScope` | Resource scope (dataset, series, etc.) |
| `contact[@ili:ref]` | `mdb:contact` → `cit:CI_Responsibility` | Metadata contact/custodian |
| `dateInfo` | `mdb:dateInfo` → `cit:CI_Date` | Metadata creation/revision date |
| `standardUsedBymetadataStandard[@ili:ref]` | `mdb:metadataStandard` → `cit:CI_Citation` | ISO 19115-3 standard citation |
| `referenceSystemInfo[@ili:ref]` | `mdb:referenceSystemInfo` → `mrs:MD_ReferenceSystem` | CRS/EPSG information |
| `identificationInfo[@ili:ref]` | `mdb:identificationInfo` → `mri:MD_DataIdentification` | Dataset/resource description |
| `distributionInfo[@ili:ref]` | `mdb:distributionInfo` → `mrd:MD_Distribution` | Online/offline distribution |
| `legislationInformation[@ili:ref]` | `mdb:contentInfo` | Swiss legal/legislative info |

### Dataset Identification Level (CHE_MD_DataIdentification)

| eCH-0271 Element | ISO 19115-3 Element | Notes |
|-----------------|-------------------|-------|
| `citation[@ili:ref]` | `mri:citation` → `cit:CI_Citation` | **With date resolution** |
| `abstract` | `mri:abstract` → `gco:CharacterString` | Dataset summary |
| `status` | `mri:status` → `mcc:MD_ProgressCode` | Progress/status code |
| `pointOfContact[@ili:ref]` | `mri:pointOfContact` → `cit:CI_Responsibility` | Contact for resource queries |
| `topicCategory` | `mri:topicCategory` → `mri:MD_TopicCategoryCode` | ISO topic category |
| `extent[@ili:ref]` | `mri:extent` → `gex:EX_Extent` | Geographic/temporal bounds |
| `resourceMaintenance[@ili:ref]` | `mri:resourceMaintenance` → `mmi:MD_MaintenanceInformation` | **With mmi: namespace** |
| `graphicOverview[@ili:ref]` | `mri:graphicOverview` → `mrd:MD_BrowseGraphic` | Thumbnail/preview image |
| `resourceConstraints[@ili:ref]` | `mri:resourceConstraints` → `mco:MD_LegalConstraints` | Legal use constraints |
| `defaultLocale` | `mri:defaultLocale` → `lan:PT_Locale` | Dataset language settings |
| `basicGeodata` | `che:basicGeodata` → `gco:Boolean` | Swiss basic geodata flag |
| `basicGeodataInformation` | `che:basicGeodataInformation` → `che:CHE_MD_BasicGeodataInformation` | Swiss additional metadata |

### Resource Maintenance (New - Critical Fix)

**Old (Incorrect)**:
```xml
<mdb:MD_MaintenanceInformation>
  <mdb:maintenanceAndUpdateFrequency>...</mdb:maintenanceAndUpdateFrequency>
</mdb:MD_MaintenanceInformation>
```

**New (Correct - ISO 19115-3 CHE Compliant)**:
```xml
<mri:resourceMaintenance>
  <che:CHE_MD_MaintenanceInformation gco:isoType="mmi:MD_MaintenanceInformation">
    <mmi:maintenanceAndUpdateFrequency>
      <mmi:MD_MaintenanceFrequencyCode codeList="..." codeListValue="asNeeded">
        asNeeded
      </mmi:MD_MaintenanceFrequencyCode>
    </mmi:maintenanceAndUpdateFrequency>
  </che:CHE_MD_MaintenanceInformation>
</mri:resourceMaintenance>
```

**Key Points**:
- Wrapper element: `che:CHE_MD_MaintenanceInformation` with `gco:isoType="mmi:MD_MaintenanceInformation"`
- Child elements use `mmi:` namespace (maintenance info module)
- Frequency code uses `mmi:MD_MaintenanceFrequencyCode`

## Code List Mappings

### Maintenance Frequency Codes

| eCH-0271 Value | ISO Code | codeListValue |
|---|---|---|
| asNeeded | As needed | asNeeded |
| irregularly | Irregularly | irregularly |
| notPlanned | Not planned | notPlanned |
| unknown | Unknown | unknown |
| continual | Continually | continual |
| daily | Daily | daily |
| weekly | Weekly | weekly |
| fortnightly | Fortnightly | fortnightly |
| monthly | Monthly | monthly |
| quarterly | Quarterly | quarterly |
| biannually | Biannually | biannually |
| annually | Annually | annually |

### Date Type Codes

| eCH-0271 Value | ISO Code |
|---|---|
| creation | creation |
| publication | publication |
| revision | revision |

### Role Codes

| eCH-0271 Value | ISO Code |
|---|---|
| resourceProvider | resourceProvider |
| custodian | custodian |
| owner | owner |
| user | user |
| distributor | distributor |
| originator | originator |
| pointOfContact | pointOfContact |
| principalInvestigator | principalInvestigator |
| processor | processor |
| publisher | publisher |

## Namespace Declarations

All namespaces must be declared in the stylesheet root element:

```xml
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:che="http://geocat.ch/che"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  ...
</xsl:stylesheet>
```

**Critical**: The `mmi` namespace is especially important for maintenance information elements.

## Testing

### Test File: `drones_vd.xtf`
Sample eCH0271 XTF 2.4 file with complete metadata (Vaud drone restrictions dataset)

### Generated Output: `drones_vd-to-iso19115-3.che.xml`
Reference file showing expected ISO 19115-3:2018 CHE output

### Reference Structure: `drones_vd-target-to-iso19115-3.che.xml`
Golden/target file for comparison

### Test Class: `Ech0271ToIso19115cheConversionTest.java`
JUnit test that validates transformation correctness

## Known Issues & Improvements

### ✅ Resolved
1. Citation date resolution - Now properly extracts dates from referenced CI_Date objects
2. resourceMaintenance element type - Now uses che: wrapper with mmi: children
3. PT_Locale characterEncoding - Always present (with nilReason if missing)
4. Namespace bindings - mmi namespace properly declared

### 📝 Future Enhancements
1. PT_FreeText multilingual variant support (multiple languages per element)
2. Extended contact information (phone, fax)
3. Temporal extent (begin/end dates)
4. Additional constraint types (security, legal)

## Related Documentation

- [ISO 19115-3:2018 Standard](https://www.iso.org/standard/67039.html)
- [eCH-0271 INTERLIS Schema](https://www.ech.ch/)
- [DCAT-AP-CH Mapping](./DCAT-AP-CH-MAPPING.md)
