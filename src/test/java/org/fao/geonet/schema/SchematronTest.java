package org.fao.geonet.schema;

import org.fao.geonet.utils.IO;
import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.BeforeClass;
import org.junit.ClassRule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class SchematronTest {

	private static final boolean GENERATE_EXPECTED_FILE = false;

	private static Path compiledSchematronFilePath;

	@ClassRule
	public static final TemporaryFolder temporaryFolder = new TemporaryFolder();

	public static void mustInitSaxonFirst() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@BeforeClass
	public static void initSaxonAndCompileSchematron() throws Exception {
		mustInitSaxonFirst();
		Element schematronSource = Xml.loadFile(getResourceInsideSchema("schematron/schematron-rules-iso.sch"));
		Path schematronCompilation = getResource("gn-site/WEB-INF/classes/schematron/iso_svrl_for_xslt2.xsl");
		Element compiledSchematron = Xml.transform(schematronSource, schematronCompilation);
		compiledSchematronFilePath = temporaryFolder.getRoot().toPath().resolve("path/requiredtoFind/utilsfile/compiled-iso-schematron.xsl");
		Files.createDirectories(compiledSchematronFilePath.getParent());
		Files.write(compiledSchematronFilePath, Xml.getString(compiledSchematron).getBytes(StandardCharsets.UTF_8));
	}

	@BeforeClass
	public static void makeUtilsFnAvailable() throws IOException, URISyntaxException {
		Path targetUtilsFnFile = temporaryFolder.getRoot().toPath().resolve("xsl/utils-fn.xsl");
		Files.createDirectories(targetUtilsFnFile.getParent());
		IO.copyDirectoryOrFile( getResource("gn-site/xsl/utils-fn.xsl"), targetUtilsFnFile, false);
	}

	@Test
	public void amphibiansIsoSchematron() throws Exception {
		String report = applySchematronAndCompare("amphibians");

		assertTrue(report.contains("failure"));
	}

	@Test
	public void veterinariansIsoSchematron() throws Exception {
		String report = applySchematronAndCompare("veterinarians");

		assertFalse(report.contains("failure"));
	}

	@Test
	public void fiktiverDarstellungskatalogIsoSchematron() throws Exception {
		String report = applySchematronAndCompare("fiktiverDarstellungskatalogMitURL");

		assertFalse(report.contains("failure"));
	}

	@Test
	public void grundwasservorkommenServiceIsoSchematron() throws Exception {
		String report = applySchematronAndCompare("grundwasservorkommen");

		assertTrue(report.contains("failure"));
	}

	private String applySchematronAndCompare(String mdNameRoot) throws Exception {
		Path xmlFile = getResource(mdNameRoot + "-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);

		Element report = Xml.transform(md, compiledSchematronFilePath, Map.of(
				"rule", "schematron-rules-iso",
				"thesaurusDir", getResource("gn-site/WEB-INF/data/config/codelist").toAbsolutePath().toString(),
				"lang", "fre"
		));

		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
		String actual = xmlOutputter.outputString(new Document(report));
		TestSupport.assertGeneratedDataByteMatchExpected(mdNameRoot + "-schematron-rules-iso-report.xml", actual, GENERATE_EXPECTED_FILE);
		return actual;
	}
}
