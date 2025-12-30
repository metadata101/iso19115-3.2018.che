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

public class ExtractRelationTest {

	private static final boolean GENERATE_EXPECTED_FILE = false;

	@BeforeClass
	public static void initSaxon() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@Test
	public void asiatischeHornisseThumbnailExtraction() throws Exception {
		Path xslFile = getResource("handle/extract-relations-call.xsl");
		Path xmlFile = getResource("asiatischeHornisse-19115-3.che.xml");
		Element source = Xml.loadFile(xmlFile);
		Element root = new Element("metadata");
		root.addContent(source);

		Element transformed = Xml.transform(root, xslFile);

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String actual = xmlOutputter.outputString(new Document(transformed));
		TestSupport.assertGeneratedDataByteMatchExpected("asiatischeHornisse-relations.xml", actual, GENERATE_EXPECTED_FILE);
	}
}
