package org.fao.geonet.schema;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import java.nio.file.Path;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;

public class DCatFormatterTest {

	private static final boolean GENERATE_EXPECTED_FILE = false;

	@BeforeClass
	public static void initSaxon() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@Test
	public void dcat() throws Exception {
		// warning, two online resources in amphibians-19139.che.xml#L1327-L1371, with incorrect translations
		transformToDCatAndCompare("dcat", "amphibians");
	}

	@Test
	public void euDcatAp() throws Exception {
		transformToDCatAndCompare("eu-dcat-ap", "amphibians");
	}

	@Test
	public void euDcatApMobility() throws Exception {
		transformToDCatAndCompare("eu-dcat-ap-mobility","amphibians");
	}

	@Test
	public void euDcatApHvd() throws Exception {
		transformToDCatAndCompare("eu-dcat-ap-hvd","amphibians");
	}

	@Test
	public void euDcatApHvdWithLegalConstraints() throws Exception {
		transformToDCatAndCompare("eu-dcat-ap-hvd","hoheitsgrenzpunkteLV");
	}

	@Test
	public void euGeoDcatAp() throws Exception {
		transformToDCatAndCompare("eu-geodcat-ap","amphibians");
	}

	@Test
    @Ignore("Legacy formatter via Iso19139, does not work")
	public void euGeoDcatApSemiceu() throws Exception {
		transformToDCatAndCompare("eu-geodcat-ap-semiceu","amphibians");
	}

	@Test
	public void euDcatApForService() throws Exception {
		transformToDCatAndCompare("eu-dcat-ap", "grundwasservorkommen");
	}

	@Test
	public void chDcatAp() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "grundwasservorkommen");
	}

	@Test
	public void chDcatApAmphibians() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "amphibians");
	}

	@Test
	public void chDcatApVeterinarians() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "veterinarians");
	}

	@Test
	public void chDcatApConventionDesAlpes() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "conventionDesAlpesTousLesChamps");
	}

	@Test
	public void chDcatApTrees() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "trees");
	}

	@Test
	public void chDcatApGrundWasserSchutzZonen() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "grundwasserschutzzonen");
	}

	@Test
	public void chDcatApAsiatischeHornisse() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "asiatischeHornisse");
	}

	@Test
	public void chDcatApZonesDeTranquillite() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "zonesDeTranquillite");
	}

	@Test
	public void chDcatApSwissTLM3D() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "swissTLM3D");
	}

	@Test
	public void chDcatApModellDokumentationSwissTLM3D() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "modellDokumentationSwissTLM3D");
	}

	@Test
	public void chDcatApVALTRALOC() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "VALTRALOC");
	}

	@Test
	public void chDcatApOrganischenBodenInDerSchweiz() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "organischenBodenInDerSchweiz");
	}

	@Test
	public void chDcatApSchuetzenswerte() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "schuetzenswerte");
	}

	@Test
	public void chDcatApWeatherStations() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "weatherStations");
	}

	@Test
	public void chDcatApHoheitsgrenzpunkteLV() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "hoheitsgrenzpunkteLV");
	}

	@Test
	public void chDcatApFiktiverDarstellungskatalogMitURL() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "fiktiverDarstellungskatalogMitURL");
	}

	@Test
	public void chDcatApWanderWege() throws Exception {
		transformToDCatAndCompare("dcat-ap-ch", "wanderWege");
	}

	private void transformToDCatAndCompare(String profile, String mdNameRoot) throws Exception {
		Path xslFile = getResourceInsideSchema("formatter/" + profile + "/view.xsl");
		Path xmlFile = getResource(mdNameRoot + "-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);

		Element euDcatApView = Xml.transform(md, xslFile);

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String actual = xmlOutputter.outputString(new Document(euDcatApView));
		TestSupport.assertGeneratedDataByteMatchExpected("dcat/" + mdNameRoot + "-"  + profile + ".xml", actual, GENERATE_EXPECTED_FILE);
	}

}
