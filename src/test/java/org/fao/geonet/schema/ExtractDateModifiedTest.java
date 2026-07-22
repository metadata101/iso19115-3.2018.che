package org.fao.geonet.schema;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.BeforeClass;
import org.junit.Test;

import java.nio.file.Path;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertEquals;

public class ExtractDateModifiedTest {

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    @Test
    public void extractDateModified() throws Exception {
        Path xslFile = getResourceInsideSchema("extract-date-modified.xsl");
        Path xmlFile = getResource("amphibians-19115-3.che.xml");
        Element amphibians = Xml.loadFile(xmlFile);

        Element extractedDate = Xml.transform(amphibians, xslFile);

        assertEquals("2025-03-17T16:04:56.559Z", extractedDate.getText());
    }
}
