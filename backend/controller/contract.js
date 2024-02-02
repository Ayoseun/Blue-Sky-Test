const { contractAddress, ABI, rpc, privateKey } = require('../common/constants')
var ethers = require('ethers')
let provider = new ethers.JsonRpcProvider(rpc)
let contract = new ethers.Contract(contractAddress, ABI, provider)
let signer = new ethers.Wallet(privateKey, provider)
let txSigner = contract.connect(signer)
const handleContractError = (res, error) => {
  console.error('Contract error:', error);
  res.status(500).send(`Contract error: ${error.message}`);
};

exports.getSymbol = async (req, res) => {
  try {
    const symbol = await contract.symbol();
    res.send(`Contract Symbol is ${symbol}`);
  } catch (error) {
    handleContractError(res, error);
  }
};

exports.getName = async (req, res) => {
  try {
    const name = await contract.name();
    res.send(`Contract Name is ${name}`);
  } catch (error) {
    handleContractError(res, error);
  }
};

exports.getTotalSupply = async (req, res) => {
  try {
    const totalSupply = await contract.totalSupply();
    res.send(`Contract total supply is ${ethers.formatEther(totalSupply)}`);
  } catch (error) {
    handleContractError(res, error);
  }
};

exports.transfer = async (req, res) => {
  try {
    const wallet = req.body.receiverAddress;
    const amount = ethers.parseUnits(req.body.amount, 18);
    await txSigner.transfer(wallet, amount);
   contract.on("Transfer", (from, to, amount, event) => {
    if (to === wallet) {
      res.send(`Transfer from ${from} to ${to} of ${ethers.formatEther(amount)} tokens`)
   
    }
  });
   
  } catch (error) {
    handleContractError(res, error);
  }
};

exports.getBalanceOfAccount = async (req, res) => {
  try {
    const wallet = req.body.walletAddress;
    const balance = await contract.balanceOf(wallet);
    res.json({ wallet, balance: ethers.formatEther(balance) });
  } catch (error) {
    handleContractError(res, error);
  }
};
