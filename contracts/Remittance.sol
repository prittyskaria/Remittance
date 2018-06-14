pragma solidity ^0.4.19;

contract Remittance {
    bytes32  public key_B;
    bytes32  public key_C;
    address  public owner;
    
    mapping (address => uint) public balances;
    
    event LogWithdraw(address Receiver, uint Amount);
    event LogAddAddress(address Receiver, uint Amount);
    event LogSetKeys(bytes32 Key1, bytes32 Key2);
    event LogResetKeys(bytes32 Key1BeforeReset, bytes32 Key2BeforeReset);
   
    
    function Remittance () public payable{
        owner = msg.sender;
    }
    
    function addAddress (address X) public payable returns(bool){
       require(msg.sender == owner);
       balances[X] = msg.value;
       LogAddAddress(X , msg.value);
       return true;
    }
    

    function setKeys (bytes32 sha_key1, bytes32 sha_key2) public returns(bool){
       require(msg.sender == owner);
       require(sha_key1 != 0);
       require(sha_key2 != 0);
       require(sha_key1 != sha_key2);

       key_B = sha_key1;
       key_C = sha_key2;
       
       LogSetKeys(key_B , key_C);
       return true;
    }

    function withdraw(string key_Bob, string key_Carol) public{
        bytes32 storeKey1 = key_B;
        bytes32 storeKey2 = key_C;

//for safety, once withdraw is called both keys are reset to zero irrespective of the transaction status 
        key_B = 0;
        key_C = 0;
        
        LogResetKeys(storeKey1, storeKey2);

        require(balances[msg.sender] > 0);
        require(keccak256(key_Bob) != 0);
        require(keccak256(key_Carol) != 0);
        require(storeKey1 == keccak256(key_Bob));
        require(storeKey2 == keccak256(key_Carol));
        
        uint amount = balances[msg.sender];
        delete balances[msg.sender];
        LogWithdraw(msg.sender, amount);
        msg.sender.transfer(amount);
    }
    
    function () payable{ 
        revert();
    }
    
    function kill() public{
        require(msg.sender == owner);
        selfdestruct(owner);
    }
    
}



