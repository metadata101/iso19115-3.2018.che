package org.fao.geonet.schema;

import org.xmlunit.assertj.XmlAssert;

import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.Assert.assertArrayEquals;

public class TestSupport {

    public static Path getResource(String name) throws URISyntaxException {
        return Paths.get(TestSupport.class.getClassLoader().getResource(name).toURI());
    }

    public static Path getResourceInsideSchema(String pathToResourceInsideSchema) throws URISyntaxException {
        return getResource("gn-site/WEB-INF/data/config/schema_plugins/iso19115-3.2018.che/" + pathToResourceInsideSchema);
    }

    public static void assertGeneratedDataByteMatchExpected(String expectedFileName, String actual, boolean generateExpectedFile) throws IOException, URISyntaxException {
        byte[] expected;
        if (generateExpectedFile) {
            generateFileWithData(expectedFileName, actual);
            expected = actual.getBytes(StandardCharsets.UTF_8);
        } else {
            expected = Files.readAllBytes(getResource(expectedFileName));
        }
        assertArrayEquals(expected, actual.getBytes(StandardCharsets.UTF_8));
    }

    private static void generateFileWithData(String expectedFileName, String actual) throws IOException {
        try (FileWriter fw = new FileWriter("src/test/resources/" + expectedFileName)) {
            fw.write(actual);
            fw.flush();
        }
    }

    static void assertGeneratedDataXmlMatchExpected(String expectedFilename, String actual, boolean generateExpectedFile) throws IOException, URISyntaxException {
        String expected;
        if (generateExpectedFile) {
            generateFileWithData(expectedFilename, actual);
            expected = actual;
        } else {
            expected = Files.readString(getResource(expectedFilename));
        }
        XmlAssert.assertThat(actual).isEqualTo(expected);
    }
}
