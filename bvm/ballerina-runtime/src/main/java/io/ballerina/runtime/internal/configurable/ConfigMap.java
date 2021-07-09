/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.runtime.internal.configurable;

import io.ballerina.runtime.internal.configurable.providers.toml.ConfigValueCreator;
import io.ballerina.toml.semantic.ast.TomlNode;

import java.util.HashMap;
import java.util.Map;

/**
 * Singleton class that holds runtime configurable values.
 *
 * @since 2.0.0
 */
public class ConfigMap {
    private static Map<VariableKey, Object> configurableMap = new HashMap<>();
    private static final ConfigValueCreator valueCreator = new ConfigValueCreator();

    private ConfigMap(){}

    public static Object get(VariableKey key) {
        Object value = configurableMap.get(key);
        if (value instanceof TomlNode) {
            return valueCreator.retrieveValue((TomlNode) value, key.variable, key.type);
        }
        return value;
    }

    public static boolean containsKey(VariableKey key) {
        return configurableMap.containsKey(key);
    }

    public static void setConfigurableMap(Map<VariableKey, Object> configurableMap) {
        ConfigMap.configurableMap = configurableMap;
    }
}
