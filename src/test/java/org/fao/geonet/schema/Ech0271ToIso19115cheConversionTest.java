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
 * Uses minimal test case (single metadata record) to validate correct mapping.
 */
public class Ech0271ToIso19115cheConversionTest {

    private static final boolean GENERATE_EXPECTED_FILE = false;

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    /**
     * Forward: eCH0271 XTF 2.4 (drones_vd) → ISO 19115-3:2018 CHE XML
     */
    @Test
    public void convertDronesVdEch0271() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271/fromECH0271.xsl");
        Path xmlFile = getResource("drones_vd.xtf");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertTrue(
            "Expected CHE_MD_Metadata or CHE_MD_MetadataCollection, got: " + transformed.getName(),
            transformed.getName().contains("CHE_MD_Metadata"));
        
        TestSupport.assertGeneratedDataByteMatchExpected(
            "drones_vd-to-iso19115-3.che.xml",
            Xml.getString(transformed),
            GENERATE_EXPECTED_FILE);
    }

    /**
     * Forward: eCH0271 XTF 2.4 (multiple_md_sz) → ISO 19115-3:2018 CHE XML
     */
    @Test
    public void convertMultipleMdSzEch0271() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271/fromECH0271.xsl");
        Path xmlFile = getResource("multiple_md_sz.xtf");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertTrue(
            "Expected CHE_MD_Metadata or CHE_MD_MetadataCollection, got: " + transformed.getName(),
            transformed.getName().contains("CHE_MD_Metadata"));
        
        TestSupport.assertGeneratedDataByteMatchExpected(
            "multiple_md_sz-to-iso19115-3.che.xml",
            Xml.getString(transformed),
            GENERATE_EXPECTED_FILE);
    }
}
