package org.fao.geonet.schema;

import org.fao.geonet.utils.IO;
import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Namespace;
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
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertEquals;
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
		String report = applySchematronAndCompare("amphibians", false);

		assertTrue(report.contains("failure"));
	}

	@Test
	public void amphibiansIsoSchematronFailure() throws Exception {
		String report = applySchematronAndCompare("amphibians-iso-schematron-failure", false);

		assertTrue(report.contains("failure"));
	}


	@Test
	public void amphibiansWithUpdatedFixedInfoIsoSchematron() throws Exception {
		String report = applySchematronAndCompare("amphibians-with-updated-fixed-info", false);

		hasExpectedNumberOfFailure(1, report);
	}

	@Test
	public void veterinariansIsoSchematron() throws Exception {
		String report = applySchematronAndCompare("veterinarians", true);

		assertFalse(report.contains("failure"));
	}

	@Test
	public void fiktiverDarstellungskatalogIsoSchematron() throws Exception {
		String report = applySchematronAndCompare("fiktiverDarstellungskatalogMitURL", true);

        hasExpectedNumberOfFailure(2, report);
    }

    @Test
	public void grundwasservorkommenServiceIsoSchematron() throws Exception {
		String report = applySchematronAndCompare("grundwasservorkommen", true);

		assertFalse(report.contains("failure"));
	}

	@Test
	public void schematronForEditor() throws Exception {
		String report = applySchematronAndCompare("grundwasservorkommen", true);
		Path xmlFile = getResource("amphibians-19115-3.che-raw-french-inflated-for-edition.xml");
		Element md = Xml.selectElement(Xml.loadFile(xmlFile), "che:CHE_MD_Metadata", List.of(Namespace.getNamespace("che", "http://geocat.ch/che")));

		applySchematronAndCompare("amphibians-19115-3.che-raw-french-inflated-for-edition", true, md);

		assertFalse(report.contains("failure"));
	}


	private String applySchematronAndCompare(String mdNameRoot, boolean forceCreationDate) throws Exception {
		Path xmlFile = getResource(mdNameRoot + "-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		return applySchematronAndCompare(mdNameRoot, forceCreationDate, md);
	}

	private static String applySchematronAndCompare(String mdNameRoot, boolean forceCreationDate, Element md) throws Exception {
		if (forceCreationDate) {
			Element revisionDate = Xml.selectElement(md, "mdb:dateInfo");
			Element creationDate = (Element) revisionDate.clone();
			Element creationDateType = Xml.selectElement(creationDate, "cit:CI_Date/cit:dateType/cit:CI_DateTypeCode", List.of(Namespace.getNamespace("cit", "http://standards.iso.org/iso/19115/-3/cit/2.0")));
			creationDateType.setText("creation");
			creationDateType.getAttribute("codeListValue").setValue("creation");
			md.addContent(md.indexOf(revisionDate) + 1, creationDate);
		}
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

    private static void hasExpectedNumberOfFailure(int expected, String report) {
        assertEquals(expected, Pattern.compile("<svrl:failed-assert").matcher(report).results().count());
    }
}
