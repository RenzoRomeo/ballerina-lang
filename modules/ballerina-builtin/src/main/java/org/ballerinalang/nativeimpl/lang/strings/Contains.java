/*
 * Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.nativeimpl.lang.strings;

import org.ballerinalang.bre.Context;
import org.ballerinalang.model.types.TypeKind;
import org.ballerinalang.model.values.BBoolean;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.natives.AbstractNativeFunction;
import org.ballerinalang.natives.annotations.Argument;
import org.ballerinalang.natives.annotations.BallerinaFunction;
import org.ballerinalang.natives.annotations.ReturnType;

/**
 * Native function ballerina.model.strings:contains.
 *
 * @since 0.8.0
 */
@BallerinaFunction(
        packageName = "ballerina.lang.strings",
        functionName = "contains",
        args = {@Argument(name = "mainString", type = TypeKind.STRING),
                @Argument(name = "subString", type = TypeKind.STRING)},
        returnType = {@ReturnType(type = TypeKind.BOOLEAN)},
        isPublic = true
)
public class Contains extends AbstractNativeFunction {

    @Override
    public BValue[] execute(Context context) {
        String param1 = getStringArgument(context, 0);
        String subString = getStringArgument(context, 1);

        BBoolean isContains = new BBoolean(param1.contains(subString));
        return getBValues(isContains);

    }
}
