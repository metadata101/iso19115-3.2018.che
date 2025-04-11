package org.fao.geonet.schema;

import org.fao.geonet.schema.iso19115_3_2018_che.ISO19115_3_2018SchemaPlugin;
import org.fao.geonet.schemas.XslProcessTest;
import org.fao.geonet.utils.ResolverWrapper;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import java.lang.reflect.Field;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;

import static org.junit.Assert.assertArrayEquals;

public class IndexationTest extends XslProcessTest {

    public IndexationTest() {
        super();
        this.setNs(ISO19115_3_2018SchemaPlugin.allNamespaces);
    }

    private static Field resolverMapField;

    @BeforeClass
    public static void initOasis() throws NoSuchFieldException, IllegalAccessException {
        resolverMapField = ResolverWrapper.class.getDeclaredField("resolverMap");
        resolverMapField.setAccessible(true);
        ((Map) resolverMapField.get(null)).clear();
        ResolverWrapper.createResolverForSchema("DEFAULT", Path.of(IndexationTest.class.getClassLoader().getResource("gn-site/WEB-INF/oasis-catalog.xml").getPath()));
    }

    @AfterClass
    public static void clearOasis() throws NoSuchFieldException, IllegalAccessException {
        ((Map) resolverMapField.get(null)).clear();
    }


    @Test
    public void index() throws Exception {
        xslFile = Paths.get(testClass.getClassLoader().getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/index-fields/index.xsl").toURI());
        xmlFile = Paths.get(testClass.getClassLoader().getResource("amphibians-19115-3.che.xml").toURI());
        Element amphibians = Xml.loadFile(xmlFile);

        Element amphibiansIndex = Xml.transform(amphibians, xslFile);

        byte[] actual = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n")) //
                .outputString(new Document(amphibiansIndex)) //
                .replaceAll("<indexingDate>.*</indexingDate>", "<indexingDate>2025-04-11T17:46:21+02:00</indexingDate>") //
                .getBytes(StandardCharsets.UTF_8);
        byte[] expected = testClass.getClassLoader().getResourceAsStream("amphibiens-index.xml") //
                .readAllBytes();
        assertArrayEquals(expected, actual);
    }
}
