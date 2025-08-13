package org.fao.geonet.schema;

import org.fao.geonet.schema.iso19115_3_2018_che.ISO19115_3_2018SchemaPlugin;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:config-spring-geonetwork.xml"})
public class LoadSchemaBeanTest {

	@Autowired
	ApplicationContext applicationContext;

	@Test
	public void nominal() {
		assertNotNull(applicationContext.getBean("iso19115-3.2018.cheSchemaPlugin"));
	}

	@Test
	public void cswOutputSchemaAndTypeNames() {
		ISO19115_3_2018SchemaPlugin schemaPlugin = (ISO19115_3_2018SchemaPlugin) applicationContext.getBean("iso19115-3.2018.cheSchemaPlugin");

		assertEquals("https://www.ech.ch/ech/ech-0271/1.0.0", schemaPlugin.getOutputSchemas().get("ech-0271"));
		assertEquals("http://geocat.ch/che", schemaPlugin.getCswTypeNames().get("che:CHE_MD_Metadata").getURI());
		assertEquals("che", schemaPlugin.getCswTypeNames().get("che:CHE_MD_Metadata").getPrefix());
	}
}
