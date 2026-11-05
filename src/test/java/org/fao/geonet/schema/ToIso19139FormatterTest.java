/*
 * Copyright (C) 2001-2025 Food and Agriculture Organization of the
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

public class ToIso19139FormatterTest {

private static final boolean GENERATE_EXPECTED_FILE = false;
private static final String TEST_RESOURCES_DIR = "iso19139";

	@BeforeClass
	public static void initSaxon() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@Test
	public void toIso19139AlpineConvention() throws Exception {
		transformToIso19139AndCompare("alpineConvention");
	}

	@Test
	public void toIso19139AtlasGeology() throws Exception {
		transformToIso19139AndCompare("atlasGeology");
	}

	@Test
	public void toIso19139CadastreSitesPollues() throws Exception {
		transformToIso19139AndCompare("cadastreSitesPollués");
	}

	@Test
	public void toIso19139GazoducsVS() throws Exception {
		transformToIso19139AndCompare("gazoducsVS");
	}

	@Test
	public void toIso19139HydrogeologischeKarte() throws Exception {
		transformToIso19139AndCompare("hydrogeologischeKarte");
	}

	@Test
	public void toIso19139QuartiersBiel() throws Exception {
		transformToIso19139AndCompare("quartiersBiel");
	}

	@Test
	public void toIso19139SwissTLM() throws Exception {
		transformToIso19139AndCompare("swissTLM");
	}

	@Test
	public void toIso19139ZonesDronesVaud() throws Exception {
		transformToIso19139AndCompare("zonesDronesVaud");
	}

	private void transformToIso19139AndCompare(String mdNameRoot) throws Exception {
		Path xslFile = getResourceInsideSchema("formatter/iso19139/view.xsl");
		Path xmlFile = getResource(TEST_RESOURCES_DIR + "/" + mdNameRoot + "-iso19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);

		Element iso19139 = Xml.transform(md, xslFile);

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String actual = xmlOutputter.outputString(new Document(iso19139));
		TestSupport.assertGeneratedDataByteMatchExpected(TEST_RESOURCES_DIR + "/" + mdNameRoot + "-iso19139.xml", actual, GENERATE_EXPECTED_FILE);
	}

}
