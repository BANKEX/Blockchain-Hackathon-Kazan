var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser')

var jsonBodyParser = bodyParser.json();

router.get('/', function (req, res) {
    res.json([]);
});

router.post('/register/lender', jsonBodyParser, function (req, res) {
    var address = req.body.address;
    console.log(address);
    res.json({ address: address, ok: true });
});

module.exports = router;