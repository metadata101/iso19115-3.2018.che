package org.fao.geonet.schema;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:config-spring-geonetwork.xml"})
public class LoadSchemaBean {

	@Autowired
	ApplicationContext applicationContext;

	@Test
	public void nominal() {
		assertNotNull(applicationContext.getBean("iso19115-3.2018.cheSchemaPlugin"));
	}
}
