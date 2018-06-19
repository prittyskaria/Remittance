pragma solidity ^0.4.18;

contract Remittance {

    address  public owner;
   
    struct Details{
        uint balance;
        bytes32 hashPassword;
    }
    
    mapping (address => Details) public Remittee;
    
    event LogWithdraw(address Receiver, uint Amount);
    event LogsendRemittance(address Receiver, bytes32 hashPassword, uint Amount);

    function Remittance () public payable{
        owner = msg.sender;
    }
    
    function sendRemittance (address to, bytes32 hashPassword) public payable returns(bool){
       require(msg.sender == owner);
       Remittee[to].balance += msg.value;
       Remittee[to].hashPassword = hashPassword;
       LogsendRemittance(to , hashPassword, msg.value);
       return true;
    }
    
    function withdraw(address to, bytes32 password) public{
        require(Remittee[to].hashPassword == hashHelper(password));
        uint amount = Remittee[to].balance;
        require (amount > 0);
        delete Remittee[to];
        LogWithdraw(to, amount);
        to.transfer(amount);
    }
    
    function hashHelper (bytes32 pw) public pure returns(bytes32 hash){
       return keccak256(pw);
    }

    
    function () public payable{ 
        revert();
    }
    
    function kill() public{
        require(msg.sender == owner);
        selfdestruct(owner);
    }
    
}



