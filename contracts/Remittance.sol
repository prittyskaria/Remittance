pragma solidity ^0.4.18;

contract Remittance {
    bytes32  key_B;
    bytes32  key_C;
    address  owner;
    
    mapping (address => uint) public balances;
    
    event LogWithdraw(address Receiver, uint Amount);
    
    function Remittance () public payable{
        owner = msg.sender;
    }
    
    function addAddress (address X) public payable{
       balances[X] = msg.value;
    }
    
    function setKeys (bytes32 sha_key1, bytes32 sha_key2) public{
       require(msg.sender == owner);
       require(sha_key1 != 0);
       require(sha_key2 != 0);
       require(sha_key1 != sha_key2);

       key_B = sha_key1;
       key_C = sha_key2;
    }

    function withdraw(string key_Bob, string key_Carol) public {
        require(keccak256(key_Bob) != 0);
        require(keccak256(key_Carol) != 0);
        require(key_B == keccak256(key_Bob));
        require(key_C == keccak256(key_Carol));
 
        key_B = 0;
        key_C = 0;
        
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        LogWithdraw(msg.sender, amount);
        msg.sender.transfer(amount);
    }
    
    function() public payable{ 
        revert();
    }
    
}
    
