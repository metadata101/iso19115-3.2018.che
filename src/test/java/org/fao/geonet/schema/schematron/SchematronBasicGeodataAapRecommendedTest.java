package org.fao.geonet.schema.schematron;

import org.fao.geonet.schema.TestSupport;
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

public class SchematronBasicGeodataAapRecommendedTest {

	private static final boolean GENERATE_EXPECTED_FILE = true;

	private static Path compiledSchematronFilePath;

	@ClassRule
	public static final TemporaryFolder temporaryFolder = new TemporaryFolder();

	public static void mustInitSaxonFirst() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@BeforeClass
	public static void initSaxonAndCompileSchematron() throws Exception {
		mustInitSaxonFirst();
		Element schematronSource = Xml.loadFile(getResourceInsideSchema("schematron/schematron-rules-basicgeodata-aap-recommended.sch"));
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
	public void wanderWegeHornisse() throws Exception {
		String report = applySchematronAndCompare("wanderWege", false);

		hasExpectedNumberOfFailure(0, report);
	}

	@Test
	public void wanderWegeMissingAAPDetails() throws Exception {
		Path xmlFile = getResource("wanderWege-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		Xml.selectElement(md, "*//che:durationOfConservation/gco:Integer").setText(" ");
		Xml.selectElement(md, "*//che:CHE_AppraisalOfArchivalValueCode").detach();

		String report = applySchematronAndCompare("wanderWege-missing-aap-details", false, md);

		hasExpectedNumberOfFailure(2, report);
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
		TestSupport.assertGeneratedDataByteMatchExpected("schematron/" + mdNameRoot + "-schematron-rules-basicgeodata-aap-recommended-report.xml", actual, GENERATE_EXPECTED_FILE);
		return actual;
	}

    private static void hasExpectedNumberOfFailure(int expected, String report) {
        assertEquals(expected, Pattern.compile("<svrl:failed-assert").matcher(report).results().count());
    }
}
