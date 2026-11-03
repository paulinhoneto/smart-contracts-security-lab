// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureBank {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        // 1. CHECK: Verifica se o usuário tem saldo
        uint256 balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");

        // 2. EFFECT: Zera o saldo ANTES de enviar o dinheiro
        balances[msg.sender] = 0;

        // 3. INTERACTION: Só agora envia o dinheiro
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}