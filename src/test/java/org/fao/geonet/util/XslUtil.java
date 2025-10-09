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
import org.fao.geonet.api.records.attachments.Store;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.domain.MetadataResourceContainer;
import org.fao.geonet.languages.IsoLanguagesMapper;
import org.fao.geonet.utils.Xml;
import org.owasp.esapi.reference.DefaultEncoder;
import org.w3c.dom.Node;

import java.io.IOException;
import java.util.List;

public class XslUtil {
    public static Boolean IS_INSPIRE_ENABLED = false;

    public static String twoCharLangCode(String iso3code) {
        return twoCharLangCode(iso3code, iso3code.length() > 2 ? iso3code.substring(0, 2) : "FR");
    }

    public static String threeCharLangCode(String iso2code) {
        return "fre";
    }

    public static String getSettingValue(String key) {
        switch (key) {
            case "system/metadata/validation/removeSchemaLocation":
                return "false";
            case "system/inspire/enable":
                return IS_INSPIRE_ENABLED.toString();
            default:
                return "true";
        }
    }

    public static String twoCharLangCode(String iso3code, String defaultValue) {
        switch (iso3code) {
            case "fre":
                return "fr";
            case "ita":
                return "it";
            case "eng":
                return "en";
            case "ger":
                return "de";
            case "roh":
                return "rm";
            default:
                return defaultValue;
        }
    }

    public static String getJsonSettingValue(String key, String path) {
        return "true";
    }

    public static String getSiteUrl() {
        return "";
    }

    public static String escapeForJson(String value) {
        return StringEscapeUtils.escapeJson(value);
    }

    public static String getCodelistTranslation(Object codelist, Object value, Object langCode) {
        return String.format("%s--%s--%s", codelist, value, langCode);
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

    public static String getDefaultLangCode() {
        return Geonet.DEFAULT_LANGUAGE;
    }

    public static String getLanguage() {
        return getDefaultLangCode();
    }

    public static String getUiConfigurationJsonProperty(String key, String path) {
        return key + "-" + path;
    }

    public static String getBuildNumber() {
        return "buildNumber-666";
    }

    public static String encodeForJavaScript(String str) {
        return DefaultEncoder.getInstance().encodeForJavaScript(str);
    }

    public static boolean isDisableLoginForm() {
        return false;
    }

    public static boolean isShowLoginAsLink() {
        return false;
    }

    public static boolean isUserProfileUpdateEnabled() {
        return true;
    }

    public static boolean isUserGroupUpdateEnabled() {
        return true;
    }

    public static MetadataResourceContainer getResourceContainerDescription(String metadataUuid, Boolean approved) throws Exception {
        return null;
    }

    public static Store.ResourceManagementExternalProperties getResourceManagementExternalProperties() {
        return null;
    }

    public static String escapeForEcmaScript(String value) {
        return StringEscapeUtils.escapeEcmaScript(value);
    }

    public static String iso639_2T_to_iso639_2B(String iso639_2T) {
        return IsoLanguagesMapper.iso639_2T_to_iso639_2B(iso639_2T);
    }

    public static String xmlToJson(Object xml) {
        try {
            return Xml.getJSON(xml.toString());
        } catch (IOException e) {
           e.printStackTrace();
        }
        return "";
    }

}
