/*
 * Copyright (C) 2001-2024 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */
package org.fao.geonet.schema.process;

import org.fao.geonet.schema.TestSupport;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.Test;

import java.nio.file.Path;
import java.util.HashMap;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;

public class OnlineSrcAddTest extends AbstractProcessTest {

    @Test
    public void asiatischeHornisse() throws Exception {
        Path xslFile = getResourceInsideSchema("process/onlinesrc-add.xsl");
        Path xmlFile = getResource("asiatischeHornisse-19115-3.che.xml");
        Element source = Xml.loadFile(xmlFile);

        Element transformed = Xml.transform(source, xslFile, new HashMap<>(){
            {
                put("process", "onlinesrc-add");
                put("url", "https://localhost:8080");
                put("protocol", "OGC:WMS");
                put("function", "browsing");
                put("name", "DE#|FR#|IT#|EN#");
                put("desc", "DE#Service de visualisation WMS|FR#Service de visualisation WMS|IT#Service de visualisation WMS|EN#Service de visualisation WMS");
            }});

        XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
        String actual = xmlOutputter.outputString(new Document(transformed));
        TestSupport.assertGeneratedDataByteMatchExpected("processes/asiatischeHornisse-19115-3.che-with-added-onlinesrc.xml", actual, GENERATE_EXPECTED_FILE);
    }

}
