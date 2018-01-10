var server = require('http').createServer();
var io = require('socket.io')(server);

var port = 3000

io.on('connection', function(client){
    console.log("connection from")
    client.on('event', function(data){});
    client.on('disconnect', function(){});
});
server.listen(port);

// var io = require('socket.io')();
// io.on('connection', function(client){console.log("connected")});
// io.listen(3000);

console.log("listening on port: " + port)
