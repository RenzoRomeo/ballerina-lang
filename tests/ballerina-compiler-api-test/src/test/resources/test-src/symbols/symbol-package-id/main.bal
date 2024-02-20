// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
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
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

// table type
type Employee record {|
    readonly int id;
    string firstName;
    string lastName;
    int salary;
|};

type UserTable table<Employee> key(id);

// future type
type UserFuture future<int>;

// xml type
type UserXml_1 xml;
type UserXml_2 xml<xml:Element>;

// stream type
type UserStream stream<int>;

// typedesc type
type UserTypedesc_1 typedesc<int>;
type UserTypedesc_2 typedesc<Employee>;
