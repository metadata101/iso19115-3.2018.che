package org.fao.geonet.api.records.formatters;

import org.jdom.JDOMException;

import java.io.IOException;

public class SchemaLocalizations {

	public static SchemaLocalizations create(String schema, final String lang3) throws IOException, JDOMException {
		return new SchemaLocalizations();
	}

	public String codelistValueLabel(String codelist, String value) throws Exception {
		return String.format("cl_%s#%s", codelist, value);
	}
}
