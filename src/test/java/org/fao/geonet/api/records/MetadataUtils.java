package org.fao.geonet.api.records;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.DOMOutputter;
import org.w3c.dom.Node;

public class MetadataUtils {
    public static Node getAssociatedAsXml(String metadataUuid) {
        Element relations = new Element("relations");

        DOMOutputter outputter = new DOMOutputter();

        try {
            return outputter.output(new Document(relations));
        } catch (JDOMException e) {
            throw new RuntimeException(e);
        }
    }
}
