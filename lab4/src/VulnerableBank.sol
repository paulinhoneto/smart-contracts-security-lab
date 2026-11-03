// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBank {
    // Mapeia o saldo de cada usuário
    mapping(address => uint256) public balances;

    // Função para depositar fundos no banco
    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    // Função vulnerável de saque
    function withdraw() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");

        // VULNERABILIDADE: Envia o dinheiro ANTES de atualizar o saldo
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");

        // A atualização do saldo só acontece DEPOIS do envio
        balances[msg.sender] = 0;
    }

    // Função auxiliar para ver o saldo total do contrato (para o teste)
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}