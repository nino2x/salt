var os = require('os');
var http = require('http');

http.createServer(function (req, res) {
  var interfaces = os.networkInterfaces();
  var addresses = [];
  for (k in interfaces) {
      for (k2 in interfaces[k]) {
          var address = interfaces[k][k2];
          if (address.family == 'IPv4' && !address.internal) {
              addresses.push(address.address)
          }
      }
  }


  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(JSON.stringify(addresses));
}).listen(8451, '0.0.0.0');
console.log('Server listening on port 8451');
