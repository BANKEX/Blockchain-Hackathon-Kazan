var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var ethAdapter = require('./eth/adapter');

var jsonBodyParser = bodyParser.json();

router.get('/accounts', function (req, res) {
    res.json(ethAdapter.accounts);
});

router.post('/contracts/deploy', jsonBodyParser, function (req, res) {
    console.log(req.body);

    setTimeout(function () {
        var parties = [req.body.bank, req.body.borrower];

        if (req.body.coborrower)
            parties.push(req.body.coborrower);

        ethAdapter.deployContract(parties, req.body.registry, req.body.depository, function (address) {
            res.json({ address: address, ok: true });
        });
    }, 1500);
});

router.post('/register/lender', jsonBodyParser, function (req, res) {
    var address = req.body.address;
    console.log(address);
    res.json({ address: address, ok: true });
});

module.exports = router;