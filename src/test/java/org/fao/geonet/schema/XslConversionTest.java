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
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.fao.geonet.schema.iso19115_3_2018_che.ISO19115_3_2018SchemaPlugin;
import org.fao.geonet.schemas.XslProcessTest;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

import org.jdom.Namespace;
import org.junit.Test;
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
        xslFile = Paths.get(testClass.getClassLoader().getResource("convert/fromJsonOpenDataSoft.xsl").toURI());
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
    public void validateSchema() throws Exception {
        xslFile = Paths.get(testClass.getClassLoader().getResource("convert/fromISO19139.xsl").toURI());
        xmlFile = Paths.get(testClass.getClassLoader().getResource("amphibiens-19139.che.xml").toURI());
        Element amphibiens = Xml.loadFile(xmlFile);


        Element amphibiensIso19115che = Xml.transform(amphibiens, xslFile);
        isValid(amphibiensIso19115che);
    }


    public boolean isValid(Element amphibiensIso19115che) throws Exception {
        SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        Source schemaFile = new StreamSource(testClass.getClassLoader().getResource("schema/standards.iso.org/19115/-3/eCH-0271-1-0-0.xsd").getFile());

        Schema schema = factory.newSchema(schemaFile);
        Validator validator = schema.newValidator();
        validator.validate(new StreamSource(new ByteArrayInputStream(Xml.getString(amphibiensIso19115che).getBytes(StandardCharsets.UTF_8))));

        List<Namespace> namespaces = amphibiensIso19115che.getAdditionalNamespaces();

        assertEquals("http://standards.iso.org/iso/19115/-3/md1/2.0", namespaces.stream().filter(n -> "md1".equals(n.getPrefix())).findFirst().get().getURI());
        assertEquals("http://standards.iso.org/iso/19115/-3/md2/2.0", namespaces.stream().filter(n -> "md2".equals(n.getPrefix())).findFirst().get().getURI());
        assertEquals("http://standards.iso.org/iso/19115/-3/mda/2.0", namespaces.stream().filter(n -> "mda".equals(n.getPrefix())).findFirst().get().getURI());
        assertEquals("http://standards.iso.org/iso/19115/-3/mds/2.0", namespaces.stream().filter(n -> "mds".equals(n.getPrefix())).findFirst().get().getURI());
        assertEquals("http://standards.iso.org/iso/19115/-3/mdt/2.0", namespaces.stream().filter(n -> "mdt".equals(n.getPrefix())).findFirst().get().getURI());

        //Xml.validate(Path.of(testClass.getClassLoader().getResource("schema/standards.iso.org/19115/-3/eCH-0271-1-0-0.xsd").toURI()), amphibiensIso19115che);
        return true;
    }
}
