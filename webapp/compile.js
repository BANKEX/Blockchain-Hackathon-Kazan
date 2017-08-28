const assert = require('assert');
var fs = require("fs");
var solc = require('solc');
 
const Artifactor = require("truffle-artifactor"); 
const TruffleContract = require('truffle-contract');

const Web3 = require("web3");
const util = require('util');

// const web3 = new Web3(new Web3.providers.HttpProvider('http://hackaton.izx.io:18555'));

// const sendAsyncPromisified = util.promisify(provider.sendAsync).bind(provider);
// var tmp_func = web3.eth.getBalance;
// delete tmp_func['call'];
// const getBlockNumberPromisified= util.promisify(web3.eth.getBlockNumber);
// const getBalancePromisified = util.promisify(tmp_func).bind(web3.eth);
const artifactor = new Artifactor("./build/contracts");
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    console.log("Compiling artifact");
    var input = fs.readFileSync("./contracts/Mortgage.sol");
    var output = solc.compile(input.toString(), 1);
    console.log(output.errors);
    var bytecode = output.contracts[':Mortgage'].bytecode;
    var abi = JSON.parse(output.contracts[':Mortgage'].interface);
    await artifactor.save({contract_name: "Mortgage",  abi: abi, unlinked_binary: bytecode});

    // input = fs.readFileSync("../contracts/MortgageRegistry.sol");
    // output = solc.compile(input.toString(), 1);
    // console.log(output.errors);
    // bytecode = output.contracts[':MortgageRegistry'].bytecode;
    // abi = JSON.parse(output.contracts[':MortgageRegistry'].interface);
    // await artifactor.save({contract_name: "MortgageRegistry",  abi: abi, unlinked_binary: bytecode});

    console.log("Done");
}  

main();