package org.fao.geonet.schema;

import org.fao.geonet.utils.ResolverWrapper;
import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.xmlunit.assertj.XmlAssert;

import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.TimeZone;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;

public class IndexationTest {

    private static Field resolverMapField;

    @BeforeClass
    public static void initOasis() throws NoSuchFieldException, IllegalAccessException {
        resolverMapField = ResolverWrapper.class.getDeclaredField("resolverMap");
        resolverMapField.setAccessible(true);
        ((Map<?, ?>) resolverMapField.get(null)).clear();
        ResolverWrapper.createResolverForSchema("DEFAULT", Path.of(IndexationTest.class.getClassLoader().getResource("gn-site/WEB-INF/oasis-catalog.xml").getPath()));
    }

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    @AfterClass
    public static void clearOasis() throws NoSuchFieldException, IllegalAccessException {
        ((Map<?,?>) resolverMapField.get(null)).clear();
    }

    @Test
    public void index() throws Exception {
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));

        String actual = indexAmphibians();

        String expected = Files.readString(getResource("amphibians-index.xml"));
        XmlAssert.assertThat(actual).isEqualTo(expected);
    }

    @Test
    public void useIncorrectTimeZone() throws Exception {
        TimeZone.setDefault(TimeZone.getTimeZone("GMT+2"));

        String actual = indexAmphibians();

        try {
            XmlAssert.assertThat(actual).valueByXPath("//resourceTemporalDateRange").contains("2024-02-22T22:00:00.000Z");
        } catch (AssertionError e) {
            throw new AssertionError("The date is no longer shifted to previous day according to system timezone (there might be no need to force system timezone to utc anymore).", e);
        }
    }

    private String indexAmphibians() throws Exception {
        Path xslFile = getResourceInsideSchema("index-fields/index.xsl");
        Path xmlFile = getResource("amphibians-19115-3.che.xml");
        Element amphibians = Xml.loadFile(xmlFile);

        Element amphibiansIndex = Xml.transform(amphibians, xslFile);

        return new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n")) //
                .outputString(new Document(amphibiansIndex)) //
                .replaceAll("<indexingDate>.*</indexingDate>", "<indexingDate>2025-04-11T17:46:21+02:00</indexingDate>");
    }
}
