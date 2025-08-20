package org.fao.geonet.schema;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.BeforeClass;
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
	public void euDcatAp() throws Exception {
		transformToEuDCatApAndCompare("eu-dcat-ap", "amphibians");
	}

	@Test
	public void euDcatApMobility() throws Exception {
		transformToEuDCatApAndCompare("eu-dcat-ap-mobility","amphibians");
	}

	@Test
	public void euDcatApForService() throws Exception {
		transformToEuDCatApAndCompare("eu-dcat-ap", "grundwasservorkommen");
	}

	private void transformToEuDCatApAndCompare(String profile, String mdNameRoot) throws Exception {
		Path xslFile = getResourceInsideSchema("formatter/" + profile + "/view.xsl");
		Path xmlFile = getResource(mdNameRoot + "-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);

		Element euDcatApView = Xml.transform(md, xslFile);

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String actual = xmlOutputter.outputString(new Document(euDcatApView));
		TestSupport.assertGeneratedDataByteMatchExpected(mdNameRoot + "-"  + profile + ".xml", actual, GENERATE_EXPECTED_FILE);
	}

}
