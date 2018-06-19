pragma solidity ^0.4.18;

contract Remittance {

    address  public owner;
   
    struct DetailsStruct{
        address to;
        uint balance;
        bool isUsed;
    }
    
    mapping (bytes32 => DetailsStruct) public Remittee;
    
    event LogWithdraw(address Receiver, uint Amount);
    event LogsendRemittance(address Receiver, bytes32 hashPassword, uint Amount);
    
    modifier onlyBy(address byWhom)
    {
        require(msg.sender == byWhom);
         _;
    }
  
    function Remittance () public payable{
        owner = msg.sender;
    }
    
    function sendRemittance (address to, bytes32 hashPassword) public payable  onlyBy(owner) returns(bool){
       require(!Remittee[hashPassword].isUsed);
       Remittee[hashPassword].to = to;
       Remittee[hashPassword].balance += msg.value;
       Remittee[hashPassword].isUsed = true;
       LogsendRemittance(to , hashPassword, msg.value);
       return true;
    }
    
    function withdraw(address to, bytes32 password) public{
        bytes32 hashPassword = hashHelper(password);
        require(Remittee[hashPassword].to == to);
        uint amount = Remittee[hashPassword].balance;
        require (amount > 0);
        Remittee[hashPassword].balance = 0;
        LogWithdraw(Remittee[hashPassword].to, amount);
        Remittee[hashPassword].to.transfer(amount);
    }
    
    function hashHelper (bytes32 pw) public pure returns(bytes32 hash){
       return keccak256(pw);
    }

    function () public payable{ 
        revert();
    }
    
    function kill() public onlyBy(owner){
        selfdestruct(owner);
    }
    
}



