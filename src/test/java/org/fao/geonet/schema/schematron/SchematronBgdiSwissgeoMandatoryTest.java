package org.fao.geonet.schema.schematron;

import org.checkerframework.checker.nullness.qual.NonNull;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.BeforeClass;
import org.junit.Test;

import java.nio.file.Path;

import static org.fao.geonet.schema.TestSupport.getResource;

public class SchematronBgdiSwissgeoMandatoryTest extends AbstractSchematronTest {

	private static final String SCHEMATRON_NAME = "schematron-rules-bgdi-swissgeo-mandatory";

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
	public void wanderWegeMissings() throws Exception {
		Path xmlFile = getResource("wanderWege-19115-3.che.xml");
		Element md = Xml.loadFile(xmlFile);
		Xml.selectElement(md, "*//mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR']").setText(" ");
		Xml.selectElement(md, "*//mri:citation/cit:CI_Citation/cit:title/lan:PT_FreeText/lan:textGroup[lan:LocalisedCharacterString/@locale='#DE']").detach();
		Xml.selectElement(md, "*//mri:citation/cit:CI_Citation/cit:alternateTitle/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR']").setText(" ");
		Xml.selectElement(md, "*//mri:citation/cit:CI_Citation/cit:alternateTitle/lan:PT_FreeText/lan:textGroup[lan:LocalisedCharacterString/@locale='#DE']").detach();
		Xml.selectElement(md, "*//mri:abstract/lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale='#FR']").setText(" ");
		Xml.selectElement(md, "*//mri:abstract/lan:PT_FreeText/lan:textGroup[lan:LocalisedCharacterString/@locale='#DE']").detach();


		String report = applySchematronAndCompare("wanderWege-missings", md);

		hasExpectedNumberOfFailure(6, report);
	}

}
