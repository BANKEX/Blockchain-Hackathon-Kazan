var express = require('express');
var ejsLocals = require('ejs-locals');
var app = express();
var apiV1 = require('./api.v1');
pages = require(__dirname + '/controllers/pages')

app.engine('ejs', ejsLocals)
app.set('views', __dirname + '/views')
app.set('view engine', 'ejs')

app.use(express.static(__dirname + '/public'));

app.use('/api/v1', apiV1);

app.get('/', function (req, res)
	{ res.redirect('home')
});

app.get('/home', pages.home);

app.get('/deploy', pages.deploy);

app.get('/execution/:address', pages.execution);

app.listen(3000, function () {
  console.log('Server is listening on port 3000...');
});