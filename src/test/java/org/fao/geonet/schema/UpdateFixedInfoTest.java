package org.fao.geonet.schema;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.BeforeClass;
import org.junit.Test;

import java.nio.file.Path;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertTrue;

public class UpdateFixedInfoTest {

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

		Element transformed = Xml.transform(root, xslFile);

		assertTrue(transformed.getChildren().size() > 5);
	}

}
