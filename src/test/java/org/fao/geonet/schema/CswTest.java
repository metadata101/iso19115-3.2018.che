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

public class CswTest {

	private static final boolean GENERATE_EXPECTED_FILE = true;

	@BeforeClass
	public static void initSaxon() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@Test
	public void ech0271Full() throws Exception {
		Path xslFile = getResourceInsideSchema("present/csw/ech-0271-full.xsl");
		Path xmlFile = getResource("amphibians-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);

		Element fullCswRecord = Xml.transform(md, xslFile);

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String actual = xmlOutputter.outputString(new Document(fullCswRecord));

		TestSupport.assertGeneratedDataByteMatchExpected("amphibians-19115-3.che.xml", actual, false);
	}
}
