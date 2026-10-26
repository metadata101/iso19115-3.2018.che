package org.fao.geonet.schema;

import java.nio.file.Path;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;

import org.junit.BeforeClass;
import org.junit.Test;
import org.w3c.dom.Attr;
import org.w3c.dom.Node;
import org.xmlunit.builder.DiffBuilder;
import org.xmlunit.diff.Comparison;
import org.xmlunit.diff.ComparisonResult;
import org.xmlunit.diff.Diff;
import org.xmlunit.diff.DifferenceEvaluator;

import static org.xmlunit.assertj3.XmlAssert.assertThat;
import static org.junit.Assert.assertFalse;


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
        String testXml = Xml.getString(Xml.loadFile(getResource("ech0271-xtf/drones_vd2-reverse-to-ech0271.xtf")));
        String controlXml2 = Xml.getString(Xml.loadFile(getResource("ech0271-xtf/drones_vd2.xtf")));

        Diff myDiff = DiffBuilder.compare(controlXml2).withTest(testXml)
                .withDifferenceEvaluator(new IgnoreAttributeDifferenceEvaluator("ili:tid"))
                .ignoreComments().ignoreWhitespace()
                .checkForSimilar().build();

        assertFalse(myDiff.toString(), myDiff.hasDifferences());
    }

    @Test
    public void convertConventionDesAlpesVdIso19115cheToEch0271Xtf() throws Exception {
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

    private static class IgnoreAttributeDifferenceEvaluator implements DifferenceEvaluator {
        private final String attributeName;
        public IgnoreAttributeDifferenceEvaluator(String attributeName) {
            this.attributeName = attributeName;
        }

        @Override
        public ComparisonResult evaluate(Comparison comparison, ComparisonResult outcome) {
            if (outcome == ComparisonResult.EQUAL)
                return outcome;
            final Node controlNode = comparison.getControlDetails().getTarget();
            if (controlNode instanceof Attr) {
                Attr attr = (Attr) controlNode;
                if (attr.getName().equals(attributeName)) {
                    return ComparisonResult.SIMILAR;
                }
            }
            return outcome;
        }
    }
}
