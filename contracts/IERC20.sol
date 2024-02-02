// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Interface for ERC-20 functions
interface IERC20 {
    // Returns the total supply of the token
    function totalSupply() external view returns (uint256);

    // Returns the balance of the specified account
    function balanceOf(address account) external view returns (uint256);

    // Transfers `value` amount of tokens to the specified `to` address
    function transfer(address to, uint256 value) external returns (bool);

    // Returns the amount of tokens that `spender` is allowed to spend on behalf of `owner`
    function allowance(address owner, address spender) external view returns (uint256);

    // @dev Approves `spender` to spend `value` amount of tokens on behalf of the caller
    function approve(address spender, uint256 value) external returns (bool);

    // Transfers `value` amount of tokens from `from` to `to`
    function transferFrom(address from, address to, uint256 value) external returns (bool);

    // Event emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Event emitted when approval is granted for token spending
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Interface for additional mint and burn functions
interface ITokenExtras {
    // @dev Mints `value` amount of tokens and assigns them to the specified `to` address
    function mint(address to, uint256 value) external;

    // @dev Burns `value` amount of tokens from the caller's balance
    function burn(uint256 value) external;

    // Event emitted when new tokens are minted
    event Mint(address indexed to, uint256 value);

    // Event emitted when tokens are burned
    event Burn(address indexed from, uint256 value);
}

// Interface for ERC-20 metadata
interface IERC20Metadata is IERC20 {
    // Returns the name of the token
    function name() external view returns (string memory);

    // Returns the symbol of the token
    function symbol() external view returns (string memory);

    // Returns the number of decimals used to display token values
    function decimals() external view returns (uint8);
}
