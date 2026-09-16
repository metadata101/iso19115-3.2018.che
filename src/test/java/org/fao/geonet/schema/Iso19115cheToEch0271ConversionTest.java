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
 * Test for ISO 19115-3:2018 CHE XML → eCH0271 XTF 2.4 reverse conversion.
 * 
 * Uses minimal test case (single metadata record) to validate correct mapping.
 */
public class Iso19115cheToEch0271ConversionTest {

    private static final boolean GENERATE_EXPECTED_FILE = false;

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    /**
     * Reverse: ISO 19115-3:2018 CHE XML → eCH0271 XTF 2.4
     */
    @Test
    public void convertMinimalIso19115cheToEch0271() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271/toECH0271.xsl");
        Path xmlFile = getResource("eCH0271_1-minimal-to-iso19115che.xml");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertTrue(
            "Expected root element 'transfer' (XTF 2.4), got: " + transformed.getName(),
            transformed.getName().equals("transfer"));
        
        TestSupport.assertGeneratedDataByteMatchExpected(
            "eCH0271_1-minimal-reverse-to-xtf24.xtf",
            Xml.getString(transformed),
            GENERATE_EXPECTED_FILE);
    }
}
