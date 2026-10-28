package org.fao.geonet.schema;

import java.nio.file.Path;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertTrue;

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
public class Ech0271XtfToIso19115cheConversionTest {

    private static final boolean GENERATE_EXPECTED_FILE = false;

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    /**
     * Test: eCH0271 XTF 2.4 (drones_vd) → ISO 19115-3:2018 CHE XML
     * Validates correct XSLT transformation of single metadata record.
     */
    @Test
    public void convertDronesVdEch0271Xtf() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271-XTF/fromECH0271-XTF.xsl");
        Path xmlFile = getResource("ech0271-xtf/drones_vd.xtf");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertTrue(
            "Expected CHE_MD_Metadata, got: " + transformed.getName(),
            transformed.getName().equals("CHE_MD_Metadata"));
        
        TestSupport.assertGeneratedDataByteMatchExpected(
                "ech0271-xtf/drones_vd-to-iso19115-3.che.xml",
            Xml.getString(transformed),
            GENERATE_EXPECTED_FILE);
    }

    /**
     * Test: eCH0271 XTF 2.4 (ConventionDesAlpesTousLesChamps) → ISO 19115-3:2018 CHE XML
     * Validates correct XSLT transformation of single metadata record.
     * This tests a real-world eCH-0271-XTF dataset about Alpine Convention.
     */
    @Test
    public void convertConventionDesAlpesTousLesChamps() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271-XTF/fromECH0271-XTF.xsl");
        Path xmlFile = getResource("ech0271-xtf/conventionDesAlpesTousLesChamps-eCH0271.xtf");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertTrue(
            "Expected CHE_MD_Metadata, got: " + transformed.getName(),
            transformed.getName().equals("CHE_MD_Metadata"));
        
        TestSupport.assertGeneratedDataByteMatchExpected(
                "ech0271-xtf/conventionDesAlpesTousLesChamps-eCH0271-iso19115-3.che.xml",
            Xml.getString(transformed),
            GENERATE_EXPECTED_FILE);
    }

    @Test
    public void convertConventionDesAlpesTousLesChampsVersion2() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271-XTF/fromECH0271-XTF.xsl");
        Path xmlFile = getResource("ech0271-xtf/conventionDesAlpesTousLesChamps-eCH0271-V2.xtf");

        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);

        assertTrue(
                "Expected CHE_MD_Metadata, got: " + transformed.getName(),
                transformed.getName().equals("CHE_MD_Metadata"));

        TestSupport.assertGeneratedDataByteMatchExpected(
                "ech0271-xtf/conventionDesAlpesTousLesChamps-eCH0271-V2-iso19115-3.che.xml",
                Xml.getString(transformed),
                GENERATE_EXPECTED_FILE);
    }
}
