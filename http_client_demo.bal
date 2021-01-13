import ballerina/http;
import ballerina/system;
import ballerina/io;

public function main() {

    //https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyDvbioXCN4NLXMWykAWC-v3_yx_czpONH0
    http:Client httpClient = new ("https://maps.googleapis.com");
    string apiKey = system:getEnv("GC_KEY");
    float lat = 0;
    float long = 0;
    var resp = check httpClient->get(string `/maps/api/geocode/json?latlng=${lat}.${long}&key=${apiKey}`);
    json jp = resp.getJsonPayload();

    json[] results = <json[]> jp.results;

    results.forEach(function (json result) {
        io:println(result.formatted_address);
    });

    // filter in one line
   foreach var item in results {
       io:println(item.'formatted\ address);
   }

    results = results.filter(x => x.toJsonString().length() > 10);
    // results = results.filter(function (json result) returns boolean){

    // });

    //Worker Example
    var resp2 = start httpClient->get(string `/maps/api/geocode/json?latlng=${lat}.${long}&key=${apiKey}`);
    future<http:Response|error> resp3 = start httpClient->get(string `/maps/api/geocode/json?latlng=${lat}.${long}&key=${apiKey}`);
    int x = 10;
    var respp = wait resp2;

    // POST example
    httpClient = new ("https://postman-echo.com");
    http:Request req = new;
    req.setHeader("h1","v1");
    respx = check httpClient->post("/post",req);
    io:println("Echo ", respx.getJsonPayload());
    
}                           