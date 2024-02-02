// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./IERC20.sol";

/**
 * @dev Standalone ERC-20 token contract that implements additional mint, burn, and metadata functions.
 */
 contract ERC20 is IERC20, ITokenExtras, IERC20Metadata {
    // Token metadata
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    // Balances of all token holders
    mapping(address => uint256) private _balances;

    // Allowances for token spending (owner => spender => allowed amount)
    mapping(address => mapping(address => uint256)) private _allowances;

    // Total supply of the token
    uint256 private _totalSupply;

    // Owner of the contract
    address private _owner;

    // Flag to indicate if the contract is paused
    bool private _paused;

    // Modifier: Only allows the owner to call the function
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the owner can call this function");
        _;
    }

    // Modifier: Only allows the function to be called when the contract is not paused
    modifier whenNotPaused() {
        require(!_paused, "Contract is paused");
        _;
    }

    /**
     * @dev Constructor to initialize the token.
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     * @param decimals_ The number of decimals used for display purposes.
     * @param initialSupply The initial supply of tokens.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 initialSupply
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = initialSupply * (10 ** uint256(decimals_));
        _balances[msg.sender] = _totalSupply;
        _owner = msg.sender;
        _paused = false;
        // Emitting the Transfer event for the initial supply
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    /**
     * @dev Mint new tokens and assign them to the specified address.
     * @param to The address to which the new tokens will be minted.
     * @param value The amount of tokens to mint.
     */
    function mint(
        address to,
        uint256 value
    ) external override onlyOwner whenNotPaused {
        require(to != address(0), "ERC20: mint to the zero address");

        _balances[to] += value;
        _totalSupply += value;

        // Emitting Mint and Transfer events
        emit Mint(to, value);
        emit Transfer(address(0), to, value);
    }

    /**
     * @dev Burn tokens from the caller's balance.
     * @param value The amount of tokens to burn.
     */
    function burn(uint256 value) external override whenNotPaused {
        require(
            _balances[msg.sender] >= value,
            "ERC20: insufficient balance for burn"
        );

        _balances[msg.sender] -= value;
        _totalSupply -= value;

        // Emitting Burn and Transfer events
        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value);
    }

    /**
     * @dev Returns the total supply of the token.
     * @return The total supply of the token.
     */
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Transfer tokens to a specified address.
     * @param to The address to which tokens will be transferred.
     * @param value The amount of tokens to transfer.
     * @return A boolean indicating whether the transfer was successful.
     */
    function transfer(
        address to,
        uint256 value
    ) external override whenNotPaused returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[msg.sender] >= value, "ERC20: insufficient balance");

        _balances[msg.sender] -= value;
        _balances[to] += value;

        // Emitting Transfer event
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Returns the balance of the specified account.
     * @param account The address for which the balance is queried.
     * @return The balance of the specified account.
     */
    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev Returns the allowance for spending tokens by a spender on behalf of an owner.
     * @param owner The owner's address.
     * @param spender The spender's address.
     * @return The allowance for spending tokens.
     */
    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev Approve a spender to spend a certain amount of tokens on behalf of the caller.
     * @param spender The address to which spending approval is granted.
     * @param value The amount of tokens to approve for spending.
     * @return A boolean indicating whether the approval was successful.
     */
    function approve(
        address spender,
        uint256 value
    ) external override whenNotPaused returns (bool) {
        _allowances[msg.sender][spender] = value;

        // Emitting Approval event
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * @param from The address from which tokens will be transferred.
     * @param to The address to which tokens will be transferred.
     * @param value The amount of tokens to transfer.
     * @return A boolean indicating whether the transfer was successful.
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override whenNotPaused returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= value, "ERC20: insufficient balance");
        require(
            _allowances[from][msg.sender] >= value,
            "ERC20: insufficient allowance"
        );

        _balances[from] -= value;
        _balances[to] += value;
        _allowances[from][msg.sender] -= value;

        // Emitting Transfer event
        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Pause the contract, only callable by the owner.
     */
    function pause() external onlyOwner {
        _paused = true;
    }

    /**
     * @dev Unpause the contract, only callable by the owner.
     */
    function unpause() external onlyOwner {
        _paused = false;
    }

    /**
     * @dev Check if the contract is paused.
     * @return A boolean indicating whether the contract is paused.
     */
    function isPaused() external view returns (bool) {
        return _paused;
    }

    /**
     * @dev Transfer ownership to a new owner, only callable by the current owner.
     * @param newOwner The address of the new owner.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "ERC20: transfer to the zero address");
        _owner = newOwner;
    }

    function name() external view override returns (string memory) {
        return _name;
    }
    
    function symbol() external view override returns (string memory) {
        return _symbol;
    }
    
    function decimals() external view override returns (uint8) {
        return _decimals;
    }
    
}
