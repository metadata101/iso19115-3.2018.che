package org.fao.geonet.schema;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import org.fao.geonet.utils.TransformerFactoryFactory;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import static org.fao.geonet.schema.TestSupport.getResource;
import static org.junit.Assert.assertTrue;
import static org.junit.Assume.assumeTrue;

import org.junit.BeforeClass;
import org.junit.Test;

import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * Round-trip test runner for eCH0271 ↔ ISO 19115-3:2018 CHE bidirectional conversion.
 * 
 * Tests both directions:
 * - Forward: eCH0271 INTERLIS → ISO 19115-3:2018 CHE XML
 * - Reverse: ISO 19115-3:2018 CHE XML → eCH0271 INTERLIS
 * 
 * Unlike parameterized tests, this class provides named test methods that can be
 * run individually from the IDE.
 * 
 * No @RunWith(Parameterized.class) — allows independent test execution.
 */
public class Ech0271Iso19115cheConversionTest {

    /**
     * Set to {@code true} to (re-)generate the expected output files in
     * {@code src/test/resources/}.  Set to {@code false} to compare against
     * the previously generated files (normal CI mode).
     */
    private static final boolean GENERATE_EXPECTED_FILE = true;

    private static final String eCH0271_METADATA_MARKER = "eCH0271_1.eCH0271.MD_Metadata";

    @BeforeClass
    public static void initSaxon() {
        TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
    }

    /**
     * Test: minimal-metadata forward conversion (eCH0271 → ISO 19115-3).
     */
    @Test
    public void testMinimalMetadata() throws Exception {
        convertEch0271ToIso19115che("minimal-metadata");
    }

    /**
     * Test: schutzgebiete forward conversion (eCH0271 → ISO 19115-3).
     */
    @Test
    public void testSchutzgebiete() throws Exception {
        convertEch0271ToIso19115che("schutzgebiete");
    }

    /**
     * Test: minimal-metadata reverse conversion (ISO 19115-3 → eCH0271).
     */
    @Test
    public void testMinimalMetadataReverse() throws Exception {
        convertIso19115cheToEch0271("minimal-metadata");
    }

    /**
     * Test: schutzgebiete reverse conversion (ISO 19115-3 → eCH0271).
     */
    @Test
    public void testSchutzgebieteReverse() throws Exception {
        convertIso19115cheToEch0271("schutzgebiete");
    }

    /**
     * Test: Convention des Alpes forward conversion (eCH0271 → ISO 19115-3).
     */
    @Test
    public void testConventionDesAlpesTousLesChamps() throws Exception {
        convertEch0271ToIso19115che("conventionDesAlpesTousLesChamps");
    }

    /**
     * Test: Convention des Alpes reverse conversion (ISO 19115-3 → eCH0271).
     */
    @Test
    public void testConventionDesAlpesTousLesChampReverse() throws Exception {
        convertIso19115cheToEch0271("conventionDesAlpesTousLesChamps");
    }

    /**
     * Test: Generated eCH0271 INTERLIS forward conversion (eCH0271 → ISO 19115-3).
     * This tests the Python-generated INTERLIS file to validate round-trip conversion.
     */
    @Test
    public void testConventionDesAlpesGeneratedInterlis() throws Exception {
        convertEch0271ToIso19115che("conventionDesAlpesTousLesChamps-eCH0271-generated");
    }

