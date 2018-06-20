pragma solidity ^0.4.18;

contract Remittance {

    address  public owner;
    bool public isRunning;
   
    struct remittee{
        uint balance;
        bool isUsed;
    }
    
    mapping (bytes32 => remittee) public remittees;
    
    event logWithdraw(address receiver, uint amount, bytes32 hashPassword);
    event logSendRemittance(bytes32 hashPassword, uint amount);
    
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
       require(!remittees[hashPassword].isUsed);
       remittees[hashPassword].balance += msg.value;
       remittees[hashPassword].isUsed = true;
       logSendRemittance(hashPassword, msg.value);
       return true;
    }
    
    function withdraw(bytes32 password) public onlyIsRunning{
        bytes32 hashPassword = hashHelper(password,msg.sender);
        require(remittees[hashPassword].balance > 0);
        uint amount = remittees[hashPassword].balance;
        remittees[hashPassword].balance = 0;
        logWithdraw(msg.sender, amount, hashPassword);
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
        owner.transfer(this.balance);
    }
    
}



