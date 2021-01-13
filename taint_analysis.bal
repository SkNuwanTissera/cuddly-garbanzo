import ballerina/io;

public function main(string... args) {

    if(args[0].length() > 10){
        io:println("Error : too long");
    } else {
        mySecureFunction(<@untainted> args[0]);
    }

    mySecureFunction(<@untainted> args[0]);
    string s1 = "abc";
    string s2 = <@tainted> s1;
    string s2x = s2 + "abc";

    mySecureFunction(<@untainted> getUnverifiedData());
}

public function mySecureFunction(@untainted string input) {
    io:println(input);
}
 
public function getUnverifiedData() returns @tainted string {
    return <@tainted> "XXX";
}