    /**
     * Shared forward conversion logic (eCH0271 → ISO 19115-3 CHE).
     */
    private void convertEch0271ToIso19115che(String datasetName) throws Exception {
        Path xmlFile = resolveEch0271File(datasetName);

        // Skip INTERLIS domain-model files that contain no metadata.
        String content = new String(Files.readAllBytes(xmlFile), StandardCharsets.UTF_8);
        assumeTrue(
            "Skipping '" + datasetName + "': no eCH0271 metadata record found "
                + "(file is an INTERLIS domain model, not a metadata transfer)",
            content.contains(eCH0271_METADATA_MARKER));

        Element result = transform(xmlFile, datasetName);

        assertTrue(
            "Expected root element CHE_MD_Metadata, got: " + result.getName(),
            result.getName().contains("CHE_MD_Metadata"));

        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
        // detach from the parsed Document so we can wrap it in a new one
        result.detach();
        String actual = outputter.outputString(new Document(result));
        // Normalise generated GML ids so comparisons are stable.
        String actualNormalized = actual.replaceAll("gml:TimeInstant gml:id=\".*?\"", "gml:TimeInstant gml:id=\"\"");

        TestSupport.assertGeneratedDataByteMatchExpected(
            datasetName + "-ech0271-19115-3.che.xml",
            actualNormalized,
            GENERATE_EXPECTED_FILE);
    }

    /**
     * Shared reverse conversion logic (ISO 19115-3 CHE → eCH0271).
     */
    private void convertIso19115cheToEch0271(String datasetName) throws Exception {
        // Look for the ISO input file in resources (pre-converted or pre-existing)
        Path isoFile = getResource(datasetName + "-ech0271-iso-input.xml");

        if (isoFile == null || !Files.exists(isoFile)) {
            throw new IllegalStateException("ISO input file not found: " + datasetName 
                + "-ech0271-iso-input.xml — run forward conversion first and copy to resources");
        }

        Element result = reverseTransform(isoFile, datasetName);

        assertTrue(
            "Expected root element TRANSFER, got: " + result.getName(),
            result.getName().equals("TRANSFER"));

        XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat().setLineSeparator("\n"));
        // detach from the parsed Document so we can wrap it in a new one
        result.detach();
        String actual = outputter.outputString(new Document(result));

        TestSupport.assertGeneratedDataByteMatchExpected(
            datasetName + "-reverse-ech0271.xtf",
            actual,
            GENERATE_EXPECTED_FILE);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────────────────

    /** Locate the eCH0271 input file (.xtf first, then .xml). */
    private static Path resolveEch0271File(String baseName) throws URISyntaxException, IOException {
        for (String suffix : new String[]{"-eCH0271.xtf", "-eCH0271.xml"}) {
            try {
                Path path = getResource(baseName + suffix);
                if (path != null && Files.exists(path)) {
                    return path;
                }
            } catch (NullPointerException ignored) {
                // getResource() throws NPE when the resource is not on the classpath
            }
        }
        throw new IllegalStateException("Cannot find eCH0271 file for: " + baseName);
    }

