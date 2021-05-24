type Customer record {
  readonly int id;
  readonly  string firstName;
  string lastName;
};

type Person record {
    string name;
    readonly int age;
};

type CustomerTable table<Customer> key(id);
type GlobalTable table<Person> key<string>;

CusTable tab1 = table key(id, firstName) [
 { id: 222, firstName: "Sanjiva", lastName: "Weerawarana" },
 { id: 111, firstName: "James", lastName: "Clark" }
];

CustomerTable tab2 = table key(id, firstName) [
 { id: 222, firstName: "Sanjiva", lastName: "Weerawarana" },
 { id: 111, firstName: "James", lastName: "Clark" }
];

GlobalTable tab3 = table [
  { name: "AAA", age: 31 },
  { name: "BBB", age: 34 }
];

GlobalTable tab4 = table key(age) [
  { name: "AAA", age: 31 },
  { name: "BBB", age: 34 }
];

CustomerTable invalidCustomerTable = table key(address) [
 { id: 222, firstName: "Sanjiva", lastName: "Weerawarana" },
 { id: 111, firstName: "James", lastName: "Clark" }
];

var customerTable = table [
 { id: 222, firstName: "Sanjiva", lastName: "Weerawarana" },
 { id: 111, firstName: "James", lastName: "Clark" }
];

Customer customer = customerTable[222];

table<int> tableWithInvalidConstarint = table [];

function testArrayAccessWithMultiKey() returns (string) {
    map<any> namesMap = {fname:"Supun",lname:"Setunga"};
    string keyString = "";
    var a = namesMap["fname","lname"];
    keyString =  a is string ? a : "";
    return keyString;
}

type Teacher record {
    string name;
    int age;
};

type TeacherTable table<Teacher> key(name);

TeacherTable teacheTab = table [
    { name: "AAA", age: 31 },
    { name: "BBB", age: 34 }
    ];

type User record {
    readonly int id;
    readonly string name?;
    string address;
};

type UserTable table<User> key(id, name);

UserTable userTab = table [{ id: 13 , name: "Sanjiva", address: "Weerawarana" },
                                                   { id: 45 , name: "James" , address: "Clark" }];

table<Customer> keylessCusTab  = table [{ id: 222, firstName: "Sanjiva", lastName: "Weerawarana" },
                                    { id: 111, firstName: "James", lastName: "Clark" }];

Customer customerRecord = keylessCusTab[222];

table<Customer> key<int> intKeyConstraintTable = table key(id)[{ id: 13 , firstName: "Sanjiva", lastName: "Weerawarana" },
                                                { id: 23 , firstName: "James" , lastName: "Clark" }];

table<Customer> key<string> stringKeyConstraintTable = intKeyConstraintTable;

type UserCustTable table<User|Customer> key<int>;

type UserInfoTable table<User> key<int> | table<Customer> key<int>;

function testInvalidKeyForInferTypeTable() {
    var tab = table key(no) [{ id: 13 , name: "Sanjiva", lname: "Weerawarana" },
                                        { id: 23 , name: "James" },
                                       { id: 133 , name: "Mohan", lname: "Darshan" , address: "Colombo"} ];
}

function testRequiredFieldForInferTypeTable() {
    var tab = table key(address) [{ id: 13 , name: "Sanjiva", lname: "Weerawarana" },
                                        { id: 23 , name: "James" },
                                       { id: 133 , name: "Mohan", lname: "Darshan" , address: "Colombo"} ];
}

function testMapConstraintTableWithKeySpecifier() {
    table<map<any>> key(lname) tab = table key() [{ id: 13 , name: "Sanjiva", lname: "Weerawarana" },
                                            { id: 23 , name: "James" },
                                           { id: 133 , name: "Mohan", lname: "JJ" , address: "Colombo"} ];
}

function testMemberAccessMapConstraintTable() {
    table<map<any>> key(id) tab = table key() [{ id: 13 , name: "Sanjiva", lname: "Weerawarana" },
                                            { id: 23 , name: "James" },
                                           { id: 133 , name: "Mohan", lname: "JJ" , address: "Colombo"} ];

    map<any> mapObject = tab[13];
}

function testInferMemberType() {

   var arr = table [{ id: 13 , name: "Sanjiva", address: "Weerawarana" },
                            { id: "Hello" , name: "James" , address: "Clark" }];
}

function testVarTypeTableInfering() {
    var customerTable = table [];
    customerTable.put({id: 3, name: "Pope", age: 19, address: {no: 12, road: "Sea street"}});
}

function testMemberAccessWithInvalidStaticType() {
    table<Customer> key(id) customerTable = table [{ id: 13 , firstName: "Sanjiva", lastName: "Weerawarana" },
                                        { id: 23 , firstName: "James" , lastName: "Clark" }];
    Customer customer = customerTable[18];
}

function testMemberAccessWithInvalidStaticType2() {
    UserCustTable userTab = table key(id) [{ id: 13 , name: "Sanjiva", address: "Weerawarana" },
                                                   { id: 45 , name: "James" , address: "Clark" }];
    User user = userTab[18];
}

function testMemberAccessWithInvalidStaticType3() {
    UserInfoTable infoTab = table key(id) [{ id: 13 , name: "Sanjiva", address: "Weerawarana" },
                                                   { id: 45 , name: "James" , address: "Clark" }];
    table<Customer> key(id) tab = <table<Customer> key(id)> infoTab;
    Customer customer = tab[18];
}

type Employee record {
    string name;
    readonly int age;
};

type EmployeeTable table<Employee> key(name);

class A {

}

readonly & A[] a = [];

type Row record {
    readonly A[] k;
    int value;
};

table<Row> key(k) t = table [
    { k: a, value: 17, "b":12}
];
