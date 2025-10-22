package org.fao.geonet.schema;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;
import org.junit.BeforeClass;
import org.junit.Test;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.util.List;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class UpdateFixedInfoTest {

	private static final boolean GENERATE_EXPECTED_FILE = false;

	@BeforeClass
	public static void initSaxon() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@Test
	public void UpdateFixedInfoReturnAnMd() throws Exception {
		Path xslFile = getResourceInsideSchema("update-fixed-info.xsl");
		Path xmlFile = getResource("amphibians-19115-3.che.xml");
		Element source = Xml.loadFile(xmlFile);
		Element root = new Element("root");
		root.addContent(source);
		Element env = new Element("env");
		root.addContent(env);
		Element createDate = new Element("createDate");
		env.addContent(createDate);
		createDate.setText("2017-04-12T09:03:07Z");

		Element transformed = Xml.transform(root, xslFile);

		assertTrue(transformed.getChildren().size() > 5);

		XPath xPath = XPath.newInstance(".//mdb:dateInfo");
		List<?> nodes = xPath.selectNodes(transformed);
		assertEquals(2, nodes.size());

		SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		Source schemaFile = new StreamSource(getResourceInsideSchema("schema.xsd").toString());
		Schema schema = factory.newSchema(schemaFile);
		Validator validator = schema.newValidator();
		validator.validate(new StreamSource(new ByteArrayInputStream(Xml.getString(transformed).getBytes(StandardCharsets.UTF_8))));

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String amphibiansWithUpdatedFixedInfo = xmlOutputter.outputString(new Document(transformed));

		TestSupport.assertGeneratedDataByteMatchExpected("amphibians-with-updated-fixed-info-19115-3.che.xml", amphibiansWithUpdatedFixedInfo, GENERATE_EXPECTED_FILE);
	}

}
