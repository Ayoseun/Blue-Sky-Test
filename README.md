# Hardhat-token-contract-erc20

This project includes the smart contract code for the BlueSkyToken ERC-20 token, along with instructions for setup, deployment, and any relevant changes.

## Contracts

The main contract file is `contracts/BLSY.sol`, which is an ERC-20 token implemented using Solidity. It inherits from a custom `ERC20` contract that provides additional functionalities like minting, burning, and a circuit breaker.

## Hardhat Configuration

The Hardhat configuration file is `hardhat.config.js`. It includes settings for the Solidity compiler, networks, and any additional plugins used in the project. Environment variables are managed using the `dotenv` package.

## Setup

1. **Install Dependencies:**

   ``` bash
   npm install

   ```

## Create Environment Variables:

Create a .env file in the project root with the following content:

```bash
MNEMONIC="your private key "
ALCHEMY_API_KEY="your Alchemy API key here"
```
Replace the placeholder values with your actual Ethereum wallet mnemonic and Infura API key.

## Compile Contracts:

```bash
npx hardhat compile
```

## Deployment
To deploy the Answerly token contract:

```bash
 npx hardhat run scripts/deploy.js --network mumbai
```
Make sure you have the Hardhat node running (npx hardhat node) if deploying to the local network.
