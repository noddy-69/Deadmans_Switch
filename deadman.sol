// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DeadmansSwitch {
    address public owner;
    address public destination;
    uint public last;

    event SwitchTriggered(address indexed sender, uint balanceTransferred);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(address _destination) {
        owner = msg.sender;
        destination = _destination;
        last = block.number;
    }

    function stillAlive() external onlyOwner {
        last = block.number;
    }

    function checkStatus() external {
        require(block.number - last  <= 10, "Switch triggered");
        uint balanceToSend = address(this).balance;
        require(balanceToSend > 0, "No balance to transfer");
        payable(destination).transfer(balanceToSend);
        emit SwitchTriggered(msg.sender, balanceToSend);
    }

    receive() external payable {
        
    }
}
