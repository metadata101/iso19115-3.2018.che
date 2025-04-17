package org.fao.geonet.schema;

import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.Test;

import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.Assert.assertEquals;

public class ExtractUUIDTest {

    @Test
    public void extractUUID() throws Exception {
        Path xslFile = Paths.get(getClass().getClassLoader().getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/extract-uuid.xsl").toURI());
        Path xmlFile = Paths.get(getClass().getClassLoader().getResource("amphibians-19115-3.che.xml").toURI());
        Element amphibians = Xml.loadFile(xmlFile);

        Element extractedUUID = Xml.transform(amphibians, xslFile);

        assertEquals("9ea54bf1-43b5-4cbd-ab46-0a9dd65567ce", extractedUUID.getText());
    }
}
