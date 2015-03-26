var countries  = require('country-data').countries;


var fs  = require("fs");
var array = fs.readFileSync('../flags.css').toString().split('\n');
var lookup = require('country-data').lookup;

array.forEach(function(line) {
  if ( line.match(/flag-.. /)) {
    nation =  line.match(/flag-(..) /)[1];
    code = lookup.countries({ alpha2:nation})[0].ioc;
    console.log(line.replace(/flag-.. /, 'flag-' + code + ' ' ));
  }
});




//countries.all.forEach(function(entry) {
//    console.log(entry.ioc);
//});
