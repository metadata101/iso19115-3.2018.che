package org.fao.geonet.schema;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.util.List;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.Namespace;

/**
 * Convert eCH0271 XTF 2.4 to MEF v2 format for GeoNetwork batch import.
 * 
 * Auto-detects single vs multiple metadata and packages appropriately:
 * - Single record: Returns ISO 19115-3:2018 CHE XML
 * - Multiple records: Packages into MEF v2 ZIP structure
 * 
 * MEF (Metadata Exchange Format) v2 structure:
 * <pre>
 * mef.zip
 * ├── {uuid-1}/
 * │   ├── metadata/metadata.xml       (ISO 19115-3:2018 CHE XML)
 * │   └── info.xml                    (MEF v2 metadata)
 * ├── {uuid-2}/
 * │   ├── metadata/metadata.xml
 * │   └── info.xml
 * └── {uuid-N}/
 *     ├── metadata/metadata.xml
 *     └── info.xml
 * </pre>
 */
public class Ech0271ToMefImporter {

    private Path xslFilePath;

    /**
     * Initialize the importer with the eCH0271 → ISO CHE transformation XSLT.
     * Locates fromECH0271.xsl from the schema plugin (production) or from path (testing).
     */
    public Ech0271ToMefImporter() throws Exception {
        this(null);
    }

    /**
     * Initialize with optional XSLT path.
     * 
     * @param xslPath Optional path to fromECH0271.xsl (used by tests)
     * @throws Exception if initialization fails
     */
    public Ech0271ToMefImporter(Path xslPath) throws Exception {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
        
        if (xslPath != null && new File(xslPath.toString()).exists()) {
            this.xslFilePath = xslPath;
        } else {
            // Try to locate from classpath
            try {
                java.net.URL xslResource = this.getClass().getResource(
                    "/convert/eCH-0271/fromECH0271.xsl");
                if (xslResource != null) {
                    this.xslFilePath = new File(xslResource.toURI()).toPath();
                    if (!new File(xslFilePath.toString()).exists()) {
                        this.xslFilePath = null;
                    }
                }
            } catch (java.net.URISyntaxException e) {
                this.xslFilePath = null;
            }
        }
    }

    /**
     * Transform single eCH0271 XTF to ISO 19115-3:2018 CHE XML.
     * 
     * @param xtfFile Path to eCH0271 XTF 2.4 file
     * @return CHE_MD_Metadata Element
     * @throws Exception if transformation fails
     */
    public Element transformSingle(Path xtfFile) throws Exception {
        if (xslFilePath == null) {
            throw new IllegalStateException("XSLT file not found: fromECH0271.xsl");
        }
        
        Element source = Xml.loadFile(xtfFile);
        return Xml.transform(source, xslFilePath);
    }

    /**
     * Transform eCH0271 XTF to MEF v2 ZIP or XML depending on record count.
     * 
     * Auto-detects single vs multiple metadata:
     * - Single: returns MEF ZIP with one record (or XML directly via transformSingle)
     * - Multiple: returns MEF v2 ZIP with N records
     * 
     * @param xtfFile Path to eCH0271 XTF 2.4 file
     * @return MEF v2 ZIP bytes (always ZIP, even for single records)
     * @throws Exception if transformation fails
     */
    public byte[] transformToMefZip(Path xtfFile) throws Exception {
        if (xslFilePath == null) {
            throw new IllegalStateException("XSLT file not found: fromECH0271.xsl");
        }
        
        // Transform XTF → CHE XML or root wrapper
        Element source = Xml.loadFile(xtfFile);
        Element transformed = Xml.transform(source, xslFilePath);
        
        ByteArrayOutputStream zipBytes = new ByteArrayOutputStream();
        ZipOutputStream zipOut = new ZipOutputStream(zipBytes);
        
        try {
            if (transformed.getName().equals("CHE_MD_Metadata")) {
                // Single record: add to ZIP
                addMetadataToZip(zipOut, transformed, UUID.randomUUID().toString());
            } else if (transformed.getName().equals("root")) {
                // Multiple records: wrapper container from XSLT transformation
                // Extract all CHE_MD_Metadata children (they have namespace http://geocat.ch/che)
                Namespace cheNs = Namespace.getNamespace("http://geocat.ch/che");
                @SuppressWarnings("unchecked")
                List<Element> metadataRecords = transformed.getChildren("CHE_MD_Metadata", cheNs);
                
                if (metadataRecords.isEmpty()) {
                    throw new IllegalArgumentException(
                        "Root element contains no CHE_MD_Metadata children");
                }
                
                for (Element metadata : metadataRecords) {
                    String uuid = UUID.randomUUID().toString();
                    addMetadataToZip(zipOut, metadata, uuid);
                }
            } else {
                throw new IllegalArgumentException(
                    "Unexpected root element: " + transformed.getName() + 
                    ". Expected CHE_MD_Metadata or root (multiple records container)");
            }
        } finally {
            zipOut.close();
        }
        
        return zipBytes.toByteArray();
    }

