var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send("Main page").end();
});

app.listen(3000, function () {
  console.log('Server is listening on port 3000');
});