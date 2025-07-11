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

import org.apache.xml.resolver.CatalogManager;
import org.apache.xml.resolver.tools.CatalogResolver;
import org.fao.geonet.utils.PrefixUrlRewrite;
import org.fao.geonet.utils.ResolverWrapper;
import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.fao.geonet.utils.nio.NioPathAwareCatalogResolver;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.FileWriter;
import java.lang.reflect.Field;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.junit.Assert.assertArrayEquals;

public class BuildEditorFormTest {

	private static final boolean GENERATE_EXPECTED_FILE = true;

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

		String catFiles = getResource("gn-site/WEB-INF/oasis-catalog.xml") + ";" + getResource("schemaplugin-uri-catalog.xml");
		System.setProperty("jeeves.xml.catalog.files", catFiles);
		ResolverWrapper.createResolverForSchema("DEFAULT", null);
	}

	@AfterClass
	public static void clearOasis() throws NoSuchFieldException, IllegalAccessException {
		((Map<?,?>) resolverMapField.get(null)).clear();
	}

	@Test
	public void amphibians() throws Exception {
		Path xslFile = getResource("gn-site/xslt/ui-metadata/edit/edit.xsl");
		Path xmlFile = getResource("amphibians-19115-3.che-raw-french-inflated-for-edition.xml");
		Element inflatedMd = Xml.loadFile(xmlFile);

		Element editorForm = Xml.transform(inflatedMd, xslFile);

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String actual = xmlOutputter.outputString(editorForm);
		byte[] expected;
		if (GENERATE_EXPECTED_FILE) {
			FileWriter fw = new FileWriter("/home/cmangeat/sources/war-overlay/iso19115-3.2018.che/src/test/resources/" + "amphibians-19115-3.che-editor-form.xml");
			fw.write(actual);
			fw.flush();
			expected = actual.getBytes(StandardCharsets.UTF_8);
			assertArrayEquals(expected, actual.getBytes(StandardCharsets.UTF_8));
		} else {
			expected = Files.readAllBytes(getResource("amphibians-19115-3.che-editor-form.xml"));
			assertArrayEquals(expected, actual.getBytes(StandardCharsets.UTF_8));
		}
	}
}