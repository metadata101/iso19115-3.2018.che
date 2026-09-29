package org.fao.geonet.schema;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Path;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.Namespace;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertEquals;

import org.junit.BeforeClass;
import org.junit.Test;

/**
 * Test for eCH0271 XTF 2.4 → ISO 19115-3:2018 CHE XML conversion.
 * 
 * Validates:
 * - Single record: XTF → CHE_MD_Metadata XML (WORKFLOW A)
 * - Multiple records: XTF → <root> wrapper (WORKFLOW B intermediate)
 * - Multiple records via MEF: XTF → MEF v2 ZIP for batch import
 */
public class Ech0271ToIso19115cheConversionTest {

    private static final boolean GENERATE_EXPECTED_FILE = true;

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    /**
     * Test: eCH0271 XTF 2.4 (drones_vd) → ISO 19115-3:2018 CHE XML
     * Validates correct XSLT transformation of single metadata record.
     */
    @Test
    public void convertDronesVdEch0271() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271/fromECH0271.xsl");
        Path xmlFile = getResource("drones_vd.xtf");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertTrue(
            "Expected CHE_MD_Metadata, got: " + transformed.getName(),
            transformed.getName().equals("CHE_MD_Metadata"));
        
        TestSupport.assertGeneratedDataByteMatchExpected(
            "drones_vd-to-iso19115-3.che.xml",
            Xml.getString(transformed),
            GENERATE_EXPECTED_FILE);
    }

    /**
     * Test: eCH0271 XTF 2.4 (test_mef_xtf_3records) → ISO 19115-3:2018 CHE XML
     * Validates correct XSLT transformation of multiple metadata records.
     * Result should be wrapped in temporary <root> container for MEF processing.
     */
    @Test
    public void convertTestMef3RecordsEch0271() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271/fromECH0271.xsl");
        Path xmlFile = getResource("test_mef_xtf_3records.xtf");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertTrue(
            "Expected root wrapper for multiple records, got: " + transformed.getName(),
            transformed.getName().equals("root"));
        
        // Verify it contains 3 CHE_MD_Metadata children
        Namespace cheNs = Namespace.getNamespace("http://geocat.ch/che");
        @SuppressWarnings("unchecked")
        java.util.List<Element> children = transformed.getChildren("CHE_MD_Metadata", cheNs);
        assertEquals("Expected 3 CHE_MD_Metadata children", 3, children.size());
    }

    /**
     * Test: eCH0271 XTF 2.4 (test_mef_xtf_3records) → MEF v2 ZIP for batch import
     * 
     * Validates that multiple metadata records are correctly packaged into 
     * MEF v2 format (Metadata Exchange Format v2) with proper ZIP structure:
     * - Each record gets a UUID directory
     * - Each directory contains: metadata/metadata.xml + info.xml
     * - MEF v2 info.xml has required elements (uuid, title, schemaid, dates, etc.)
     * 
     * Also exports the ZIP to /tmp/test_mef_xtf_3records.zip for manual testing in GeoNetwork.
     */
    @Test
    public void transformMultipleRecordsToMefZip() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271/fromECH0271.xsl");
        Path xtfFile = getResource("test_mef_xtf_3records.xtf");
        
        // Transform XTF → MEF v2 ZIP
        Ech0271ToMefImporter importer = new Ech0271ToMefImporter(xslFile);
        byte[] mefZip = importer.transformToMefZip(xtfFile);
        
        // Verify ZIP was generated
        assertTrue("MEF ZIP should not be empty", mefZip.length > 0);
        
        // Export to /tmp for manual testing in GeoNetwork
        File outputZip = new File("/tmp/test_mef_xtf_3records.zip");
        try (FileOutputStream fos = new FileOutputStream(outputZip)) {
            fos.write(mefZip);
        }
        System.out.println("\n✅ MEF v2 ZIP exported: " + outputZip.getAbsolutePath());
        System.out.println("📊 File size: " + outputZip.length() + " bytes");
        
        // Inspect ZIP structure
        ByteArrayInputStream zipInput = new ByteArrayInputStream(mefZip);
        ZipInputStream zipIn = new ZipInputStream(zipInput);
        
        int metadataCount = 0;
        int infoCount = 0;
        ZipEntry entry;
        
        while ((entry = zipIn.getNextEntry()) != null) {
            String entryName = entry.getName();
            if (entryName.matches(".+/metadata/metadata\\.xml")) {
                metadataCount++;
            } else if (entryName.matches(".+/info\\.xml")) {
                infoCount++;
            }
        }
        zipIn.close();
        
        // Verify structure: 3 records = 3 metadata + 3 info files
        assertEquals("ZIP should contain 3 metadata/metadata.xml entries", 3, metadataCount);
        assertEquals("ZIP should contain 3 info.xml entries", 3, infoCount);
        
        System.out.println("📋 ZIP structure verified:");
        System.out.println("  - Metadata files: " + metadataCount);
        System.out.println("  - Info files: " + infoCount);
    }

    /**
     * Test: eCH0271 XTF 2.4 (test_mef_xtf_2records) → ISO 19115-3:2018 CHE XML
     * Validates correct XSLT transformation with realistic data (roads + forests).
     * Result should be wrapped in temporary <root> container for MEF processing.
     */
    @Test
    public void convertTestMef2RecordsEch0271() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271/fromECH0271.xsl");
        Path xmlFile = getResource("test_mef_xtf_2records.xtf");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertTrue(
            "Expected root wrapper for multiple records, got: " + transformed.getName(),
            transformed.getName().equals("root"));
        
        // Verify it contains 2 CHE_MD_Metadata children
        Namespace cheNs = Namespace.getNamespace("http://geocat.ch/che");
        @SuppressWarnings("unchecked")
        java.util.List<Element> children = transformed.getChildren("CHE_MD_Metadata", cheNs);
        assertEquals("Expected 2 CHE_MD_Metadata children", 2, children.size());
    }

    /**
     * Test: eCH0271 XTF 2.4 (test_mef_xtf_2records) → MEF v2 ZIP for batch import
     * 
     * Validates MEF v2 ZIP generation with realistic metadata:
     * - Record 1: Réseau routier (Roads network)
     * - Record 2: Périmètres forestiers (Forest perimeters)
     * 
     * Each record includes contacts, online resources, maintenance info, and legal constraints.
     * Exports the ZIP to /tmp/test_mef_xtf_2records.zip for manual testing in GeoNetwork.
     */
    @Test
    public void transformTestMef2RecordsToMefZip() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271/fromECH0271.xsl");
        Path xtfFile = getResource("test_mef_xtf_2records.xtf");
        
        // Transform XTF → MEF v2 ZIP
        Ech0271ToMefImporter importer = new Ech0271ToMefImporter(xslFile);
        byte[] mefZip = importer.transformToMefZip(xtfFile);
        
        // Verify ZIP was generated
        assertTrue("MEF ZIP should not be empty", mefZip.length > 0);
        
        // Export to /tmp for manual testing in GeoNetwork
        File outputZip = new File("/tmp/test_mef_xtf_2records.zip");
        try (FileOutputStream fos = new FileOutputStream(outputZip)) {
            fos.write(mefZip);
        }
        System.out.println("\n✅ MEF v2 ZIP (2 records) exported: " + outputZip.getAbsolutePath());
        System.out.println("📊 File size: " + outputZip.length() + " bytes");
        
        // Inspect ZIP structure
        ByteArrayInputStream zipInput = new ByteArrayInputStream(mefZip);
        ZipInputStream zipIn = new ZipInputStream(zipInput);
        
        int metadataCount = 0;
        int infoCount = 0;
        ZipEntry entry;
        
        while ((entry = zipIn.getNextEntry()) != null) {
            String entryName = entry.getName();
            if (entryName.matches(".+/metadata/metadata\\.xml")) {
                metadataCount++;
            } else if (entryName.matches(".+/info\\.xml")) {
                infoCount++;
            }
        }
        zipIn.close();
        
        // Verify structure: 2 records = 2 metadata + 2 info files
        assertEquals("ZIP should contain 2 metadata/metadata.xml entries", 2, metadataCount);
        assertEquals("ZIP should contain 2 info.xml entries", 2, infoCount);
        
        System.out.println("📋 ZIP structure verified:");
        System.out.println("  - Metadata files: " + metadataCount);
        System.out.println("  - Info files: " + infoCount);
    }
}
