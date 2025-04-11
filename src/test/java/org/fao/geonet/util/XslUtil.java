/*
 * Copyright (C) 2001-2024 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */
package org.fao.geonet.util;

import org.apache.commons.text.StringEscapeUtils;
import org.w3c.dom.Node;

import java.util.List;

public class XslUtil {
    public static String twoCharLangCode(String iso3code) {
        return iso3code.substring(0, 2);
    }

    public static String threeCharLangCode(String iso2code) {
        return "fre";
    }

    public static String getJsonSettingValue(String key, String path) {
        return "true";
    }

    public static String getSettingValue(String key) {
        return "true";
    }

    public static String getSiteUrl() {
        return "";
    }

    public static String escapeForJson(String value) {
        return StringEscapeUtils.escapeJson(value);
    }

    public static String getCodelistTranslation(Object codelist, Object value, Object langCode) {
        return (String) value;
    }

    public static List<String> getKeywordHierarchy(String keyword, String thesaurusId, String langCode) {
        return List.of();
    }

    public static String getKeywordUri(String keyword, String thesaurusId, String langCode) {
        return "";
    }

    public static String getThesaurusIdByTitle(String title) {
        return "";
    }

    public static Node getUrlContent(String surl) {
        return null;
    }

    public static Node getRecord(String uuid) {
        return null;
    }

    public static String gmlToGeoJson(String gml, Boolean applyPrecisionModel, Integer numberOfDecimals) {
        return "";
    }

    public static String getIndexField(Object appName, Object uuid, Object field, Object lang) {
        return "";
    }

}
