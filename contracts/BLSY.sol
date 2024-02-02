// Answerly.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ERC20.sol";

 contract BlueSkyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("BlueSkyToken", "BLSY", 18, initialSupply) {}
}
