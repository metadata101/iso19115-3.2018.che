/*
 * Copyright (C) 2001-2024 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */
package org.fao.geonet.schema;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

import org.jdom.Namespace;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;
import org.junit.BeforeClass;
import org.junit.Test;
import org.xml.sax.SAXException;
import org.xmlunit.builder.DiffBuilder;
import org.xmlunit.builder.Input;
import org.xmlunit.diff.DefaultNodeMatcher;
import org.xmlunit.diff.Diff;
import org.xmlunit.diff.ElementSelectors;
import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

public class Iso19139cheToIso19115cheConversionTest {

    private static final boolean GENERATE_EXPECTED_FILE = false;

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    @Test
    public void validateAmphibiansSchema() throws Exception {
        transformValidateAndCompare("amphibians");
    }

    @Test
    public void validateVeterinarians() throws Exception {
        transformValidateAndCompare("veterinarians");
    }

    @Test
    public void validateConventionDesAlpes() throws Exception {
        transformValidateAndCompare("conventionDesAlpesTousLesChamps");
    }

    @Test
    public void validateTrees() throws Exception {
        transformValidateAndCompare("trees");
    }

    @Test
    public void validateGrundWasserSchutzZonen() throws Exception {
        transformValidateAndCompare("grundwasserschutzzonen");
    }

    @Test
    public void validateAsiatischeHornisse() throws Exception {
        transformValidateAndCompare("asiatischeHornisse");
    }

    @Test
    public void validateZonesDeTranquillite() throws Exception {
        transformValidateAndCompare("zonesDeTranquillite");
    }

    @Test
    public void validateGrundwasserVorkommen() throws Exception {
        transformValidateAndCompare("grundwasservorkommen");
    }

    @Test
    public void validateSwissTLM3D() throws Exception {
        transformValidateAndCompare("swissTLM3D");
    }

    @Test
    public void validateModellDokumentationSwissTLM3D() throws Exception {
        transformValidateAndCompare("modellDokumentationSwissTLM3D");
    }

    @Test
    public void validateVALTRALOC() throws Exception {
        transformValidateAndCompare("VALTRALOC");
    }

    @Test
    public void validateOrganischenBodenInDerSchweiz() throws Exception {
        transformValidateAndCompare("organischenBodenInDerSchweiz");
    }

    @Test
    public void validateSchuetzenswerte() throws Exception {
        transformValidateAndCompare("schuetzenswerte");
    }

    @Test
    public void validateWeatherStations() throws Exception {
        transformValidateAndCompare("weatherStations");
    }

    @Test
    public void validateHoheitsgrenzpunkteLV() throws Exception {
        transformValidateAndCompare("hoheitsgrenzpunkteLV");
    }

    @Test
    public void validateFiktiverDarstellungskatalogMitURL() throws Exception {
        transformValidateAndCompare("fiktiverDarstellungskatalogMitURL");
    }

    @Test
    public void validateWanderWege() throws Exception {
        transformValidateAndCompare("wanderWege");
    }

    @Test
    public void convertResponsibleParty() throws Exception {
        transformAndCompare("subtemplates/responsiblePartyAgroscope", false);
    }

    @Test
    public void convertResponsiblePartyWithNoDefaultOrgName() throws Exception {
        transformAndCompare("subtemplates/responsiblePartyIngenieureUndGeometer", false);
    }

    @Test
    public void convertExtent() throws Exception {
        transformAndCompare("subtemplates/liechtenstein", false);
    }

    @Test
    public void convertInterlis() throws Exception {
        transformAndCompare("subtemplates/interlis", false, "process/convert-to-iso19115-3.2018.che.xsl");
    }

    @Test
    public void convertKonservatorinBotanik() throws Exception {
        transformAndCompare("subtemplates/konservatorinBotanik", false);
    }

    @Test
    public void convertGeoprosuisse() throws Exception {
        transformAndCompare("subtemplates/geoprosuisse", false);
    }

    @Test
    public void convertRawOrganischenBodenInDerSchweiz() throws Exception {
        transformAndCompare("raw-organischenBodenInDerSchweiz", false);
    }

    @Test
    public void convertRawZonesDeTranquillite() throws Exception {
        transformAndCompare("raw-zonesDeTranquillite", false);
    }

    @Test
    public void testOdsConversion() throws Exception {
        Element xmlFromJSON = Xml.getXmlFromJSON(Files.readString(getResource("ods.json")));
        xmlFromJSON.setName("record");
        xmlFromJSON.addContent(new Element("nodeUrl").setText("https://www.odwb.be"));
        Path xslFile = getResourceInsideSchema("convert/fromJsonOpenDataSoft.xsl");

        Element resultElement = Xml.transform(xmlFromJSON, xslFile);

        String actual = Xml.getString(resultElement);
        Path expected = getResource("ods.xml");
        Diff diff = DiffBuilder
                .compare(Input.fromString(actual))
                .withTest(Input.fromPath(expected))
                .withNodeMatcher(new DefaultNodeMatcher(ElementSelectors.byName))
                .normalizeWhitespace()
                .ignoreComments()
                .checkForSimilar()
                .build();
        assertFalse(
                String.format("Differences: %s", diff.toString()),
                diff.hasDifferences());
    }

