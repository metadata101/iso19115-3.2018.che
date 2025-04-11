package org.fao.geonet.schema;

import org.fao.geonet.schema.iso19115_3_2018_che.ISO19115_3_2018SchemaPlugin;
import org.fao.geonet.schemas.XslProcessTest;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.Test;

import java.nio.file.Paths;

import static org.junit.Assert.assertEquals;

public class ExtractUUIDTest extends XslProcessTest {

    public ExtractUUIDTest() {
        super();
        this.setNs(ISO19115_3_2018SchemaPlugin.allNamespaces);
    }

    @Test
    public void extractUUID() throws Exception {
        xslFile = Paths.get(testClass.getClassLoader().getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/extract-uuid.xsl").toURI());
        xmlFile = Paths.get(testClass.getClassLoader().getResource("amphibians-19115-3.che.xml").toURI());
        Element amphibians = Xml.loadFile(xmlFile);

        Element extractedUUID = Xml.transform(amphibians, xslFile);

        assertEquals("9ea54bf1-43b5-4cbd-ab46-0a9dd65567ce", extractedUUID.getText());
    }
}
