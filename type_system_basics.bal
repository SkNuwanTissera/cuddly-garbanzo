import ballerina/lang.'int as intlib;
import ballerina/io;
import ballerina/time;

type Author record {|
    string name;
    string[] books;
    int age;
|};

public function main() returns error? {
    int i = 0;
    float f = 1.1;
    decimal d = 1.25;
    boolean b = true;
    string s = "xxx";

    Author author1 = {name : "J.K Rowling" , books: ["Harry Potter", "Fantastic Beats"], age: 23};

    // JSON
    json msg = {name : "J.K Rowling" , books: ["Harry Potter", "Fantastic Beats"], age : 23};

    json[] books = <json[]> msg.books;
    json[] booksFiltered = books.filter(function (json book) returns boolean {
        return book.toString().length()>5;
    });

    Author entry1 = { age: check intlib:fromString(<string> check msg.age), books: [], name: <string> check msg.name};

    io:println("Entry ", entry);

    string|int|float input = "XXX";

    input = 10;

    if input is int {
        int x = input + 10;
    } else {
        if input is string {
            string x = input;
        } else {
           float x = input; 
        }
    }

    int|error result = 'intlib:fromString("123");
    if result is error {
        io:println("error :", result);
    } else {
        io:println("Result :", result);
    }

    io:println("Age -> ", calculateAge(io:readln("Enter birth year :")));

   
}

public function calculateAge(string birthYearInput) returns int|error {
    do {
        int result = check intlib:fromString(birthYearInput);
        return time:getYear(time:currentTime()) - result;
    } on fail error e {
        io:println("Error" ,e);
        return error("Error in calcualting age" + e.message());
    }

}

