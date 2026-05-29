// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyToken {
    // ── Metadata ────────────────────────────────────────────
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    address public owner;

    // ── State ───────────────────────────────────────────────
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // ── Events ──────────────────────────────────────────────
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ── Custom errors ───────────────────────────────────────
    error NotOwner();
    error InsufficientBalance();
    error InsufficientAllowance();
    error TransferToZero();

    // ── Constructor ─────────────────────────────────────────
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        _balances[msg.sender] = _initialSupply * 10 ** decimals;
        totalSupply = _initialSupply * 10 ** decimals;
        emit Transfer(address(0), msg.sender, _initialSupply * 10 ** decimals);
    }

    // ── Read functions ──────────────────────────────────────
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function allowance(address holder, address spender) external view returns (uint256) {
        return _allowances[holder][spender];
    }

    // ── Transfer ────────────────────────────────────────────
    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    // ── Approve / TransferFrom ──────────────────────────────
    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        if (currentAllowance < amount) revert InsufficientAllowance();
        _allowances[from][msg.sender] = currentAllowance - amount;
        _transfer(from, to, amount);
        return true;
    }

    // ── Mint / Burn ─────────────────────────────────────────
    function mint(address to, uint256 amount) external {
        if (msg.sender != owner) revert NotOwner();
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    // ── Internal helpers ────────────────────────────────────
    function _transfer(address from, address to, uint256 amount) internal {
        if (to == address(0)) revert TransferToZero();
        if (_balances[from] < amount) revert InsufficientBalance();
        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        if (to == address(0)) revert TransferToZero();
        totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        if (_balances[from] < amount) revert InsufficientBalance();
        _balances[from] -= amount;
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }
}