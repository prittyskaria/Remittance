pragma solidity ^0.4.18;

import "./Owned.sol";

contract Stoppable is Owned{

    bool public isRunning;

    event LogPausedRunning(address by);
    event LogResumedRunning(address by);
    event LogKill(address by);
     
    modifier onlyIsRunning()
    {
        require(isRunning);
         _;
    }
    
    function Stoppable () public payable{
        isRunning = true;
    }
    
    
    function pause() public onlyBy(owner) returns(bool success){
        isRunning = false;
        LogPausedRunning(msg.sender);
        return true;
    }

    function resume() public onlyBy(owner) returns(bool success){
        require(!isRunning);
        isRunning = true;
        LogResumedRunning(msg.sender);
        return true;
    }
    
    function kill() public onlyBy(owner) returns(bool success){
        LogKill(msg.sender);
        selfdestruct(owner);
        return true;
    }


}
