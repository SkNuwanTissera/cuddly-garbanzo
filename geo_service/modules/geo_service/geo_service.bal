 import ballerina/http;
 import ballerina/java.jdbc;

 type Entry record {|
    float lat;
    float long;
    string src = "UNKNOWN";
    string address;
    string ref?;
 |};

jdbc:Client dbClient = check new ("jdbc:mysql://localhost:3306/GEO_DB?serverTimeZone=UTC", "root", "rootroot");

// map to store _InMemory cache
 map<Entry> entries = {};

 @http:ServiceConfig {
     basePath : "/"
 }

service geoService on new http:Listener(8989) {
    @http:ResourceConfig {
        path:"/lookup/{lat}/{long}",
        methods: ["GET"]
    }

    resource function lookup (http:Caller caller, http:Request request, float lat, float long) returns @tainted error? {
        //In memory cache
        //Entry? entry = entries[{lat, long}.toString];

        //DB cache
        transaction{
            stream<record{}, error> rs = dbClient->query('SELECT address FROM GEO_ENTRY 
                                                        WHERE lat = ${<@untainted> lat} AND long = ${<@untainted> long});

            record {|record {} value;|}? entry = check rs.next();

            if entry is record {|record {} value|}{
                address = <@untainted> <string> entry.value["address"];
                check caller -> ok(address);
            }
            
            if entry is Entry {
                check caller->ok(entry.address);
            } else {
                check caller->notFound();
            }
            check commit;
        }

    }

    @http:ResourceConfig {
        path:"/store",
        methods:["POST"],
        body : "entry"
    }

    resource function store (http:Caller caller, http:Request request, Entry entry) returns error? {
        //Inbuilt memory
        // entries[{lat: entry.lat , long: entry.long}.toString] = <@untainted> entry;

        //DB persist
        _= check dbClient->execute(`INSERT INTO GEO_ENTRY (lat, lng, src, address, ref) VALUES
                                    (${<@untainted> entry.lat}, ${<@untainted> entry.long}, ${<@untainted> entry.src}, ${<@untainted> entry.address}, ${<@untainted> entry.ref})
                                    `);


                            
        check caller->ok();
    }

}