pragma solidity ^0.4.18;

/**
 * @title DonutToken Contract
 * @dev see https://github.com/ethereum/EIPs/issues/20
 *
 * Symbol       : DNT
 * Name         : Donut token
 * Total Supply : 100000000000000000000000000
 * DecimaLs     : 18
 *
 * (c) Jane Wang 2018. The MIT License.
 */

contract ERC20Interface {
    uint public totalSupply;
    function balanceOf(address _owner) public constant returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public constant returns (uint remaining);
    function approve(address _spender, uint _value) public returns (bool success);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

/**
 * Safe maths
 */
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b > 0);
        c = a / b;
    }
}

/**
 * @title Standard ERC20 token
 */
contract ERC20StandardToken is ERC20Interface {
    using SafeMath for uint256;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    /**
     * @dev transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
      	emit Transfer(msg.sender, _to, _value);
      	return true;
    }

    /**
     * @dev Get the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
      	allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
      	return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens available for the spender.
     */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}

/**
 * @title Donut Token
 */
contract DonutToken is ERC20StandardToken {
    string public constant name = "Donut Token";
    string public constant symbol = "DNT";
    uint public constant decimals = 18;

    address public target;

    function DonutToken(address _target) public {
        target = _target;
        totalSupply = 100000000000000000000000000;
        balances[target] = totalSupply;
    }
}
