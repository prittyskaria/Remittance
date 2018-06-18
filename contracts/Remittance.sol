pragma solidity ^0.4.19;

contract Remittance {
    bytes32  public key_B;
    address  public key_C;
    address  public owner;
    
    mapping (address => uint) public balances;
    
    event LogWithdraw(address Receiver, uint Amount);
    event LogAddAddress(address Receiver, uint Amount);
    event LogSetKeys(bytes32 Key1);

    
    function Remittance () public payable{
        owner = msg.sender;
    }
    
    function addAddress (address X) public payable returns(bool){
       require(msg.sender == owner);
       balances[X] = msg.value;
       key_C = X;
       LogAddAddress(X , msg.value);
       return true;
    }
    
    function setKeys (bytes32 sha_key1) public returns(bool){
       require(msg.sender == owner);
       require(sha_key1 != 0);

       key_B = sha_key1;
       LogSetKeys(key_B);
       return true;
    }

    function withdraw(string key_Bob) public{
        require(key_C == msg.sender);
        require(keccak256(key_Bob) != 0);
        require(key_B == keccak256(key_Bob));
        key_B = 0;
        require(balances[msg.sender] > 0);
       
        uint amount = balances[msg.sender];
        delete balances[msg.sender];
        LogWithdraw(msg.sender, amount);
        msg.sender.transfer(amount);
    }
    

    
    function () public payable{ 
        revert();
    }
    
    function kill() public{
        require(msg.sender == owner);
        selfdestruct(owner);
    }
    
}



