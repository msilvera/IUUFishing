let mt_api = require('./marine-traffic-api');


var minutes = 2, the_interval = minutes * 60 * 1000;
setInterval(function() {
  console.log("I am doing my 2 minutes check");
  mt_api.queryMarineTrafficAPI();
  
}, the_interval);