    @Test
    public void validateGruenflaechenSchema() throws Exception {
        Path xslFile = getResourceInsideSchema("convert/fromISO19139.che.xsl");
        Path xmlFile = getResource("gruenflaechen-19139.che.xml");
        Element gruenflaechen = Xml.loadFile(xmlFile);

        Element gruenflaechenIso19115che = Xml.transform(gruenflaechen, xslFile);
        isValid(gruenflaechenIso19115che);
        XPath xPath = XPath.newInstance(".//srv:serviceType");
        xPath.addNamespace("srv", "http://standards.iso.org/iso/19115/-3/srv/2.0");
        List<?> nodes = xPath.selectNodes(gruenflaechenIso19115che);
        assertEquals(1, nodes.size());
        assertEquals("OGC:WFS", ((Element)((Element) nodes.get(0)).getChildren().get(0)).getText());
        //TODO CMT/SRT activate
        //isGNValid(gruenflaechenIso19115che);
    }

    private void assertNamespacePresent(List<?> namespaces, String nsLocation, String prefix) {
        Namespace ns = namespaces.stream() //
                .filter(n -> prefix.equals(((Namespace) n).getPrefix()))
                .map(Namespace.class::cast)//
                .findFirst() //
                .orElseThrow(() -> new AssertionError(String.format("prefix not found: %s", prefix)));
        assertEquals(nsLocation, ns.getURI());
    }

    private void assertStrictByteEquality(String expectedFileName, Element element, boolean requireXmlHeader) throws IOException, URISyntaxException {
        XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
        String actual;
        if (requireXmlHeader) {
            actual = xmlOutputter.outputString(new Document(element));
        } else {
            actual = xmlOutputter.outputString(element);
        }
        String actualReplaced = actual.replaceAll("gml:TimeInstant gml:id=\".*\"", "gml:TimeInstant gml:id=\"\"");
        TestSupport.assertGeneratedDataByteMatchExpected(expectedFileName, actualReplaced, GENERATE_EXPECTED_FILE);
    }

    private void isValid(Element xmlIso19115che) throws SAXException, IOException, URISyntaxException {
        SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        Source schemaFile = new StreamSource(getResourceInsideSchema("schema.xsd").toString());

        Schema schema = factory.newSchema(schemaFile);
        Validator validator = schema.newValidator();
        validator.validate(new StreamSource(new ByteArrayInputStream(Xml.getString(xmlIso19115che).getBytes(StandardCharsets.UTF_8))));

        List<?> namespaces = xmlIso19115che.getAdditionalNamespaces();

        assertNamespacePresent(namespaces, "http://standards.iso.org/iso/19115/-3/md1/2.0", "md1");
        assertNamespacePresent(namespaces, "http://standards.iso.org/iso/19115/-3/md2/2.0", "md2");
        assertNamespacePresent(namespaces, "http://standards.iso.org/iso/19115/-3/mda/2.0", "mda");
        assertNamespacePresent(namespaces, "http://standards.iso.org/iso/19115/-3/mds/2.0", "mds");
        assertNamespacePresent(namespaces, "http://standards.iso.org/iso/19115/-3/mdt/2.0", "mdt");
    }

    private void isGNValid(Element amphibiansIso19115che) throws Exception {
        Xml.validate(Path.of(getClass().getClassLoader().getResource("schema/standards.iso.org/19115/-3/eCH-0271-1-0-0.xsd").toURI()), amphibiansIso19115che);
    }

    private Element transformAndCompare(String mdNameRoot, boolean requireXmlHeader) throws Exception {
		return transformAndCompare(mdNameRoot, requireXmlHeader, "convert/fromISO19139.che.xsl");
    }

    private Element transformAndCompare(String mdNameRoot, boolean requireXmlHeader, String convertUsing) throws Exception {
        Path xslFile = getResourceInsideSchema(convertUsing);
        Path xmlFile = getResource(mdNameRoot + "-19139.che.xml");
        Element source = Xml.loadFile(xmlFile);

        Element transformed = Xml.transform(source, xslFile);

        assertStrictByteEquality(mdNameRoot + "-19115-3.che.xml", transformed, requireXmlHeader);
        return transformed;
    }

    private void transformValidateAndCompare(String mdNameRoot) throws Exception {
        isValid(transformAndCompare(mdNameRoot, true));
        //TODO CMT/SRT activate
        //isGNValid(amphibiansIso19115che);
    }
}
