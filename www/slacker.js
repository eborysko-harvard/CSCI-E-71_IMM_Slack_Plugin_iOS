

var pluginName = "immSlackClient";

var Slacker = function () {};
Slacker.authenticate = function() {
    cordova.exec(function callback(data){
                 ''
                 },function errorHandler(err){
                 ''
                 },pluginName, 'cordovaSlackAuthenticate', []);
}

Slacker.presence = function(userid) {
    cordova.exec(function callback(data){
                 ''
                 },function errorHandler(err){
                 ''
                 },pluginName, 'cordovaSlackPresence', [userid]);
}


function errorHandlerFunction(err)
{
    alert(err);
}
