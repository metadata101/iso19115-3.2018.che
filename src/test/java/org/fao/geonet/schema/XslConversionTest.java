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
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.fao.geonet.schema.iso19115_3_2018_che.ISO19115_3_2018SchemaPlugin;
import org.fao.geonet.schemas.XslProcessTest;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

import org.jdom.Namespace;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;
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

public class XslConversionTest extends XslProcessTest {

    public XslConversionTest() {
        super();
        this.setNs(ISO19115_3_2018SchemaPlugin.allNamespaces);
    }

    @Test
    public void testOdsConversion() throws Exception {
        xslFile = Paths.get(testClass.getClassLoader().getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/convert/fromJsonOpenDataSoft.xsl").toURI());
        xmlFile = Paths.get(testClass.getClassLoader().getResource("ods.xml").toURI());
        Path jsonFile = Paths.get(testClass.getClassLoader().getResource("ods.json").toURI());
        String jsonString = Files.readString(jsonFile);
        Element xmlFromJSON = Xml.getXmlFromJSON(jsonString);
        xmlFromJSON.setName("record");
        xmlFromJSON.addContent(new Element("nodeUrl").setText("https://www.odwb.be"));

        Element inputElement = Xml.loadFile(xmlFile);
        String expectedXml = Xml.getString(inputElement);

        Element resultElement = Xml.transform(xmlFromJSON, xslFile);
        String resultOfConversion = Xml.getString(resultElement);

        Diff diff = DiffBuilder
            .compare(Input.fromString(resultOfConversion))
            .withTest(Input.fromString(expectedXml))
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
    public void validateAmphibiansSchema() throws Exception {
        xslFile = Paths.get(testClass.getClassLoader().getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/convert/fromISO19139.xsl").toURI());
        xmlFile = Paths.get(testClass.getClassLoader().getResource("amphibians-19139.che.xml").toURI());
        Element amphibians = Xml.loadFile(xmlFile);

        Element amphibiansIso19115che = Xml.transform(amphibians, xslFile);
        isValid(amphibiansIso19115che);
        //TODO CMT/SRT activate
        //isGNValid(amphibiansIso19115che);

        byte[] expected = testClass.getClassLoader().getResourceAsStream("amphibians-19115-3.che.xml").readAllBytes();
        byte[] actual = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n")) //
                .outputString(new Document(amphibiansIso19115che)) //
                .getBytes(StandardCharsets.UTF_8);
        assertArrayEquals(expected, actual);

    }

    private void isValid(Element xmlIso19115che) throws SAXException, IOException {
        SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        Source schemaFile = new StreamSource(testClass.getClassLoader().getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/schema/standards.iso.org/19115/-3/eCH-0271-1-0-0.xsd").getFile());

        Schema schema = factory.newSchema(schemaFile);
        Validator validator = schema.newValidator();
        validator.validate(new StreamSource(new ByteArrayInputStream(Xml.getString(xmlIso19115che).getBytes(StandardCharsets.UTF_8))));

        List<Namespace> namespaces = xmlIso19115che.getAdditionalNamespaces();

        assertEquals("http://standards.iso.org/iso/19115/-3/md1/2.0", namespaces.stream().filter(n -> "md1".equals(n.getPrefix())).findFirst().get().getURI());
        assertEquals("http://standards.iso.org/iso/19115/-3/md2/2.0", namespaces.stream().filter(n -> "md2".equals(n.getPrefix())).findFirst().get().getURI());
        assertEquals("http://standards.iso.org/iso/19115/-3/mda/2.0", namespaces.stream().filter(n -> "mda".equals(n.getPrefix())).findFirst().get().getURI());
        assertEquals("http://standards.iso.org/iso/19115/-3/mds/2.0", namespaces.stream().filter(n -> "mds".equals(n.getPrefix())).findFirst().get().getURI());
        assertEquals("http://standards.iso.org/iso/19115/-3/mdt/2.0", namespaces.stream().filter(n -> "mdt".equals(n.getPrefix())).findFirst().get().getURI());
    }

    private void isGNValid(Element amphibiansIso19115che) throws Exception {
        Xml.validate(Path.of(testClass.getClassLoader().getResource("schema/standards.iso.org/19115/-3/eCH-0271-1-0-0.xsd").toURI()), amphibiansIso19115che);
    }

    @Test
    public void convertResponsibleParty() throws Exception {
        xslFile = Paths.get(testClass.getClassLoader().getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/convert/ISO19139/mapping/CI_ResponsibleParty.xsl").toURI());
        xmlFile = Paths.get(testClass.getClassLoader().getResource("responsible_party_agroscope_iso19139_che.xml").toURI());
        Element amphibians = Xml.loadFile(xmlFile);

        Element newRespParty = Xml.transform(amphibians, xslFile);

        byte[] expected = testClass.getClassLoader().getResourceAsStream("expectedFromNewRespParty.xml").readAllBytes();
        byte[] actual = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n")).outputString(newRespParty).getBytes(StandardCharsets.UTF_8);
        assertArrayEquals(expected, actual);
    }

    @Test
    public void validateGruenflaechenSchema() throws Exception {
        xslFile = Paths.get(testClass.getClassLoader().getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/convert/fromISO19139.xsl").toURI());
        xmlFile = Paths.get(testClass.getClassLoader().getResource("gruenflaechen-19139.che.xml").toURI());
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
}
