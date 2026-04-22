package org.fao.geonet.schema.schematron;

import org.checkerframework.checker.nullness.qual.NonNull;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.xpath.XPath;
import org.junit.BeforeClass;
import org.junit.Test;

import java.nio.file.Path;

import static org.fao.geonet.schema.TestSupport.getResource;

public class SchematronBasicGeodataAapMandatoryTest extends AbstractSchematronTest{

	private static final String SCHEMATRON_NAME = "schematron-rules-basicgeodata-aap-mandatory";

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

        hasExpectedNumberOfFailure(0, report);
	}

	@Test
	public void asiatischeHornisse() throws Exception {
		String report = applySchematronAndCompare("asiatischeHornisse");

		hasExpectedNumberOfFailure(0, report);
	}

	@Test
	public void amphibiansNoGeodataInformationBadSubtopic() throws Exception {
		Path xmlFile = getResource("amphibians-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		Xml.selectElement(md, "*//che:basicGeodataInformation").detach();
		Xml.selectElement(md, "*//che:CHE_MD_SubTopicCategoryCode").setAttribute("codeListValue", "geoscientificInformation_Soils");

		String report = applySchematronAndCompare("amphibians-no-geodatainfo-bad-subtopic", md);

		hasExpectedNumberOfFailure(1, report);
	}

	@Test
	public void manyBasicGeodataInformation() throws Exception {
		String report = applySchematronAndCompare("waldenburgAmtlicheVermessung");

		hasExpectedNumberOfFailure(0, report);
	}

	@Test
	public void allBasicGeodataIdEmpty() throws Exception {
		Path xmlFile = getResource("waldenburgAmtlicheVermessung" + "-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		XPath xp = XPath.newInstance("*//che:basicGeodataID");
		xp.addNamespace("che", "http://geocat.ch/che");
		xp.selectNodes(md).forEach(e -> ((Element)e).setText(""));

		String report = applySchematronAndCompare("waldenburgAmtlicheVermessungGeodataIdEmpty", false, md);

		hasExpectedNumberOfFailure(1, report);
	}

}
