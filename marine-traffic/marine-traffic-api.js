//run with > npx .\marine-traffic-api.js

//https://www.marinetraffic.com/en/ais-api-services/documentation/api-service:ps05

console.log('MT API Test');

const https = require("https");
const fs = require('fs');
var os = require('os');

/*

let csvData = "MMSI, IMO, SHIP_ID, LAT, LON, SPEED, HEADING, COURSE, STATUS, TIMESTAMP, DSRC, UTC_SECONDS" + os.EOL +
            "374428000,9836385,5826174,-35.083350,-52.870490,93,264,272,0,2020-08-11T17:33:00,SAT,44" + os.EOL +
            "374428000,9836385,5826174,-35.083350,-52.870490,93,264,272,0,2020-08-11T17:33:00,SAT,44" + os.EOL +
            "374428000,9836385,5826174,-35.083350,-52.870490,93,264,272,0,2020-08-11T17:33:00,SAT,44"
        

        let lines = csvData.split(os.EOL)
        if lines.length >1 {
            delete lines[0];
        }
        lines.forEach(
            (line) => {
                fs.appendFileSync('marine-traffic-response.csv', line + os.EOL);
            }
        )
            
        


return;
*/
function queryMarineTrafficAPI()
{
    let csvData;
    console.log('Running queryMarineTrafficAPI');
    
    //Trial TOKEN will expire con 18th August 2020

    const options = 
    {
    "method": "GET",
    "hostname": "services.marinetraffic.com",
    "port": 443,
    "path": "/api/exportvessels/v:8/4d5e9c1759e55e918c296a9aeb6b2f1a169b9f3e/timespan:10/protocol:csv",
    "headers": {
        "cache-control": "no-cache"
        }
    }
    const req = https.request(options, function(res) {

        var chunks = [];

        res.on("data", function (chunk) {
            chunks.push(chunk);
        });

        res.on("end", function() {
            var body = Buffer.concat(chunks);
            
            //write response to file
            csvData = body.toString();
            let lines = csvData.split(os.EOL)
            if (lines.length >1) {
                delete lines[0];
            }
            lines.forEach(
                (line) => {
                    fs.appendFileSync('marine-traffic-response.csv', line + os.EOL);
                }
            )

            console.log(body.toString());

            
        });

    });

    req.end()
    return 'OK';
}

module.exports.queryMarineTrafficAPI = queryMarineTrafficAPI;

/*
Simple response
Field Name	Data Type	Description
MMSI	integer	Maritime Mobile Service Identity - a nine-digit number sent in digital form over a radio frequency that identifies the vessel's transmitter station
IMO	integer	International Maritime Organisation number - a seven-digit number that uniquely identifies vessels
SHIP_ID	integer	A uniquely assigned ID by MarineTraffic for the subject vessel
LAT	real	Latitude - a geographic coordinate that specifies the north-south position of the vessel on the Earth's surface
LON	real	Longitude - a geographic coordinate that specifies the east-west position of the vessel on the Earth's surface
SPEED	integer	The speed (in knots x10) that the subject vessel is reporting according to AIS transmissions
HEADING	integer	The heading (in degrees) that the subject vessel is reporting according to AIS transmissions
COURSE	integer	The course (in degrees) that the subject vessel is reporting according to AIS transmissions
STATUS	integer	The AIS Navigational Status of the subject vessel as input by the vessel's crew - more. There might be discrepancies with the vessel's detail page when vessel speed is near zero (0) knots.
TIMESTAMP	date	The date and time (in UTC) that the subject vessel's position was recorded by MarineTraffic
DSRC	text	Data Source - Defines whether the transmitted AIS data was received by a Terrestrial or a Satellite AIS Station
UTC_SECONDS	integer	The time slot that the subject vessel uses to transmit information
*/