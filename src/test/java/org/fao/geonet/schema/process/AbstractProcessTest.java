package org.fao.geonet.schema.process;

import org.fao.geonet.schema.IndexationTest;
import org.fao.geonet.utils.ResolverWrapper;
import org.fao.geonet.utils.TransformerFactoryFactory;
import org.junit.AfterClass;
import org.junit.BeforeClass;

import java.lang.reflect.Field;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.util.Map;

public abstract class AbstractProcessTest {
	protected static final boolean GENERATE_EXPECTED_FILE = false;
	private static Field resolverMapField;

	@BeforeClass
	public static void initSaxon() {
		TransformerFactoryFactory.init("net.sf.saxon.TransformerFactoryImpl");
	}

	@BeforeClass
	public static void initOasis() throws NoSuchFieldException, IllegalAccessException, URISyntaxException {
		resolverMapField = ResolverWrapper.class.getDeclaredField("resolverMap");
		resolverMapField.setAccessible(true);
		((Map<?, ?>) resolverMapField.get(null)).clear();
		ResolverWrapper.createResolverForSchema("DEFAULT", Path.of(IndexationTest.class.getClassLoader().getResource("gn-site/WEB-INF/oasis-catalog.xml").getPath()));
	}

	@AfterClass
	public static void clearOasis() throws IllegalAccessException {
		((Map<?, ?>) resolverMapField.get(null)).clear();
	}
}
