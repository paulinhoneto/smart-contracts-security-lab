// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableBank.sol";
import "../src/Attacker.sol";

contract ReentrancyTest is Test {
    VulnerableBank public bank;
    Attacker public attackerContract;
    address public victim;
    address public attackerEOA;

    function setUp() public {
        // Define os endereços
        victim = address(0x1);
        attackerEOA = address(0x2);

        // O dono (vítima) implanta o banco
        vm.prank(victim);
        bank = new VulnerableBank();

        // A vítima deposita 10 ETH no banco (simulando outros usuários)
        vm.deal(victim, 10 ether);
        vm.prank(victim);
        bank.deposit{value: 10 ether}();

        // O atacante (EOA) implanta o contrato de ataque
        vm.prank(attackerEOA);
        attackerContract = new Attacker(address(bank));

        // Dá 1 ETH para o contrato do atacante (para o depósito inicial)
        vm.deal(address(attackerContract), 1 ether);
    }

    // Teste 1: O banco tem saldo antes do ataque
    function testBankHasBalance() public view {
        assertEq(bank.getContractBalance(), 10 ether);
    }

    // Teste 2: O atacante drena o banco via reentrancy
    function testAttackerDrainsBank() public {
        // 1. Verifica o saldo inicial do banco (10 ETH)
        assertEq(bank.getContractBalance(), 10 ether);

        // 2. O atacante inicia o ataque
        // (O contrato do atacante tem 1 ETH e vai depositá-lo, depois sacar)
        vm.prank(attackerEOA);
        attackerContract.attack();

        // 3. O banco deve estar zerado (ou com menos de 1 ETH, dependendo do loop)
        assertEq(bank.getContractBalance(), 0);

        // 4. O atacante deve ter os 11 ETH (10 do banco + 1 do depósito inicial)
        // (O saldo do atacante está no contrato Attacker)
        assertEq(address(attackerContract).balance, 11 ether);
    }
}