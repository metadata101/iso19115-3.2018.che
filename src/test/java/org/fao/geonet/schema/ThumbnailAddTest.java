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
package org.fao.geonet.schema;

import org.fao.geonet.utils.ResolverWrapper;
import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import java.lang.reflect.Field;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;

public class ThumbnailAddTest {

    private static final boolean GENERATE_EXPECTED_FILE = false;

    private static Field resolverMapField;

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    @BeforeClass
    public static void initOasis() throws NoSuchFieldException, IllegalAccessException, URISyntaxException {
        resolverMapField = ResolverWrapper.class.getDeclaredField("resolverMap");
        resolverMapField.setAccessible(true);
        ((Map<?, ?>) resolverMapField.get(null)).clear();
        ResolverWrapper.createResolverForSchema("DEFAULT", Path.of(IndexationTest.class.getClassLoader().getResource("gn-site/WEB-INF/oasis-catalog.xml").getPath()));
    }

    @AfterClass
    public static void clearOasis() throws IllegalAccessException {
        ((Map<?,?>) resolverMapField.get(null)).clear();
    }


    @Test
    public void asiatischeHornisse() throws Exception {
        Path xslFile = getResourceInsideSchema("process/thumbnail-add.xsl");
        Path xmlFile = getResource("asiatischeHornisse-19115-3.che.xml");
        Element source = Xml.loadFile(xmlFile);

        Element transformed = Xml.transform(source, xslFile, new HashMap<>(){
            {
                put("thumbnail_desc", "DE#Beschreibung|FR#|IT#|EN#");
                put("process", "thumbnail-add");
                put("updateKey", "https://www.geo.bl.ch/vorschaubilder_geocat/Asiatische_Hornisse.png");
                put("thumbnail_url", "https://www.geo.bl.ch/vorschaubilder_geocat/Asiatische_Hornisse.png");
            }});

        XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
        String actual = xmlOutputter.outputString(new Document(transformed));
        TestSupport.assertGeneratedDataByteMatchExpected("asiatischeHornisse-19115-3.che-with-described-thumbnail.xml", actual, GENERATE_EXPECTED_FILE);
    }

}
