package org.fao.geonet.schema;

import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.Test;

import java.nio.file.Path;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertEquals;

public class ExtractUUIDTest {

    @Test
    public void extractUUID() throws Exception {
        Path xslFile = getResourceInsideSchema("extract-uuid.xsl");
        Path xmlFile = getResource("amphibians-19115-3.che.xml");
        Element amphibians = Xml.loadFile(xmlFile);

        Element extractedUUID = Xml.transform(amphibians, xslFile);

        assertEquals("9ea54bf1-43b5-4cbd-ab46-0a9dd65567ce", extractedUUID.getText());
    }
}