    /**
     * Export MEF v2 ZIP to file.
     * 
     * @param xtfFile Path to eCH0271 XTF 2.4 file
     * @param outputZip File where MEF v2 ZIP will be written
     * @throws Exception if transformation or export fails
     */
    public void transformToMefZipFile(Path xtfFile, File outputZip) throws Exception {
        byte[] mefZip = transformToMefZip(xtfFile);
        try (FileOutputStream fos = new FileOutputStream(outputZip)) {
            fos.write(mefZip);
        }
    }

    /**
     * Add metadata record to ZIP with MEF v2 structure.
     * Creates {uuid}/metadata/metadata.xml and {uuid}/info.xml
     */
    private void addMetadataToZip(ZipOutputStream zipOut, Element metadata, String uuid) throws Exception {
        String metadataXml = Xml.getString(metadata);
        
        // Add metadata/metadata.xml
        String metadataPath = uuid + "/metadata/metadata.xml";
        zipOut.putNextEntry(new ZipEntry(metadataPath));
        zipOut.write(metadataXml.getBytes(StandardCharsets.UTF_8));
        zipOut.closeEntry();
        
        // Add info.xml with MEF v2 structure
        String infoXml = generateMefInfoXml(uuid, metadata);
        String infoPath = uuid + "/info.xml";
        zipOut.putNextEntry(new ZipEntry(infoPath));
        zipOut.write(infoXml.getBytes(StandardCharsets.UTF_8));
        zipOut.closeEntry();
    }

    /**
     * Generate MEF v2 info.xml content with version="0.1" attribute.
     * MEF v2 structure requires: version, general (uuid, title, doctype, dates, schemaid), 
     * categories, public (files), private (files), privileges
     */
    private String generateMefInfoXml(String uuid, Element metadata) {
        String title = extractTitle(metadata);
        if (title == null || title.isEmpty()) {
            title = "Metadata " + uuid;
        }
        
        return String.format(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
            "<info version=\"0.1\">\n" +
            "  <general>\n" +
            "    <uuid>%s</uuid>\n" +
            "    <title>%s</title>\n" +
            "    <doctype>metadata</doctype>\n" +
            "    <schemaid>iso19115-3.2018.che</schemaid>\n" +
            "    <createDate>%s</createDate>\n" +
            "    <changeDate>%s</changeDate>\n" +
            "    <isTemplate>n</isTemplate>\n" +
            "  </general>\n" +
            "  <categories/>\n" +
            "  <public/>\n" +
            "  <private/>\n" +
            "  <privileges>\n" +
            "    <group id=\"1\">\n" +
            "      <operation name=\"view\" />\n" +
            "      <operation name=\"download\" />\n" +
            "    </group>\n" +
            "  </privileges>\n" +
            "</info>",
            uuid, 
            escapeXml(title),
            getCurrentTimestamp(),
            getCurrentTimestamp());
    }

    /**
     * Extract title from CHE metadata if available.
     * Searches: identificationInfo/CHE_MD_DataIdentification/citation/CI_Citation/title/CharacterString
     */
    private String extractTitle(Element metadata) {
        try {
            // Try to find title in identificationInfo/CHE_MD_DataIdentification/citation
            Namespace mdbNs = Namespace.getNamespace("http://standards.iso.org/iso/19115/-3/mdb/2.0");
            Namespace cheNs = Namespace.getNamespace("http://geocat.ch/che");
            Namespace citNs = Namespace.getNamespace("http://standards.iso.org/iso/19115/-3/cit/2.0");
            Namespace gcoNs = Namespace.getNamespace("http://standards.iso.org/iso/19115/-3/gco/1.0");
            
            Element identification = metadata.getChild("identificationInfo", mdbNs);
            if (identification != null) {
                Element dataIdent = identification.getChild("CHE_MD_DataIdentification", cheNs);
                if (dataIdent != null) {
                    Element citation = dataIdent.getChild("citation", citNs);
                    if (citation != null) {
                        Element ciCitation = citation.getChild("CI_Citation", citNs);
                        if (ciCitation != null) {
                            Element title = ciCitation.getChild("title", citNs);
                            if (title != null) {
                                // Title is wrapped in CharacterString element
                                Element charString = title.getChild("CharacterString", gcoNs);
                                if (charString != null) {
                                    String titleText = charString.getText();
                                    if (titleText != null && !titleText.trim().isEmpty()) {
                                        return titleText.trim();
                                    }
                                }
                                // Fallback: try direct text if no CharacterString
                                String titleText = title.getText();
                                if (titleText != null && !titleText.trim().isEmpty()) {
                                    return titleText.trim();
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            // Fall back to default
        }
        return null;
    }

    /**
     * Get current timestamp in ISO 8601 UTC format (required by MEF).
     */
    private String getCurrentTimestamp() {
        java.time.ZonedDateTime now = java.time.ZonedDateTime.now(java.time.ZoneId.of("UTC"));
        return now.format(java.time.format.DateTimeFormatter.ISO_INSTANT);
    }

    /**
     * Escape XML special characters.
     */
    private String escapeXml(String str) {
        if (str == null) return "";
        return str
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&apos;");
    }
}
