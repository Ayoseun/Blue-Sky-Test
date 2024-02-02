require('dotenv').config()

const ABI = [
  'function decimals() view returns (uint8)',
  'function symbol() view returns (string)',
  'function name() view returns (string)',
  'function totalSupply() external view returns (uint256)',
  'function balanceOf(address account) external view returns (uint256)',
  'function transfer( address to,uint256 value) external returns (bool)',
  'event Transfer(address indexed from, address indexed to, uint amount)'
]
const contractAddress = process.env.CONTRACT_ADDRESS
const privateKey = process.env.PRIVATE_KEY
const rpc = process.env.RPC
module.exports = {
  ABI,
  contractAddress,
  privateKey,
  rpc,
}
