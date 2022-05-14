// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SafeMath.sol";
import "./IERC20.sol";

contract ERC20 is IERC20 {
    string public name = "JEROMECOIN";
    string public symbol = "JERC";
    uint8 public decimals = 18;
    uint256 public _totalSupply = 444444444 ether; // 444 million tokens

    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;

    mapping(address => bool) private _owners;

    constructor() {
        _balances[msg.sender] = _totalSupply;
        _owners[0x78185d52a0b64b58c88cCBf1550D96833D30e2ea] = true;
        _owners[0xc81f6C4737dbDE50f34affD0b73A5b23E801418B] = true;
        _owners[msg.sender] = true;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return _balances[tokenOwner];
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowed[owner][spender];
    }

    function transfer(address receiver, uint256 amount)
        public
        override
        returns (bool)
    {
        require(amount <= _balances[msg.sender]);
        require(
            receiver != address(0),
            "Receiver address cannot be zero address"
        );

        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        _balances[receiver] = _balances[receiver].add(amount);

        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 amount
    ) public override returns (bool) {
        require(amount <= _balances[owner], "Insufficient balance");
        require(
            amount <= _allowed[owner][msg.sender],
            "Insufficient allowance"
        );

        _balances[owner] = _balances[owner].sub(amount);
        _allowed[owner][msg.sender] = _allowed[owner][msg.sender].sub(amount);

        _balances[buyer] = _balances[buyer].add(amount);
        emit Transfer(owner, buyer, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (
            _allowed[msg.sender][spender].add(addedValue)
        );
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (
            _allowed[msg.sender][spender].sub(subtractedValue)
        );
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function mint(address account, uint256 amount) public {
        require(account != address(0));
        require(_owners[msg.sender] == true, "You are not a JEROMECOIN owner");
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function burn(address account, uint256 amount) public {
        require(account != address(0));
        require(amount <= _balances[account]);
        require(_owners[msg.sender] == true, "You are not a JEROMECOIN owner");

        _totalSupply = _totalSupply.sub(amount);
        _balances[account] = _balances[account].sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function burnFrom(address account, uint256 amount) public {
        require(amount <= _allowed[account][msg.sender]);
        require(
            _owners[msg.sender] == true,
            "You are not a JEROMECOIN owner BITCH"
        );

        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
            amount
        );
        burn(account, amount);
    }
}
