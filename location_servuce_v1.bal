import ballerina/http;
import ballerina/system;

type Person record {
    string name;
    int age?;
};

@http:ServiceConfig {
    basePath: "/"
}

service locationService on new http:Listener(8089){

    @http: ResourceConfig {
        methods : ["GET"],
        body: "person"
    }

    resource function mylocation(http:Caller caller, http:Request request) returns @tainted error? {
        http:Client gClient = new ("https://www.googleapis.com");
        string apiKey = system:getEnv("GC_KEY");
        json payload = { considerIp: true };
        var resp = check gClient->post(string `/geolocation/v1/geolocate?key=${apiKey}`, payload);
        json jr = <@untainted> check resp.getJsonPayload();
        from var item in locationInfo.results
        check caller->ok(jr);

        Person p1 = { name : "X"};
        int? age = p1?.age;
        p1.name = "XX";
        p1["school"] = "standford";
    }
}