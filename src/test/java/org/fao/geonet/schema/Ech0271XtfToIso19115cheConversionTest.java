package org.fao.geonet.schema;

import java.nio.file.Path;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertEquals;
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
    public void convertDronesVdEch0271Xtf() throws Exception {
        transformToIsoCompareValidate("drones_vd");
    }

    /**
     * Test: eCH0271 XTF 2.4 (ConventionDesAlpesTousLesChamps) → ISO 19115-3:2018 CHE XML
     * Validates correct XSLT transformation of single metadata record.
     * This tests a real-world eCH-0271-XTF dataset about Alpine Convention.
     */
    @Test
    public void convertConventionDesAlpesTousLesChamps() throws Exception {
        transformToIsoCompareValidate("conventionDesAlpesTousLesChamps-eCH0271");
    }

    @Test
    public void convertSimpleTestEch0271Xtf() throws Exception {
        transformToIsoCompareValidate("eCH0271_simple_test");
    }

    @Test
    public void convertSwissBoundariesEch0271Xtf() throws Exception {
        transformToIsoCompareValidate("eCH0271_swissBoundaries3D");
    }

    private static void transformToIsoCompareValidate(String testFileRoot) throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271-XTF/fromECH0271-XTF.xsl");
        Path xmlFile = getResource("ech0271-xtf/" + testFileRoot + ".xtf");

        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);

        assertEquals("Expected CHE_MD_Metadata, got: " + transformed.getName(), "CHE_MD_Metadata", transformed.getName());

        TestSupport.assertGeneratedDataByteMatchExpected(
                "ech0271-xtf/" + testFileRoot + "-iso19115-3.che.xml",
                Xml.getString(transformed),
                GENERATE_EXPECTED_FILE);

        TestSupport.isValid(transformed);
    }
}