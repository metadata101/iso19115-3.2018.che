package org.fao.geonet.schema;

import java.nio.file.Path;
import java.util.Set;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;

import org.junit.BeforeClass;
import org.junit.Test;
import org.xmlunit.builder.DiffBuilder;
import org.xmlunit.diff.Diff;

import static org.xmlunit.assertj3.XmlAssert.assertThat;


/**
 * Test for ISO 19115-3:2018 CHE XML → eCH0271 XTF 2.4 reverse conversion.
 * <p>
 * Uses minimal test case (single metadata record) to validate correct mapping.
 */
public class Iso19115cheToEch0271XtfConversionTest {

    private static final boolean GENERATE_EXPECTED_FILE = false;

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    /**
     * Reverse: ISO 19115-3:2018 CHE XML (drones_vd) → eCH0271 XTF 2.4
     */
    @Test
    public void convertDronesVdIso19115cheToEch0271Xtf() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271-XTF/toECH0271-XTF.xsl");
        Path xmlFile = getResource("ech0271-xtf/drones_vd-to-iso19115-3.che.xml");
        
        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);
        
        assertThat(transformed.getName()).isEqualTo("transfer");

        TestSupport.assertGeneratedDataByteMatchExpected(
            "ech0271-xtf/drones_vd-reverse-to-ech0271.xtf",
            Xml.getString(transformed),
            GENERATE_EXPECTED_FILE);
    }

    @Test
    public void dronesVd2ToReverseXtfComparison() throws Exception {
        final Set<String> IGNORED_ELEMENTS = Set.of("ili:sender", "ili:comment");
        String testXml = Xml.getString(Xml.loadFile(getResource("ech0271-xtf/drones_vd2-reverse-to-ech0271.xtf")));
        String controlXml = Xml.getString(Xml.loadFile(getResource("ech0271-xtf/drones_vd2.xtf")));

        Diff diff = DiffBuilder.compare(controlXml).withTest(testXml)
                .ignoreComments()
                .ignoreWhitespace()
                .withNodeFilter(node -> !IGNORED_ELEMENTS.contains(node.getNodeName()))
                .withAttributeFilter(attr -> !"ili:tid".equals(attr.getName()))
                .checkForSimilar()
                .build();

        org.assertj.core.api.Assertions.assertThat(diff.getDifferences())
                .as("XML differences")
                .isEmpty();
    }

    @Test
    public void convertConventionDesAlpesIso19115cheToEch0271Xtf() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271-XTF/toECH0271-XTF.xsl");
        Path xmlFile = getResource("ech0271-xtf/conventionDesAlpesTousLesChamps-eCH0271-iso19115-3.che.xml");

        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);

        assertThat(transformed.getName()).isEqualTo("transfer");

        TestSupport.assertGeneratedDataByteMatchExpected(
                "ech0271-xtf/conventionDesAlpesTousLesChamps-reverse-to-ech0271.xtf",
                Xml.getString(transformed),
                GENERATE_EXPECTED_FILE);
    }


    @Test
    public void convertConventionDesAlpesV2Iso19115cheToEch0271Xtf() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/eCH-0271-XTF/toECH0271-XTF.xsl");
        Path xmlFile = getResource("ech0271-xtf/conventionDesAlpesTousLesChamps-eCH0271-V2-iso19115-3.che.xml");

        Element source = Xml.loadFile(xmlFile);
        Element transformed = Xml.transform(source, xslFile);

        assertThat(transformed.getName()).isEqualTo("transfer");

        TestSupport.assertGeneratedDataByteMatchExpected(
                "ech0271-xtf/conventionDesAlpesTousLesChamps-V2-reverse-to-ech0271.xtf",
                Xml.getString(transformed),
                GENERATE_EXPECTED_FILE);
    }

    @Test
    public void convertConventionDesAlpesV2ToReverseXtfComparison() throws Exception {
        //conventionDesAlpesTousLesChamps-eCH0271v2-iso19115-3.che.xml
        final Set<String> IGNORED_ELEMENTS = Set.of("ili:sender", "ili:comment");
        String testXml = Xml.getString(Xml.loadFile(getResource("ech0271-xtf/conventionDesAlpesTousLesChamps-V2-reverse-to-ech0271.xtf")));
        String controlXml = Xml.getString(Xml.loadFile(getResource("ech0271-xtf/conventionDesAlpesTousLesChamps-eCH0271-V2.xtf")));

        Diff diff = DiffBuilder.compare(controlXml).withTest(testXml)
                .ignoreComments()
                .ignoreWhitespace()
                .withNodeFilter(node -> !IGNORED_ELEMENTS.contains(node.getNodeName()))
                .withAttributeFilter(attr -> !"ili:tid".equals(attr.getName()))
                .checkForSimilar()
                .build();

        org.assertj.core.api.Assertions.assertThat(diff.getDifferences())
                .as("XML differences")
                .isEmpty();
    }
}
