pragma solidity ^0.4.11;

import "@chainlink/contracts/src/v0.4/ERC677Token.sol";
import {StandardToken as linkStandardToken} from "@chainlink/contracts/src/v0.4/vendor/StandardToken.sol";

contract LinkToken is linkStandardToken, ERC677Token {
    uint public constant totalSupply = 10**27;
    string public constant name = "ChainLink Token";
    uint8 public constant decimals = 18;
    string public constant symbol = "LINK";

    function LinkToken() public {
        balances[msg.sender] = totalSupply;
    }


    // *THIS is difference from (ERC20! => ERC221) but 221 has a problem with invalid recipient
    // validRecipient(_to) is solution to this kind of problem
    // validates if recipient is valid. And than calls transferAndCall from underlying contranct
    // *super calls contract, from which LinkToken is derived!
    // one of LinkStandardToken or ERC677Token does have this function, and we call it
    function transferAndCall(address _to, uint _value, bytes _data)
        public
        validRecipient(_to)
        returns (bool success)
        {
            return super.transferAndCall(_to, _value, _data);
        }

    // Same as above - transfer in older 221 with not validated recipient
    // So require it as parameter for calling 221-tansfer
    // such as onlyOwner. on the same level. 
    // more elegant than require in body of function
    // like this the function is not even called without it
  function transfer(address _to, uint _value)
    public
    validRecipient(_to)
    returns (bool success)
  {
    return super.transfer(_to, _value);
  }

    function approve(address _spender, uint256 _value)
        public
        validRecipient(_spender)
        returns(bool)
        {
            return super.approve(_spender, _value);
        }

    function transferFrom(address _from, address _to, uint256 _value)
        public
        validRecipient(_to)
        returns(bool)
        {
            return super.transferFrom(_from, _to, _value);
        }

    modifier validRecipient(address _recipient) {
        require(_recipient != address(0) && _recipient != address(this));
        _;
    }


}    