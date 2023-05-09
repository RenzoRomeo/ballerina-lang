// Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;

public class Listener {

    private string name = "";

    public function init(string name) {
        self.name = name;
        io:println("Calling init for " + self.name);
    }

    public function attach(service object {} s, string[]|string? name = ()) returns error? {
        io:println("Calling attach for " + self.name);
    }

    public function detach(service object {} s) returns error? {
        io:println("Calling detach for " + self.name);
    }

    public function 'start() returns error? {
        io:println("Calling start for " + self.name);
    }

    public function gracefulStop() returns error? {
        io:println("Calling stop for " + self.name);
    }

    public function immediateStop() returns error? {
        io:println("Calling immediateStop for " + self.name);
    }
}

listener Listener ep = new Listener("'moduleA listener'");

public function intAdd(int a, int b) returns int {
    return a + b;
}
