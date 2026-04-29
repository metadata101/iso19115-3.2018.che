package org.fao.geonet.schema;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.riot.Lang;
import org.apache.jena.riot.RDFDataMgr;
import org.apache.jena.shacl.ShaclValidator;
import org.apache.jena.shacl.Shapes;
import org.apache.jena.shacl.ValidationReport;
import org.fao.geonet.utils.TransformerFactoryFactory;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.util.stream.Collectors;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.fao.geonet.schema.TestSupport.getResourceInsideSchema;
import static org.junit.Assert.assertTrue;

/**
 * Validates DCAT-AP-CH formatter output against SHACL shapes.
 *
 * Two shape files are combined:
 *  - shacl/dcat-ap-2.1.1-base-SHACL.ttl : official DCAT-AP 2.1.1 shapes (from itb.ec.europa.eu)
 *  - shacl/dcat-ap-ch-shapes.ttl         : Swiss-specific constraints (opendata.swiss)
 *
 * Reference: https://handbook.opendata.swiss/de/content/glossar/bibliothek/dcat-ap-ch.html
 */
public class ShaclDcatApChTest {

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    @Test
    public void validateAmphibians() throws Exception {
        assertConformsToShacl("amphibians");
    }

    @Test
    public void validateVeterinarians() throws Exception {
        assertConformsToShacl("veterinarians");
    }

    @Test
    public void validateGrundwasservorkommen() throws Exception {
        assertConformsToShacl("grundwasservorkommen");
    }

    @Test
    public void validateConventionDesAlpes() throws Exception {
        assertConformsToShacl("conventionDesAlpesTousLesChamps");
    }

    @Test
    public void validateTrees() throws Exception {
        assertConformsToShacl("trees");
    }

    @Test
    public void validateGrundWasserSchutzZonen() throws Exception {
        assertConformsToShacl("grundwasserschutzzonen");
    }

    @Test
    public void validateZonesDeTranquillite() throws Exception {
        assertConformsToShacl("zonesDeTranquillite");
    }

    @Test
    public void validateSwissTLM3D() throws Exception {
        assertConformsToShacl("swissTLM3D");
    }

    @Test
    public void validateModellDokumentationSwissTLM3D() throws Exception {
        assertConformsToShacl("modellDokumentationSwissTLM3D");
    }

    @Test
    public void validateVALTRALOC() throws Exception {
        assertConformsToShacl("VALTRALOC");
    }

    @Test
    public void validateOrganischenBodenInDerSchweiz() throws Exception {
        assertConformsToShacl("organischenBodenInDerSchweiz");
    }

    @Test
    public void validateSchuetzenswerte() throws Exception {
        assertConformsToShacl("schuetzenswerte");
    }

    @Test
    public void validateWeatherStations() throws Exception {
        assertConformsToShacl("weatherStations");
    }

    @Test
    public void validateHoheitsgrenzpunkteLV() throws Exception {
        assertConformsToShacl("hoheitsgrenzpunkteLV");
    }

    @Test
    public void validateFiktiverDarstellungskatalogMitURL() throws Exception {
        assertConformsToShacl("fiktiverDarstellungskatalogMitURL");
    }

    @Test
    public void validateWanderWege() throws Exception {
        assertConformsToShacl("wanderWege");
    }

    // ---------------------------------------------------------------
    // Core validation logic
    // ---------------------------------------------------------------

    /**
     * Transforms a metadata file with the DCAT-AP-CH XSL, then validates
     * the resulting RDF/XML against the SHACL shapes.
     */
    private void assertConformsToShacl(String mdNameRoot) throws Exception {
        // 1. Transform ISO 19115-3 CHE → DCAT-AP-CH RDF/XML
        Path xslFile = getResourceInsideSchema("formatter/dcat-ap-ch/view.xsl");
        Path xmlFile = getResource(mdNameRoot + "-19115-3.che.xml");
        Element md = Xml.loadFile(xmlFile);
        Element result = Xml.transform(md, xslFile);

        XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
        String rdfXml = xmlOutputter.outputString(result);

        // 2. Load RDF into Jena model
        Model dataModel = ModelFactory.createDefaultModel();
        RDFDataMgr.read(dataModel,
            new ByteArrayInputStream(rdfXml.getBytes(StandardCharsets.UTF_8)),
            null,
            Lang.RDFXML
        );

        // 3. Load and merge SHACL shapes: DCAT-AP 2.1.1 base + CH-specific rules
        Path dcatApBasePath = getResource("shacl/dcat-ap-2.1.1-base-SHACL.ttl");
        Path dcatApChPath = getResource("shacl/dcat-ap-ch-shapes.ttl");
        Model shapesModel = ModelFactory.createDefaultModel();
        RDFDataMgr.read(shapesModel, dcatApBasePath.toString(), Lang.TURTLE);
        RDFDataMgr.read(shapesModel, dcatApChPath.toString(), Lang.TURTLE);
        Shapes shapes = Shapes.parse(shapesModel);

        // 4. Validate
        ValidationReport report = ShaclValidator.get().validate(shapes, dataModel.getGraph());

        // 5. Build violation message (always collect entries: conforms() may be true
        //    even when warning-level entries are present)
        String violations = report.getEntries().stream()
            .map(e -> String.format(
                "\n  [%s] path=%s value=%s message=%s",
                e.severity(),
                e.resultPath(),
                e.value(),
                e.message()
            ))
            .collect(Collectors.joining());

        assertTrue("SHACL violations in '" + mdNameRoot + "':" + violations, report.conforms());
    }
}
