pragma solidity ^0.8.20;

interface IERC20 {
    // ── Required events ─────────────────────────────────────
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ── Required view functions ─────────────────────────────
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    // ── Required state changing functions ───────────────────
    function transfer(address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IERC20Metadata is IERC20 {
    // ── Optional metadata (every real token implements these) ──
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}


contract MyToken {
    // ── Metadata ────────────────────────────────────────────
    string public name;
    string public symbol;
    uint8  public constant decimals = 18;

    // ── State ───────────────────────────────────────────────
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256)                      private _balances;
    mapping(address => mapping(address => uint256))  private _allowances;

    // ── Events ──────────────────────────────────────────────
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ── Custom errors (cheaper than revert strings) ─────────
    error NotOwner();
    error InsufficientBalance();
    error InsufficientAllowance();
    error TransferToZero();

    // ── Constructor ─────────────────────────────────────────
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name        = _name;
        symbol      = _symbol;
        owner       = msg.sender;
        _mint(msg.sender, _initialSupply);
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
        uint256 current = _allowances[from][msg.sender];
        if (current < amount) revert InsufficientAllowance();
        if (current != type(uint256).max) {
            _allowances[from][msg.sender] = current - amount;
        }
        _transfer(from, to, amount);
        return true;
    }

    // ── Mint / burn ─────────────────────────────────────────
    function mint(address to, uint256 amount) external {
        if (msg.sender != owner) revert NotOwner();
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        if (_balances[msg.sender] < amount) revert InsufficientBalance();
        _balances[msg.sender] -= amount;
        totalSupply           -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    // ── Internal helpers ────────────────────────────────────
    function _transfer(address from, address to, uint256 amount) internal {
        if (to == address(0))             revert TransferToZero();
        if (_balances[from] < amount)     revert InsufficientBalance();
        _balances[from] -= amount;
        _balances[to]   += amount;
        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        if (to == address(0)) revert TransferToZero();
        totalSupply     += amount;
        _balances[to]   += amount;
        emit Transfer(address(0), to, amount);
    }
}