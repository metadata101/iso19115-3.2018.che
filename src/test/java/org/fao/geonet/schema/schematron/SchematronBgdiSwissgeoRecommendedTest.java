package org.fao.geonet.schema.schematron;

import org.checkerframework.checker.nullness.qual.NonNull;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.BeforeClass;
import org.junit.Test;

import java.nio.file.Path;

import static org.fao.geonet.schema.TestSupport.getResource;

public class SchematronBgdiSwissgeoRecommendedTest extends AbstractSchematronTest{

	private static final String SCHEMATRON_NAME = "schematron-rules-bgdi-swissgeo-recommended";

	@BeforeClass
	public static void initSaxonAndCompileSchematron() throws Exception {
		initSaxonAndCompileSchematron("schematron/" + SCHEMATRON_NAME + ".sch");
	}

	protected @NonNull String getSchematronName() {
		return SCHEMATRON_NAME;
	}

	@Test
	public void wanderWege() throws Exception {
		Path xmlFile = getResource("wanderWege-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		Element roleElement = Xml.selectElement(md, "*//mri:pointOfContact/cit:CI_Responsibility/cit:role/cit:CI_RoleCode");
		roleElement.setText("owner");
		roleElement.getAttribute("codeListValue").setValue("owner");

		String report = applySchematronAndCompare("wanderWege", md);

		hasExpectedNumberOfFailure(0, report);
	}

	@Test
	public void wanderWegeMissings() throws Exception {
		Path xmlFile = getResource("wanderWege-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		Element roleElement = Xml.selectElement(md, "*//mri:status/mcc:MD_ProgressCode");
		roleElement.getAttribute("codeListValue").setValue("");
		Xml.selectElement(md, "*//che:CHE_MD_LegalConstraints/mco:otherConstraints/gcx:Anchor").setText("");
		Xml.selectElement(md, "*//che:CHE_MD_DataIdentification/mri:citation/cit:CI_Citation" +
						"/cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString")
				.setText("");


		String report = applySchematronAndCompare("wanderWege-missings", md);

		hasExpectedNumberOfFailure(4, report);
	}
}