    /**
     * Run the single-step direct converter
     * {@code eCH-0271/fromECH0271.xsl} (XSLT 2.0, Saxon, no Java extensions).
     */
    private static Element transform(Path xmlFile, String datasetName) throws Exception {
        Path convertDir = findConvertDirectory();
        Path xslPath    = convertDir.resolve("eCH-0271/fromECH0271.xsl");

        if (!Files.exists(xslPath)) {
            throw new IllegalStateException("eCH0271 converter not found: " + xslPath);
        }

        // Load the stylesheet once per call (test overhead, acceptable here).
        // IMPORTANT: Set systemId on StreamSource so Saxon can resolve relative includes/imports.
        StreamSource xslSource = new StreamSource(xslPath.toFile());
        xslSource.setSystemId(xslPath.toUri().toString());
        Transformer transformer = TransformerFactoryFactory
            .getTransformerFactory()
            .newTransformer(xslSource);

        // Run the transform in memory.
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        transformer.transform(
            new StreamSource(xmlFile.toFile()),
            new StreamResult(out));

        String xml = out.toString(StandardCharsets.UTF_8.name());

        if (xml.isEmpty()) {
            throw new IllegalStateException("Transformer produced empty output for: " + datasetName);
        }

        // Save output for inspection.
        Path outPath = Paths.get("target/" + datasetName + "-ech0271-converted.xml");
        Files.createDirectories(outPath.getParent());
        Files.write(outPath, xml.getBytes(StandardCharsets.UTF_8));
        System.out.println("✓ eCH0271 converted output saved to: " + outPath);

        // Parse back to JDOM and return root element.
        SAXBuilder builder = new SAXBuilder();
        Document   doc     = builder.build(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));
        return doc.getRootElement();
    }

    /**
     * Run the reverse converter
     * {@code eCH-0271/toECH0271.xsl} (XSLT 2.0, Saxon, no Java extensions).
     * Converts ISO 19115-3:2018 back to eCH0271 INTERLIS.
     */
    private static Element reverseTransform(Path xmlFile, String datasetName) throws Exception {
        Path convertDir = findConvertDirectory();
        Path xslPath    = convertDir.resolve("eCH-0271/toECH0271.xsl");

        if (!Files.exists(xslPath)) {
            throw new IllegalStateException("eCH0271 reverse converter not found: " + xslPath);
        }

        // Load the stylesheet once per call (test overhead, acceptable here).
        // IMPORTANT: Set systemId on StreamSource so Saxon can resolve relative includes/imports.
        StreamSource xslSource = new StreamSource(xslPath.toFile());
        xslSource.setSystemId(xslPath.toUri().toString());
        Transformer transformer = TransformerFactoryFactory
            .getTransformerFactory()
            .newTransformer(xslSource);

        // Run the transform in memory.
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        transformer.transform(
            new StreamSource(xmlFile.toFile()),
            new StreamResult(out));

        String xml = out.toString(StandardCharsets.UTF_8.name());

        if (xml.isEmpty()) {
            throw new IllegalStateException("Reverse transformer produced empty output for: " + datasetName);
        }

        // Save output for inspection.
        Path outPath = Paths.get("target/" + datasetName + "-reverse-ech0271-converted.xtf");
        Files.createDirectories(outPath.getParent());
        Files.write(outPath, xml.getBytes(StandardCharsets.UTF_8));
        System.out.println("✓ Reverse eCH0271 output saved to: " + outPath);

        // Parse back to JDOM and return root element.
        SAXBuilder builder = new SAXBuilder();
        Document   doc     = builder.build(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));
        return doc.getRootElement();
    }

    /** Find the {@code convert/}} directory of the schema plugin. */
    private static Path findConvertDirectory() throws IOException {
        // Maven: the module's working directory is the module root.
        // Try standard module paths first.
        for (Path candidate : new Path[]{
            Paths.get("src/main/plugin/iso19115-3.2018.che/convert"),
            Paths.get("").toAbsolutePath().resolve("src/main/plugin/iso19115-3.2018.che/convert")
        }) {
            if (Files.exists(candidate) && Files.exists(candidate.resolve("eCH-0271/fromECH0271.xsl"))) {
                return candidate;
            }
        }

        // Walk up the directory tree.
        Path search = Paths.get("").toAbsolutePath();
        for (int depth = 0; depth < 6 && search != null && search.getNameCount() > 0; depth++) {
            Path candidate = search.resolve("src/main/plugin/iso19115-3.2018.che/convert");
            if (Files.exists(candidate) && Files.exists(candidate.resolve("eCH-0271/fromECH0271.xsl"))) {
                return candidate;
            }
            search = search.getParent();
        }

        // Search by marker file name.
        try (Stream<Path> walk = Files.walk(Paths.get("").toAbsolutePath(), 6)) {
            return walk
                .filter(Files::isDirectory)
                .filter(p -> p.endsWith("convert") &&
                             Files.exists(p.resolve("eCH-0271/fromECH0271.xsl")))
                .findFirst()

                .orElseThrow(() ->
                    new IllegalStateException(
                        "Cannot find convert/eCH-0271/fromECH0271.xsl in the workspace. "
                        + "Current directory: " + Paths.get("").toAbsolutePath()));
        }
    }
}
