/*
 * Copyright (C) 2001-2025 Food and Agriculture Organization of the
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


import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.Namespace;
import org.xml.sax.SAXException;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.ByteArrayInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Objects;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.xmlunit.assertj3.XmlAssert.assertThat;

public class TestSupport {

    public static Path getResource(String name) throws URISyntaxException {
        return Paths.get(Objects.requireNonNull(TestSupport.class.getClassLoader().getResource(name)).toURI());
    }

    public static Path getResourceInsideSchema(String pathToResourceInsideSchema) throws URISyntaxException {
        return getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/" + pathToResourceInsideSchema);
    }

    public static void assertGeneratedDataByteMatchExpected(String expectedFileName, String actual, boolean generateExpectedFile) throws IOException, URISyntaxException {
        byte[] expected;
        if (generateExpectedFile) {
            generateFileWithData(expectedFileName, actual);
            expected = actual.getBytes(StandardCharsets.UTF_8);
        } else {
            expected = Files.readAllBytes(getResource(expectedFileName));
        }
        assertArrayEquals(expected, actual.getBytes(StandardCharsets.UTF_8));
    }

    private static void generateFileWithData(String expectedFileName, String actual) throws IOException {
        try (FileWriter fw = new FileWriter("src/test/resources/" + expectedFileName)) {
            fw.write(actual);
            fw.flush();
        }
    }

    static void assertGeneratedDataXmlMatchExpected(String expectedFilename, String actual, boolean generateExpectedFile) throws IOException, URISyntaxException {
        String expected;
        if (generateExpectedFile) {
            generateFileWithData(expectedFilename, actual);
            expected = actual;
        } else {
            expected = Files.readString(getResource(expectedFilename));
        }
        assertThat(actual).isEqualTo(expected);
    }

    private static void assertNamespacePresent(List<?> namespaces, String nsLocation, String prefix) {
        Namespace ns = namespaces.stream() //
                .filter(n -> prefix.equals(((Namespace) n).getPrefix()))
                .map(Namespace.class::cast)//
                .findFirst() //
                .orElseThrow(() -> new AssertionError(String.format("prefix not found: %s", prefix)));
        assertEquals(nsLocation, ns.getURI());
    }

    public static void isValid(Element xmlIso19115che) throws SAXException, IOException, URISyntaxException {
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
}
