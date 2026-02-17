package org.fao.geonet.schema.schematron;

import org.checkerframework.checker.nullness.qual.NonNull;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.BeforeClass;
import org.junit.Test;

import java.nio.file.Path;

import static org.fao.geonet.schema.TestSupport.getResource;

public class SchematronBasicGeodataAapRecommendedTest extends AbstractSchematronTest{

	private static final String SCHEMATRON_NAME = "schematron-rules-basicgeodata-aap-recommended";

	@BeforeClass
	public static void initSaxonAndCompileSchematron() throws Exception {
		initSaxonAndCompileSchematron("schematron/" + SCHEMATRON_NAME + ".sch");
	}

	protected @NonNull String getSchematronName() {
		return SCHEMATRON_NAME;
	}

	@Test
	public void wanderWege() throws Exception {
		String report = applySchematronAndCompare("wanderWege");

		hasExpectedNumberOfFailure(0, report);
	}

	@Test
	public void wanderWegeMissingAAPDetails() throws Exception {
		Path xmlFile = getResource("wanderWege-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		Xml.selectElement(md, "*//che:durationOfConservation/gco:Integer").setText(" ");
		Xml.selectElement(md, "*//che:CHE_AppraisalOfArchivalValueCode").detach();

		String report = applySchematronAndCompare("wanderWege-missing-aap-details", md);

		hasExpectedNumberOfFailure(2, report);
	}
}
