/*
 * Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.stdlib.crypto.nativeimpl;

import org.ballerinalang.bre.Context;
import org.ballerinalang.bre.bvm.BlockingNativeCallableUnit;
import org.ballerinalang.model.types.TypeKind;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.model.values.BValueArray;
import org.ballerinalang.natives.annotations.Argument;
import org.ballerinalang.natives.annotations.BallerinaFunction;
import org.ballerinalang.natives.annotations.ReturnType;
import org.ballerinalang.stdlib.crypto.util.HashUtils;

/**
 * Extern function ballerina.crypto:getHmac.
 *
 * @since 0.8.0
 */
@BallerinaFunction(
        orgName = "ballerina", packageName = "crypto",
        functionName = "hmac",
        args = {
                @Argument(name = "input", type = TypeKind.ARRAY, elementType = TypeKind.BYTE),
                @Argument(name = "key", type = TypeKind.ARRAY, elementType = TypeKind.BYTE)
        },
        returnType = {@ReturnType(type = TypeKind.ARRAY, elementType = TypeKind.BYTE)},
        isPublic = true
)
public class HmacSha256 extends BlockingNativeCallableUnit {

    @Override
    public void execute(Context context) {
        BValue inputBValue = context.getRefArgument(0);
        BValue keyBValue = context.getRefArgument(1);

        byte[] inputValue = ((BValueArray) inputBValue).getBytes();
        byte[] keyValue = ((BValueArray) keyBValue).getBytes();
        byte[] output = HashUtils.hmac(context, inputValue, keyValue, "HmacSHA1");
        context.setReturnValues(new BValueArray(output));
    }
}
