const assert = require('assert');
var fs = require("fs");
var solc = require('solc');
 
const Artifactor = require("truffle-artifactor"); 
const TruffleContract = require('truffle-contract');

const Web3 = require("web3");
const util = require('util');
const provider = new Web3.providers.HttpProvider('http://hackaton.izx.io:18555')
const web3 = new Web3(provider);

// const sendAsyncPromisified = util.promisify(provider.sendAsync).bind(provider);
// var tmp_func = web3.eth.getBalance;
// delete tmp_func['call'];
// const getBlockNumberPromisified= util.promisify(web3.eth.getBlockNumber);
// const getBalancePromisified = util.promisify(tmp_func).bind(web3.eth);

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    console.log("Deploying artifact");
    Contract = new TruffleContract(require("../build/contracts/Mortgage.json"));
    web3.eth.getAccounts(async function(err, accounts) {
        if (err || !accounts){
            console.log(err);
            console.log("Second entry")
            return;
        }
        allAccounts = accounts;
        Contract.setProvider(web3.currentProvider);
        Contract.defaults({
            gas: 3.5e6,
            from: allAccounts[0]
        })
        console.log("Done");
    });
}  

main();