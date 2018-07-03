pragma solidity ^0.4.18;

contract Owned{
    address  public owner;

    event LogChangeOwner(address by, address newOwner);
        
    modifier onlyBy(address byWhom)
    {
        require(msg.sender == byWhom);
         _;
    }
    
    function Owned() public{
        owner = msg.sender;
    }
    
    function changeOwner(address _newOwner) public onlyBy(owner) returns(bool success){
        owner = _newOwner;
        LogChangeOwner(msg.sender, _newOwner);
        return true;
    }


}
