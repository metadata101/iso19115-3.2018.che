package org.fao.geonet.schema.schematron;

import org.checkerframework.checker.nullness.qual.NonNull;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.Namespace;
import org.junit.BeforeClass;
import org.junit.Test;

import java.nio.file.Path;
import java.util.List;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.junit.Assert.assertFalse;

public class SchematronIsoTest extends AbstractSchematronTest {

	private static final String SCHEMATRON_NAME = "schematron-rules-iso";

	@BeforeClass
	public static void initSaxonAndCompileSchematron() throws Exception {
		initSaxonAndCompileSchematron("schematron/" + SCHEMATRON_NAME + ".sch");
	}

	protected @NonNull String getSchematronName() {
		return SCHEMATRON_NAME;
	}

	@Test
	public void amphibians() throws Exception {
		String report = applySchematronAndCompare("amphibians");

        hasExpectedNumberOfFailure(2, report);
	}

	@Test
	public void amphibiansFailure() throws Exception {
		Path xmlFile = getResource("schematron/amphibians-iso-schematron-failure-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		String report = applySchematronAndCompare("amphibians-iso-schematron-failure", md);

        hasExpectedNumberOfFailure(14, report);
	}


	@Test
	public void amphibiansWithUpdatedFixedInfo() throws Exception {
		String report = applySchematronAndCompare("amphibians-with-updated-fixed-info");

		hasExpectedNumberOfFailure(1, report);
	}

	@Test
	public void veterinarians() throws Exception {
		String report = applySchematronAndCompare("veterinarians", true);

		assertFalse(report.contains("failure"));
	}

	@Test
	public void fiktiverDarstellungskatalog() throws Exception {
		String report = applySchematronAndCompare("fiktiverDarstellungskatalogMitURL", true);

        hasExpectedNumberOfFailure(1, report);
    }

    @Test
	public void grundwasservorkommenService() throws Exception {
		String report = applySchematronAndCompare("grundwasservorkommen", true);

        hasExpectedNumberOfFailure(0, report);
	}

	@Test
	public void forEditor() throws Exception {
        String rootName = "amphibians-19115-3.che-raw-french-inflated-for-edition";
        Path xmlFile = getResource(rootName + ".xml");
        Element md = Xml.selectElement(Xml.loadFile(xmlFile), "che:CHE_MD_Metadata", List.of(Namespace.getNamespace("che", "http://geocat.ch/che")));

        String report = applySchematronAndCompare(rootName, true, md);

        hasExpectedNumberOfFailure(0, report);
	}
}