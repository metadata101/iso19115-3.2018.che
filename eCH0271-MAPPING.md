# eCH-0271 XTF to iso19115-3.2018.che Mapping Documentation

## Overview

This document describes the **bijective mapping and transformation** for the profile eCH-0271 based on the ISO Norme ISO 19115:

### Definitions

**eCH0271-XTF**
- [eCH-0271 Standard](https://www.ech.ch/sites/default/files/imce/eCH-Dossier/eCH-Dossier_PDF_Publikationen/Hauptdokument/STAN_f_REP_2025-01-21_eCH-0271_V1.0.0_Profil%20pour%20les%20g%C3%A9om%C3%A9tadonn%C3%A9es.pdf): Swiss federal standard for metadata in Switzerland.
- [INTERLIS Model for eCH-0271](https://www.ech.ch/sites/default/files/imce/eCH-Dossier/0271-0310/eCH-0271/1.0.0/Beilagen/eCH-0271-1-0-0%20ili.zip): `eCH-0271-1-0-0.ili` **v1.0.0** (INTERLIS/UML)
- Format: `.xtf` (INTERLIS 2.4 transfer format) is technically an XML file using a specialized XML encoding with strict rules, governed by the INTERLIS standard, rather than free-form XML”
- Source: Files exported from INTERLIS databases or tools
- Structure: Flat basket format with object references via `@ili:tid`/`@ili:ref`
- Use Case: Legacy metadata system, INTERLIS-based workflows

**iso19115-3.2018.che**
- [eCH-0271 Standard](https://www.ech.ch/sites/default/files/imce/eCH-Dossier/eCH-Dossier_PDF_Publikationen/Hauptdokument/STAN_f_REP_2025-01-21_eCH-0271_V1.0.0_Profil%20pour%20les%20g%C3%A9om%C3%A9tadonn%C3%A9es.pdf): Swiss federal standard for metadata in Switzerland.
- [Schema for eCH-0271](https://www.ech.ch/sites/default/files/imce/eCH-Dossier/0271-0310/eCH-0271/1.0.0/Beilagen/eCH-0271-1-0-0.zip): `eCH-0271-1-0-0.xsd` **v1.0.0** (XSD)
- Format: `.xml` (iso19115-3.2018.che XML)
- Location: GeoNetwork metadata catalog (processed through this plugin)
- Structure: Hierarchical XML with proper ISO namespaces (`mdb:`, `mri:`, `cit:`, etc.)
- Use Case: Modern metadata management in GeoNetwork, ISO-compliant systems

#### 📌 Important Note on Versioning

| Artifact | Version | Reference |
|----------|---------|-----------|
| File `.xsd` (iso19115-3.2018.che) | **v1.0.0** | eCH-0271 Standard |
| File `.ili` (eCH-0271) | **v1.0.0** | [INTERLIS 2 Reference](https://www.ech.ch/sites/default/files/imce/eCH-Dossier/eCH-Dossier_PDF_Publikationen/Hauptdokument/STAN_f_DEF_2024-04-24_eCH-0031_V2.1.0_INTERLIS_2-Manuel_de_re%CC%81fe%CC%81rence.pdf#45#1) |
| Documentation (this file) | **v1.1.0** | [eCH-0271 Profile Standard](https://www.ech.ch/sites/default/files/imce/eCH-Dossier/eCH-Dossier_PDF_Publikationen/Hauptdokument/STAN_f_REP_2025-01-21_eCH-0271_V1.0.0_Profil%20pour%20les%20g%C3%A9om%C3%A9tadonn%C3%A9es.pdf) |

> ⚠️ **The `.xsd` and `.ili` files remain unchanged in v1.0.0**. Only the documentation is updated to v1.1.0 to provide clarifications and corrections. No schema or structural modifications have been applied.

**Key Insight**: Both standards and schema represent the exact same eCH-0271 metadata norm—only the representation differs.

---

#### Hierarchical Structure: From Norm to Format

```
Norm (ISO 19115-1)
    ↓ [Profiled by]
Profile (eCH-0271)
    ↓ [Described by]
Model (INTERLIS/UML in eCH-0271-1-0-0.ili)
    ├─ [Encoded in] → XTF Format (source: flat INTERLIS XML)
    ↓ [Implemented as]
Schema (iso19115-3.2018.che XML Schema in eCH-0271-1-0-0.xsd)
    └─ [Encoded in] → XML Format (target: hierarchical ISO XML)
```

**Reading the flow**:
1. **Norm**: International standard ISO 19115-1 provides the conceptual foundation
2. **Profile**: eCH-0271 adapts ISO 19115-1 to Swiss requirements (legal, operational)
3. **Model**: INTERLIS/UML schema (`.ili`) describes the data structure (objects, relationships, attributes)
4. **Schema**: XSD schema (`.xsd`) implements the model as XML validation rules with ISO namespaces
5. **Formats**: 
   - **XTF** (source) = INTERLIS-compliant specialized XML with flat structure
   - **XML** (target) = ISO 19115-3 hierarchical XML with `mdb:`, `mri:`, `cit:` namespaces

---

### Transformations 
This is only an implementation suggestion (maybe there is a more GN friendly implementation that should be used). For Batch import proposition, we should support multiple MD inside single XTF only in phase 2 or 3. (to be aligned with ISO SERIES)

1. **Forward** (eCH-0271 XTF → iso19115-3.2018.che XML)
   - Input: INTERLIS `.xtf` files from eCH-0271 schema
   - Output: iso19115-3.2018.che XML with `che:CHE_MD_Metadata` root element
   - Single records produce direct `CHE_MD_Metadata` elements
   - Multiple records are wrapped for batch processing via MEF v2 importer
   - Entry point: `convert/fromECH0271.xsl` (GeoNetwork integration wrapper)

2. **Reverse** (iso19115-3.2018.che XML → eCH-0271 XTF)
   - Input: iso19115-3.2018.che XML metadata
   - Output: INTERLIS `.xtf` files conforming to eCH-0271 schema
   - Generates flat basket structure with proper `@ili:tid`/`@ili:ref` linking
   - Ensures eCH0271_1 namespace compliance and INTERLIS structure
   - Uses: `convert/eCH-0271/toECH0271.xsl` (~770 lines, standalone)

3. **Batch Import** (eCH-0271 XTF → MEF v2 ZIP)
   - Input: Single or multiple eCH-0271 XTF records
   - Output: GeoNetwork MEF v2 ZIP format (intermediate for batch import)
   - Auto-detects record count and applies appropriate workflow
   - Uses: Java class `Ech0271ToMefImporter` with embedded XSLT transformation
   - Integrates seamlessly with GeoNetwork batch import pipeline

All transformations are implemented in the XSLT stylesheet suite and produce output conforming to iso19115-3.2018.che specifications with proper namespace declarations.

## Mapping Patterns

### 1. Reference Resolution (ili:ref → Object Lookup)

eCH-0271 uses INTERLIS flat format with `@ili:tid` identifiers and `@ili:ref` references. The XSLT resolves these via `xsl:key`:

```xsl
<!-- Create lookup key by @ili:tid -->
<xsl:key name="byTID" 
  match="/ili:transfer/ili:datasection/eCH0271_1:eCH0271//*[@ili:tid]"
  use="@ili:tid"/>

<!-- Resolve: @ili:ref="citation-001" → CI_Citation[@ili:tid="citation-001"] -->
<xsl:variable name="citObj" select="key('byTID', @ili:ref)"/>
```

**Pattern Example**:
```xml
<!-- Source (flat INTERLIS): -->
<eCH0271_1:CHE_MD_Metadata ili:tid="md-001">
  <eCH0271_1:contact ili:ref="contact-001"/>  <!-- Reference -->
</eCH0271_1:CHE_MD_Metadata>

<eCH0271_1:CI_Responsibility ili:tid="contact-001">  <!-- Definition -->
  <eCH0271_1:role>pointOfContact</eCH0271_1:role>
</eCH0271_1:CI_Responsibility>
```

**Resolution**: Template matches `@ili:ref`, uses `key('byTID', @ili:ref)` to find the object, then processes it.

### 2. Single vs Multiple Records Handling (WORKFLOW A/B)

**WORKFLOW A - Single Record** (direct XSLT import in GeoNetwork)
```xsl
<xsl:when test="count($mdRecords) = 1">
  <!-- Returns unwrapped CHE_MD_Metadata element -->
  <xsl:apply-templates select="$mdRecords[1]" mode="md-metadata"/>
</xsl:when>
```

**WORKFLOW B - Multiple Records** (MEF v2 ZIP via Java importer)
```xsl
<xsl:otherwise>
  <!-- Wraps results in temporary <root> container -->
  <root>
    <xsl:apply-templates select="$mdRecords" mode="md-metadata"/>
  </root>
</xsl:otherwise>
```

### 3. Code Elements (with codeList Attributes)

iso19115-3.2018.che requires code elements to include `codeList` and `codeListValue` attributes.

**XTF Source Example** (eCH-0271):
```xml
<!-- Input from eCH-0271 XTF: -->
<eCH0271_1:defaultLocale>
  <eCH0271_1:PT_Locale>
    <eCH0271_1:language>fr</eCH0271_1:language>
    <eCH0271_1:characterEncoding>utf8</eCH0271_1:characterEncoding>
  </eCH0271_1:PT_Locale>
</eCH0271_1:defaultLocale>
```

**ISO Output Example** (iso19115-3.2018.che):
```xml
<!-- Output after transformation: -->
<mdb:defaultLocale>
  <lan:PT_Locale>
    <lan:language>
      <lan:LanguageCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/lan/LanguageCode.xml" 
                        codeListValue="fra">fra</lan:LanguageCode>
    </lan:language>
    <lan:characterEncoding>
      <lan:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/lan/MD_CharacterSetCode.xml" 
                               codeListValue="utf8">utf8</lan:MD_CharacterSetCode>
    </lan:characterEncoding>
  </lan:PT_Locale>
</mdb:defaultLocale>
```

**Transformation Template** (fromECH0271.xsl):
```xsl
<!-- Template from fromECH0271.xsl -->
<xsl:template name="language-code">
  <xsl:param name="value" as="xs:string"/>
  <lan:LanguageCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/lan/LanguageCode.xml" 
                    codeListValue="{$langCode}">
    <xsl:value-of select="$langCode"/>
  </lan:LanguageCode>
</xsl:template>

Similar templates exist for: `language-code`, `character-set-code`, `scope-code`, `role-code`, `date-type-code`, `frequency-code`
```

**Error Handling: Missing or Unknown Code Values**

If `codeList` or `codeListValue` cannot be resolved during transformation, the system exhibits specific fallback behaviors:

**Scenario 1: codeList URL Missing**
- **Condition**: Template lacks `codeList` URL parameter or parameter is empty
- **Expected Behavior**: 
  - Element generated **WITHOUT** `codeList` attribute
  - iso19115-3.2018.che validation FAILS (mandatory attribute missing)
  - Element still contains `codeListValue` and element content
- **Example**:
  ```xml
  <lan:LanguageCode codeListValue="fra">fra</lan:LanguageCode>
  ```
- **Impact**: Non-compliant metadata; downstream validators will reject
- **Fix**: Verify XSLT template includes correct `codeList` URL for code type

**Scenario 2: codeListValue Not Found or Unknown**
- **Condition**: Input value (e.g., "xyz") does not exist in ISO codelist or mapping table
- **Expected Behavior**: 
  - Template proceeds anyway (no error thrown)
  - Element generated with `codeList` attribute intact
  - `codeListValue` contains non-ISO-compliant value
  - Element content matches the invalid value
- **Example** (input language = "xyz"):
  ```xml
  <lan:LanguageCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/lan/LanguageCode.xml" 
                    codeListValue="xyz">xyz</lan:LanguageCode>
  ```
- **Impact**: Metadata XML is well-formed but semantically invalid; GeoNetwork validation will flag "unknown code"
- **Recommendation**: Pre-validate source eCH-0271 data against ISO codelists before transformation

**Scenario 3: Source Value is Null or Empty**
- **Condition**: Input element exists but contains no text content or is NIL
- **Expected Behavior**:
  - Template generates element with `codeList` attribute
  - Element includes `gco:nilReason="unknown"` attribute (ISO compliance)
  - Element content is empty
  - `codeListValue` may be absent or empty
- **Example**:
  ```xml
  <lan:LanguageCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/lan/LanguageCode.xml" 
                    gco:nilReason="unknown"/>
  ```
- **Impact**: Metadata is ISO-compliant (nil values are allowed with reason); indicates intentional data absence
- **Recommendation**: Valid use case for optional fields; GeoNetwork will accept and display as "Not specified"

**Scenario 4: Multiple codeList Variants (e.g., language code mappings)**
- **Condition**: Input eCH-0271 uses 2-letter code (e.g., "fr") but ISO codelist expects 3-letter code (e.g., "fra")
- **Expected Behavior**:
  - XSLT mapping table converts "fr" → "fra" (if mapping exists)
  - Both `codeList` and `codeListValue` are set correctly
  - If mapping not found, proceeds with 2-letter code (Scenario 2)
- **Example** (correct mapping):
  ```xml
  <!-- XTF Source: <language>fr</language> -->
  <!-- After transformation: -->
  <lan:LanguageCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/lan/LanguageCode.xml" 
                    codeListValue="fra">fra</lan:LanguageCode>
  ```
- **Impact**: Proper transformation when mapping table is complete; validation passes
- **Verification**: Check `convert/eCH-0271/mapping/*.xsl` for `xsl:choose` or `xsl:when` mappings

**Summary Decision Tree**:

```
Input eCH-0271 Code Value
        ↓
  Does XSLT Template Exist?
  ├─ NO → Generate element without codeList (❌ INVALID)
  └─ YES → Does Template Have codeList URL?
     ├─ NO → Generate element without codeList (❌ INVALID)
     └─ YES → Apply Mapping Table (xsl:when test)
        ├─ Value Found → Output ISO code (✅ VALID)
        ├─ Value Not Found → Output original value (⚠️ VALIDATION WARNING)
        └─ NULL/Empty → Output nilReason="unknown" (✅ VALID, ISO-compliant)
```

### 4. Multilingual Text Handling

eCH-0271 supports multilingual metadata text using `MultilingualMText` with `xml:lang` attributes. iso19115-3.2018.che represents this via `gco:CharacterString` (primary language) and `lan:PT_FreeText` (additional languages).

**Multiple Languages Example**:

**XTF Source** (eCH-0271):
```xml
<eCH0271_1:title>
  <eCH0271_1:MultilingualMText>Géodonnées suisses</eCH0271_1:MultilingualMText>
</eCH0271_1:title>
<eCH0271_1:title xml:lang="de">
  <eCH0271_1:MultilingualMText>Schweizer Geodaten</eCH0271_1:MultilingualMText>
</eCH0271_1:title>
<eCH0271_1:title xml:lang="it">
  <eCH0271_1:MultilingualMText>Geodati svizzeri</eCH0271_1:MultilingualMText>
</eCH0271_1:title>
```

**ISO Output** (iso19115-3.2018.che):
```xml
<cit:title>
  <gco:CharacterString>Géodonnées suisses</gco:CharacterString>
  <lan:PT_FreeText>
    <lan:textGroup>
      <lan:LocalisedCharacterString locale="#DE">Schweizer Geodaten</lan:LocalisedCharacterString>
    </lan:textGroup>
    <lan:textGroup>
      <lan:LocalisedCharacterString locale="#IT">Geodati svizzeri</lan:LocalisedCharacterString>
    </lan:textGroup>
  </lan:PT_FreeText>
</cit:title>
```

**Transformation Rules**:
- Primary language (no `xml:lang` attribute) → `gco:CharacterString`
- Additional languages (with `xml:lang`) → `lan:PT_FreeText/textGroup` entries
- `locale` attribute: `#FR`, `#DE`, `#IT`, `#EN`, `#RM`


### 5. Conditional Element Output

iso19115-3.2018.che requires certain elements to be always present (even if empty):

**Example - characterEncoding in PT_Locale**:
- If present in source: `<lan:characterEncoding><lan:MD_CharacterSetCode>utf8</lan:MD_CharacterSetCode></lan:characterEncoding>`
- If missing: `<lan:characterEncoding gco:nilReason="unknown" />`

### 6. Date Handling and Formatting

**Bijection Constraint**: For reversible XTF ↔ ISO conversion, only accept:
- Midnight timestamps: `2019-09-30T00:00:00.0` or `2019-09-30T00:00:00`
- Date-only: `2019-09-30`
- Other timestamps: `2019-09-30T14:30:00.0` (TIME LOST in round-trip)

**Current Status**:
| Direction | File | Status |
|-----------|------|--------|
| XTF → ISO | [CI_Date.xsl](src/main/plugin/iso19115-3.2018.che/convert/eCH-0271/mapping/CI_Date.xsl) | ⚠️ Accepts ANY timestamp (no validation) |
| ISO → XTF | toECH0271.xsl | ✅ Reconstructs date-only correctly |

**Implementation Needed** (in CI_Date.xsl):
```xsl
<xsl:when test="contains($dateValue, 'T')">
  <xsl:variable name="timeValue" select="substring-after($dateValue, 'T')"/>
  <xsl:choose>
    <xsl:when test="$timeValue = '00:00:00.0' or $timeValue = '00:00:00'">
      <gco:Date><xsl:value-of select="substring-before($dateValue, 'T')"/></gco:Date>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">ERROR: Non-midnight timestamp in eCH-0271 XTF violates bijection constraint</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:when>
```

### 7. Citation Date Resolution

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

| eCH-0271 Element | iso19115-3.2018.che Element | Transformation Details |
|-----------------|-------------------|-------|
| `metadataIdentifier[@ili:ref]` | `mdb:metadataIdentifier` → `mcc:MD_Identifier` | Resolve @ili:ref to target object |
| `defaultLocale` | `mdb:defaultLocale` → `lan:PT_Locale` | Includes language + charset |
| `metadataScope[@ili:ref]` | `mdb:metadataScope` → `mdb:MD_MetadataScope` | Dataset/series/model scope |
| `contact[@ili:ref]` | `mdb:contact` → `cit:CI_Responsibility` | Metadata custodian/contact |
| `dateInfo` | `mdb:dateInfo` → `cit:CI_Date` | Must validate midnight constraint |
| `standardUsedBymetadataStandard[@ili:ref]` | `mdb:metadataStandard` → `cit:CI_Citation` | iso19115-3.2018.che standard |
| `referenceSystemInfo[@ili:ref]` | `mdb:referenceSystemInfo` → `mrs:MD_ReferenceSystem` | CRS/EPSG reference |
| `identificationInfo[@ili:ref]` | `mdb:identificationInfo` → `mri:MD_DataIdentification` | Dataset description |
| `distributionInfo[@ili:ref]` | `mdb:distributionInfo` → `mrd:MD_Distribution` | Online/offline access |
| `legislationInformation[@ili:ref]` | `mdb:contentInfo` | Swiss legal metadata |

### Dataset Identification Level (CHE_MD_DataIdentification)

| eCH-0271 Element | iso19115-3.2018.che Element | Transformation Details |
|-----------------|-------------------|-------|
| `citation[@ili:ref]` | `mri:citation` → `cit:CI_Citation` | Resolve dates via key lookup |
| `abstract` | `mri:abstract` → `gco:CharacterString` | Text or multilingual |
| `status` | `mri:status` → `mcc:MD_ProgressCode` | Progress code from codelist |
| `pointOfContact[@ili:ref]` | `mri:pointOfContact` → `cit:CI_Responsibility` | Resource contact |
| `topicCategory` | `mri:topicCategory` → `mri:MD_TopicCategoryCode` | ISO topic code |
| `extent[@ili:ref]` | `mri:extent` → `gex:EX_Extent` | Geographic + temporal bounds |
| `resourceMaintenance[@ili:ref]` | `mri:resourceMaintenance` → `mmi:MD_MaintenanceInformation` | Use mmi: namespace |
| `graphicOverview[@ili:ref]` | `mri:graphicOverview` → `mrd:MD_BrowseGraphic` | Thumbnail URL |
| `resourceConstraints[@ili:ref]` | `mri:resourceConstraints` → `mco:MD_LegalConstraints` | Legal/access constraints |
| `defaultLocale` | `mri:defaultLocale` → `lan:PT_Locale` | Dataset language |
| `basicGeodata` | `che:basicGeodata` → `gco:Boolean` | Swiss flag |
| `basicGeodataInformation` | `che:basicGeodataInformation` → `che:CHE_MD_BasicGeodataInformation` | Swiss extension |

### Resource Maintenance

Implementation structure for resource maintenance with iso19115-3.2018.che compliance:

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

## Code Structure

The complete eCH0271 ↔ iso19115-3.2018.che implementation is organized as follows:

```
src/main/plugin/iso19115-3.2018.che/
├── convert/
│   ├── fromECH0271-XTF.xsl                # GeoNetwork integration wrapper (entry point for XTF import)
│   │                                       # [TODO: Rename from current fromECH0271.xsl]
│   ├── toECH0271-XTF.xsl                  # GeoNetwork integration wrapper (entry point for XTF export)
│   │
│   └── eCH-0271/
│       ├── fromECH0271-XTF.xsl            # Main engine: eCH-0271 XTF → iso19115-3.2018.che (~509 lines)
│       ├── toECH0271-XTF.xsl              # Main engine: iso19115-3.2018.che → eCH-0271 XTF (~770 lines)
│       │
│       ├── mapping/                       # Hand-maintained XSLT transformation templates (12 files)
│       │   ├── CHE_MD_Metadata.xsl        # Metadata root element transformation
│       │   ├── CHE_MD_DataIdentification.xsl
│       │   ├── CHE_MD_Legislation.xsl
│       │   ├── CHE_MD_MaintenanceInformation.xsl
│       │   ├── CI_Citation.xsl
│       │   ├── CI_Date.xsl
│       │   ├── CI_Identifier.xsl
│       │   ├── CI_Responsibility.xsl
│       │   ├── EX_Extent.xsl
│       │   ├── MD_Distribution.xsl
│       │   └── PT_Locale.xsl
│       │
│       └── utility/                       # Hand-maintained helper templates (4 files)
│           ├── multilingual-text.xsl      # Localized text handling
│           ├── dateTime.xsl               # Date/datetime formatting
│           ├── multiLingualCharacterStrings.xsl  # Legacy multilingual support
│           └── create19115-3Namespaces.xsl  # Namespace declarations
│
├── schema/
│   └── standards.iso.org/19115/-3/
│       └── eCH-0271-1-0-0.xsd             # eCH-0271 INTERLIS schema (authoritative source)
│
├── formatter/ech0271/
│   ├── view.xsl                           # UI rendering template
│   └── config.properties                  # Formatter configuration
│
└── java/src/org/fao/geonet/schema/
    └── Ech0271ToMefImporter.java          # Batch importer: XTF records → MEF v2 ZIP
```

### File Organization Notes

**Wrapper vs Engine**:
- Top-level `convert/*.xsl`: GeoNetwork integration wrappers (simple imports)
- `convert/eCH-0271/*.xsl`: Core transformation engines (production logic)

**Source vs Derived**:
| File/Folder | Type | Management |
|------------|------|------------|
| `mapping/*.xsl` | **Source** | Hand-maintained by developers |
| `utility/*.xsl` | **Source** | Hand-maintained by developers |
| `schema/eCH-0271-1-0-0.xsd` | **Source** | Single authoritative copy (XSD specification) |
| `formatter/` | **Source** | Hand-maintained configuration |
| Java importer | **Source** | Hand-maintained code |

**[TODO] Recommended Renaming**:
- `convert/fromECH0271.xsl` → `convert/fromECH0271-XTF.xsl` (clarity: input is XTF format)
- `convert/eCH-0271/fromECH0271.xsl` → `convert/eCH-0271/fromECH0271-XTF.xsl` (consistency)
- Existing `convert/eCH-0271/toECH0271.xsl` → `convert/eCH-0271/toECH0271-XTF.xsl` (clarity: output is XTF format)
- Add wrapper: `convert/toECH0271-XTF.xsl` (symmetry with fromECH0271-XTF)

### Implementation Components

**1. fromECH0271-XTF** - Forward Transformation (eCH-0271 XTF → iso19115-3.2018.che)
- **Wrapper**: `convert/fromECH0271-XTF.xsl` - Thin GeoNetwork integration layer (xsl:import only)
- **Engine**: `convert/eCH-0271/fromECH0271-XTF.xsl` - Core logic (~509 lines, xsl:include directives)
  - Features: Reference resolution via xsl:key, single/multiple record support, namespace binding
  - Includes 12 mapping templates + 4 utility templates
- **Data Inputs**: Single or multiple eCH-0271 XTF files (INTERLIS 2.4 format)
- **Output**: CHE_MD_Metadata XML (iso19115-3.2018.che compliant)

**2. toECH0271-XTF** - Reverse Transformation (iso19115-3.2018.che → eCH-0271 XTF)
- **Wrapper**: `convert/toECH0271-XTF.xsl` - Thin GeoNetwork integration layer (planned)
- **Engine**: `convert/eCH-0271/toECH0271-XTF.xsl` - Core logic (~770 lines, standalone)
  - Features: Flat INTERLIS structure generation, @ili:tid/@ili:ref linking, XTF 2.4 compliance
  - No external dependencies (self-contained transformation)
- **Data Inputs**: iso19115-3.2018.che XML metadata
- **Output**: eCH-0271 XTF (INTERLIS 2.4 format)
- **Note**: Bijection constraint enforced for date handling (midnight timestamps only)

**3. Ech0271ToMefImporter** - Transform to MEF v2 (eCH-0271 XTF → GeoNetwork MEF v2 Package) -> can be renamed as **Ech0271
- **File**: `java/src/org/fao/geonet/schema/Ech0271ToMefImporter.java` (name is legacy; class exports MEF, not imports)
- **Purpose**: Convert eCH-0271 XTF records into GeoNetwork MEF v2 ZIP packages
  - **Input**: Single or multiple eCH-0271 XTF records (INTERLIS 2.4)
  - **Output**: MEF v2 ZIP structure (ready for GeoNetwork batch import)
- **Public Methods**:
  - `transformSingle(Path xtfFile)`: Single XTF → CHE_MD_Metadata XML element
  - `transformToMefZip(Path xtfFile)`: Single/Multiple XTF → MEF v2 ZIP bytes (auto-detects)
  - `transformToMefZipFile(Path xtfFile, File output)`: Single/Multiple XTF → MEF v2 ZIP file
- **MEF v2 Structure Generated**:
  ```
  mef.zip
  └── {uuid}/
      ├── metadata/metadata.xml  (CHE_MD_Metadata)
      └── info.xml              (MEF metadata header)
  ```
- **Use Case**: Batch workflow to prepare eCH-0271 records for GeoNetwork import

**4. Formatter** - Display & Configuration
- **XSLT**: `formatter/ech0271/view.xsl` - Renders eCH-0271 metadata in GeoNetwork UI
- **Config**: `formatter/ech0271/config.properties` - Formatter settings

## Utility Templates

The `convert/eCH-0271/utility/` directory contains four hand-maintained XSLT helper templates:

### 1. multilingual-text.xsl

**Purpose**: Extract eCH-0271 multilingual text structures during XTF → ISO transformation.

**Scope**: One-way transformation (**XTF→ISO only**)
- **Input**: eCH-0271 `Localisation_V2:MultilingualMText` or `LocalisationCH_V2:MultilingualMText`
- **Output**: ISO `gco:CharacterString` (primary language only)
- **Limitation**: Only extracts first language entry; additional languages are **discarded** (information loss)
- **Rationale**: eCH-0271 multilingual structures are semantically richer than ISO 19115-3 `gco:CharacterString`; full round-trip preservation is not possible

**Key Functions**:
- Extracts text from `Localisation_V2:MultilingualMText` and `LocalisationCH_V2:MultilingualMText`
- Outputs `gco:CharacterString` with primary language (first entry)
- Handles nested language-specific entries with language codes
- Normalizes whitespace
- **Used by**: fromECH0271-XTF transformation (citation, abstract, title)

**Template Mode**: `mode="multilingual-text"`

**Inverse Direction (ISO→XTF)**: Not used. Instead, `toECH0271.xsl` reconstructs hardcoded Localisation_V2 structure with default language (French)

### 2. dateTime.xsl

**Status**: Legacy/Unused - **NOT used by eCH-0271 transformations**

**Purpose** (Historical): Transform ISO 19139 datetime formats to iso19115-3.2018.che (legacy schema conversion)

**Context**: 
- Designed for ISO 19139 → iso19115-3.2018.che transformations (`gcoold:` namespace → `gco:` namespace)
- Separate from eCH-0271 workflow
- eCH-0271 fromECH0271 and toECH0271 handle dates **inline** without referencing this utility
- See `convert/ISO19139/utility/dateTime.xsl` for active ISO 19139 conversions

**Current eCH-0271 Date Handling**:
- **XTF→ISO**: Handled inline in `mapping/CI_Date.xsl` (direct datetime formatting)
- **ISO→XTF**: Handled inline in `toECH0271.xsl` (hardcoded Localisation_V2 structure reconstruction)

**Recommendation**: Consider removing from eCH-0271/utility (consolidate with ISO19139 version)

### 3. create19115-3Namespaces.xsl

**Purpose**: Centralizes all iso19115-3.2018.che module namespace declarations.

**Key Functions**:
- Defines 30+ namespace bindings for iso19115-3.2018.che modules: `mdb`, `mri`, `cit`, `gex`, `mcc`, `mco`, `mmi`, `lan`, `srv`, `mrs`, etc.
- Includes XML Schema instance (`xsi`) namespace for type attributes
- Provides single source of truth for namespace prefixes
- Ensures consistent XML document structure across all outputs
- **Critical for**: Proper iso19115-3.2018.che schema validation

**Template Name**: `add-iso19115-3.2018-namespaces`

### 4. multiLingualCharacterStrings.xsl

**Status**: Legacy/Unused - **NOT used by eCH-0271 transformations**

**Purpose** (Historical): Handle multilingual text in ISO 19139 → iso19115-3.2018.che conversions

**Context**:
- Designed for ISO 19139 → iso19115-3.2018.che legacy schema conversions
- Transforms `gmd:` (ISO 19139) → `gco:` / `lan:` (iso19115-3.2018.che) namespaces
- eCH-0271 transformations use dedicated **multilingual-text.xsl** instead (for eCH-0271 `Localisation_V2` structures)
- See `convert/ISO19139/utility/multiLingualCharacterStrings.xsl` for active ISO 19139 conversions

**Current eCH-0271 Multilingual Handling**:
- **XTF→ISO**: `utility/multilingual-text.xsl` (extracts from Localisation_V2 → gco:CharacterString)
- **ISO→XTF**: `toECH0271.xsl` inline (reconstructs hardcoded Localisation_V2 structure)

**Recommendation**: Consider removing from eCH-0271/utility (consolidate with ISO19139 version)

## Asymmetric Transformation Design

### Why Forward and Reverse Transformations Differ

The eCH-0271 ↔ iso19115-3.2018.che bidirectional transformations are **intentionally asymmetric** due to structural incompatibilities:

#### 1. **Multilingual Text Handling** (Most Significant Asymmetry)

| Aspect | Forward (XTF→ISO) | Reverse (ISO→XTF) |
|--------|------|------|
| **Input Structure** | eCH-0271 `Localisation_V2:MultilingualMText` (language-keyed, multi-language native) | ISO `gco:CharacterString` (primary string only) + `lan:PT_FreeText` (optional extended) |
| **Transformation** | Extract first language only via `utility/multilingual-text.xsl` | **Hardcoded reconstruction** in `toECH0271.xsl` with default language (French) |
| **Information Loss** | **YES**: Only first language preserved; remaining languages discarded | **YES**: Cannot reconstruct multiple languages from ISO structure; forced to default |
| **Rationale** | eCH-0271 multilingual model (per-language records) is richer than ISO; round-trip is impossible without external metadata | ISO does not encode language selection metadata; reconstruction requires assumptions |
| **Consequence** | XTF→ISO→XTF cycle loses multilingual information | ISO→XTF→ISO cycle loses multilingual information |

**Key Constraint**: **Bijection constraint applies only to timestamps, not multilingual preservation**. Multilingual data is not recoverable in either direction; only single-language (primary) or default-language workflows are guaranteed fidelity.

#### 2. **Date/Time Formatting** (Separate from Bijection)

| Aspect | Forward (XTF→ISO) | Reverse (ISO→XTF) |
|--------|------|------|
| **Utility Template** | Historical `dateTime.xsl` (unused) | Historical `dateTime.xsl` (unused) |
| **Actual Implementation** | Inline in `mapping/CI_Date.xsl` (direct datetime to `gco:Date`/`gco:DateTime`) | Inline in `toECH0271.xsl` (hardcoded XTF datetime reconstruction) |
| **Bijection Enforcement** | Validates timestamps are midnight-only (T00:00:00.0) or date-only → guarantees round-trip fidelity | Accepts any ISO datetime but may alter precision when encoding into XTF |

#### 3. **Reference Resolution**

| Aspect | Forward (XTF→ISO) | Reverse (ISO→XTF) |
|--------|------|------|
| **Input References** | eCH-0271 @ili:ref external references (flat structure) | ISO hierarchy-based nested structure (mdb:, mri:, etc. elements) |
| **Transformation** | Resolves via `xsl:key` lookup against current XTF basket; creates ISO nested hierarchy | Flattens ISO hierarchy back into eCH-0271 basket with @ili:tid/@ili:ref | 
| **Dependency** | Requires xsl:key function + multi-pass processing | Self-contained single-pass transformation |
| **Rationale** | XTF basket is flat; ISO expects hierarchical containment; resolution is semantic alignment | ISO nesting is unambiguous; flattening to XTF requires ID generation |

#### 4. **Derived vs Source Files** (Code Organization Asymmetry)

| Aspect | Forward | Reverse |
|--------|---------|---------|
| **Wrapper** | `convert/fromECH0271-XTF.xsl` (GeoNetwork entry point) | `convert/toECH0271-XTF.xsl` (not yet created - [TODO]) |
| **Engine** | `convert/eCH-0271/fromECH0271-XTF.xsl` (~509 lines) | `convert/eCH-0271/toECH0271-XTF.xsl` (~770 lines) |
| **Included Templates** | 12 mapping + 4 utility = 16 includes | 0 includes (self-contained) |
| **Modularity** | High (reusable templates per element type) | Low (monolithic inline generation) |
| **Maintenance Cost** | Higher (distributed logic) | Lower (single point of change) |
| **Rationale** | Forward transformation is more complex (reference resolution) → benefits from modular templates | Reverse transformation is deterministic (ID generation, flat structure) → monolithic is acceptable |

### Design Decisions & Implications

**1. Single-Language Preservation**
- To avoid data loss, applications should:
  - For XTF→ISO: Extract language preferences upfront; store in ISO metadata header
  - For ISO→XTF: Specify target language parameter; assume default if unspecified
- See Bijection Constraint documentation (Section 6) for timestamp-specific round-trip requirements

**2. Monolithic Reverse Engine**
- `toECH0271.xsl` (~770 lines) intentionally avoids modular includes to:
  - Reduce template name collision risk across 12 mapping files
  - Ensure deterministic ID generation (generate-id functions are evaluated in single context)
  - Simplify deployment (single file to review vs 16 distributed files)
- Trade-off: Harder to extend; requires manual template editing

**3. Future Improvements**
- Potential symmetric redesign (modularize toECH0271.xsl) would require:
  - Centralizing ID generation strategy (currently inline, scattered generate-id calls)
  - Resolving template name conflicts (mapping/*.xsl files define templates like `matchMetadata`)
  - Validating that modularity doesn't break XTF @ili:tid determinism (hard requirement)

## Testing

### Test Classes

**`Ech0271ToIso19115cheConversionTest.java`** - Forward transformation validation
- Test Methods:
  - `convertDronesVdEch0271()` - Single record forward transformation
  - `convertTestMef3RecordsEch0271()` - Multi-record (3 records) forward transformation
  - `convertTestMef2RecordsEch0271()` - Multi-record (2 records: roads, forests) forward transformation
  - `transformMultipleRecordsToMefZip()` - MEF v2 ZIP generation (3 records)
  - `transformTestMef2RecordsToMefZip()` - MEF v2 ZIP generation (2 records)

**`Iso19115cheToEch0271ConversionTest.java`** - Reverse transformation validation
- Test Methods:
  - `convertDronesVdIso19115cheToEch0271()` - Single record reverse transformation

### Test Samples

All test data files are located in `src/test/resources/`:

| File | Description | Purpose |
|------|-------------|----------|
| `drones_vd.xtf` | **Input**: Original eCH0271 XTF 2.4 file | Source metadata (Vaud drone restrictions dataset - single record) |
| `drones_vd-to-iso19115-3.che.xml` | **Output**: Result of `fromECH0271` transformation | Forward conversion validation (eCH0271 → iso19115-3.2018.che) |
| `drones_vd-target-to-iso19115-3.che.xml` | **Reference**: Golden copy from geocat.ch | Byte-comparison validation against authoritative source |
| `drones_vd-reverse-to-ech0271.xtf` | **Output**: Result of `toECH0271` transformation | Reverse conversion validation (ISO → eCH0271, round-trip) |
| `test_mef_xtf_2records.xtf` | **Test**: Multi-record XTF basket | 2-record test: roads + forests datasets |
| `test_mef_xtf_3records.xtf` | **Test**: Multi-record XTF basket | 3-record test: Multiple metadata records |

**Reference**: The `drones_vd-target-to-iso19115-3.che.xml` corresponds to the geocat.ch metadata record:
https://www.geocat.ch/geonetwork/srv/eng/catalog.search#/metadata/2d0af163-1f59-9a24-35fa-1e03166e6188

## Related Documentation & Resources

### Standards & Specifications
- **eCH-0271 Swiss Standard** - https://www.ech.ch/fr/ech/ech-0271/1.1.0
- **INTERLIS Standard** - https://www.interlis.ch/

### Tools & Validation
- **INTERLIS Validator (ilivalidator)** - https://www.interlis.ch/fr/downloads/ilivalidator

### Schema & Reference Files
- **eCH-0271 INTERLIS Schemas & Code Lists** - https://github.com/metadata101/iso19115-3.2018.che/tree/interlis-converter-ech0271-4.4.12/src/main/plugin/iso19115-3.2018.che/eCH-0271-INTERLIS
- **Local eCH-0271-INTERLIS Directory** - `src/main/plugin/iso19115-3.2018.che/eCH-0271-INTERLIS/`
- **ISO TC211 Namespaces** - http://standards.iso.org/iso/19115/-3/

### Related Mappings
- [DCAT-AP-CH Mapping](./DCAT-AP-CH-MAPPING.md) - DCAT-AP-CH to iso19115-3.2018.che mapping
- [ISO19139 to ISO19115-3 Conversion](./ISO19139-to-ISO19115-3-2018.xsl) - Legacy ISO19139 conversion

### GeoNetwork & Community
- **GeoNetwork Project** - https://geonetwork-opensource.org/
- **core-geonetwork Repository** - https://github.com/geonetwork/core-geonetwork
- **Metadata101 Schema Plugins** - https://github.com/metadata101   - Input: Single or multiple eCH-0271 XTF records