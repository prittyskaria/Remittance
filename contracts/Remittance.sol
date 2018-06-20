pragma solidity ^0.4.18;

contract Remittance {

    address  public owner;
    bool public isRunning;
   
    struct Remittee{
        uint balance;
        bool isUsed;
    }
    
    mapping (bytes32 => Remittee) public Remittees;
    
    event LogWithdraw(address receiver, uint amount, bytes32 hashPassword);
    event LogSendRemittance(bytes32 hashPassword, uint amount);
    event LogStopRunning(address by);
   
    modifier onlyBy(address byWhom)
    {
        require(msg.sender == byWhom);
         _;
    }
    
     modifier onlyIsRunning()
    {
        require(isRunning);
         _;
    }
  
    function Remittance () public payable{
        owner = msg.sender;
        isRunning = true;
    }
    
    function sendRemittance (bytes32 hashPassword) public payable  onlyBy(owner) onlyIsRunning returns(bool){
       require(!Remittees[hashPassword].isUsed);
       Remittees[hashPassword].balance += msg.value;
       Remittees[hashPassword].isUsed = true;
       LogSendRemittance(hashPassword, msg.value);
       return true;
    }
    
    function withdraw(bytes32 password) public onlyIsRunning{
        bytes32 hashPassword = hashHelper(password,msg.sender);
        require(Remittees[hashPassword].balance > 0);
        uint amount = Remittees[hashPassword].balance;
        Remittees[hashPassword].balance = 0;
        LogWithdraw(msg.sender, amount, hashPassword);
        msg.sender.transfer(amount);
    }
    
    function hashHelper (bytes32 pw, address account) public pure returns(bytes32 hash){
       return keccak256(pw,account);
    }

    function () public payable{ 
        revert();
    }
    
    function kill() public onlyBy(owner){
        isRunning = false;
        LogStopRunning(msg.sender);
        owner.transfer(this.balance);
    }
    
}



