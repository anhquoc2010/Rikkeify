var express = require('express');

var server = express();

server.get('/.well-known/apple-app-site-association', function(request, response) {
  response.setHeader('content-type', 'application/json ');
  response.sendFile(__dirname +  '/apple-app-site-association');
});

server.get('/home', function(request, response) {
  response.sendFile(__dirname +  '/home.html');
});

server.listen(8100, () => {
  console.log('Server is running...')
})
