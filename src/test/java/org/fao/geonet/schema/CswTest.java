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

	private static final boolean GENERATE_EXPECTED_FILE = false;

	@BeforeClass
	public static void initSaxon() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@Test
	public void ech0271Full() throws Exception {
		transformAndCompare("ech-0271-full.xsl", "amphibians-19115-3.che.xml", "amphibians-19115-3.che.xml");
	}


	@Test
	public void ech0271Summary() throws Exception {
		transformAndCompare("ech-0271-summary.xsl", "amphibians-19115-3.che.xml", "amphibians-19115-3.che-summary.xml");
	}

	@Test
	public void ech0271Brief() throws Exception {
		transformAndCompare("ech-0271-brief.xsl", "amphibians-19115-3.che.xml", "amphibians-19115-3.che-brief.xml");
	}

	@Test
	public void ech0271BriefForService() throws Exception {
		transformAndCompare("ech-0271-brief.xsl", "grundwasservorkommen-19115-3.che.xml", "grundwasservorkommen-19115-3.che-brief.xml");
	}

	private void transformAndCompare(String scriptName, String inputFileName, String expectedFileName) throws Exception {
		Path xslFile = getResourceInsideSchema("present/csw/" + scriptName);
		Path xmlFile = getResource(inputFileName);
		Element md = Xml.loadFile(xmlFile);

		Element cswRecord = Xml.transform(md, xslFile);

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String actual = xmlOutputter.outputString(new Document(cswRecord));
		boolean generateExpectedFileNameOnlyIfInputDiffersFromExpected = GENERATE_EXPECTED_FILE && !expectedFileName.equals(inputFileName);
		TestSupport.assertGeneratedDataByteMatchExpected(expectedFileName, actual, generateExpectedFileNameOnlyIfInputDiffersFromExpected);
	}

}
