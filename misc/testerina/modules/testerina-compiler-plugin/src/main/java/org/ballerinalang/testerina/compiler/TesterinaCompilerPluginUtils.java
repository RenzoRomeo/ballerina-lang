/*
 *  Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinalang.testerina.compiler;

import io.ballerina.projects.Project;
import io.ballerina.projects.ProjectKind;

/**
 * Testerina compiler plugin utils for the Testerina module.
 *
 * @since 2201.3.0
 */
public class TesterinaCompilerPluginUtils {

    /**
     * Returns true if a project is single file project kind.
     * @param project
     * @return is single file project
     */
    public static boolean isSingleFileProject(Project project) {
        boolean isSingleFileProject = false;
        if (project.kind() == ProjectKind.SINGLE_FILE_PROJECT) {
            isSingleFileProject = true;
        }
        return isSingleFileProject;
    }
}
