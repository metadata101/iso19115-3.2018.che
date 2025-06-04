package org.fao.geonet.schema;

import org.fao.geonet.util.XslUtil;
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

import java.io.FileWriter;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.TimeZone;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;

public class IndexationTest {

    private static Field resolverMapField;

    private static final boolean GENERATE_EXPECTED_FILE = false;

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
    public void indexAmphibians() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = true;
        indexAndCompareWithExpected("amphibians");
    }

    @Test
    public void indexServiceGruenflaechen() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("gruenflaechen");
    }

    @Test
    public void indexConventionDesAlpesTousLesChamps() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("conventionDesAlpesTousLesChamps");
    }

    @Test
    public void indexGrundWasserSchutzZonen() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("grundwasserschutzzonen");
    }

    @Test
    public void indexAsiatischeHornisse() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("asiatischeHornisse");
    }

    @Test
    public void indexZonesDeTranquillite() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("zonesDeTranquillite");
    }

    @Test
    public void indexGrundWasserVorkommen() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("grundwasservorkommen");
    }

    @Test
    public void indexSwissTLM3D() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("swissTLM3D");
    }

    @Test
    public void indexModellDokumentationSwissTLM3D() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("modellDokumentationSwissTLM3D");
    }

    @Test
    public void indexVALTRALOC() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("VALTRALOC");
    }

    @Test
    public void indexOrganischenBodenInDerSchweiz() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("organischenBodenInDerSchweiz");
    }

    @Test
    public void indexSchuetzenswerte() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("schuetzenswerte");
    }

    @Test
    public void indexWeatherStations() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("weatherStations");
    }

    @Test
    public void indexHoheitsgrenzpunkteLV() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("hoheitsgrenzpunkteLV");
    }

    @Test
    public void indexFiktiverDarstellungskatalogMitURL() throws Exception {
        XslUtil.IS_INSPIRE_ENABLED = false;
        indexAndCompareWithExpected("fiktiverDarstellungskatalogMitURL");
    }

    @Test
    public void useIncorrectTimeZone() throws Exception {
        TimeZone.setDefault(TimeZone.getTimeZone("GMT+2"));
        XslUtil.IS_INSPIRE_ENABLED = true;
        String actual = indexResource("amphibians-19115-3.che.xml");

        try {
            XmlAssert.assertThat(actual).valueByXPath("//resourceTemporalDateRange").contains("2024-02-22T22:00:00.000Z");
        } catch (AssertionError e) {
            throw new AssertionError("The date is no longer shifted to previous day according to system timezone (there might be no need to force system timezone to utc anymore).", e);
        }
    }

    private void indexAndCompareWithExpected(String fileRoot) throws Exception {
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));

        String actual = indexResource(fileRoot + "-19115-3.che.xml");

        String expected;
        if (GENERATE_EXPECTED_FILE) {
            FileWriter fw = new FileWriter("/home/cmangeat/sources/war-overlay/iso19115-3.2018.che/src/test/resources/" + fileRoot + "-index.xml");
            fw.write(actual);
            fw.flush();
            expected = actual;
        } else {
            expected = Files.readString(getResource(fileRoot + "-index.xml"));
        }
        XmlAssert.assertThat(actual).isEqualTo(expected);
    }

    private String indexResource(String resourceToIndex) throws Exception {
        Path xslFile = getResourceInsideSchema("index-fields/index.xsl");
        Path xmlFile = getResource(resourceToIndex);
        Element toIndex = Xml.loadFile(xmlFile);

        Element index = Xml.transform(toIndex, xslFile);

        return new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n")) //
                .outputString(new Document(index)) //
                .replaceAll("<indexingDate>.*</indexingDate>", "<indexingDate>2025-04-11T17:46:21+02:00</indexingDate>");
    }
}
