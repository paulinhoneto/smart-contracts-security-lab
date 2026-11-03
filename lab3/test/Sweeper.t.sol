// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Sweeper.sol";

contract SweeperTest is Test {
    MaliciousSweeper public sweeper;
    VictimWallet public victim;
    address public attacker;
    address public owner;

    function setUp() public {
        attacker = address(0x2);
        owner = address(0x1);

        vm.prank(attacker);
        sweeper = new MaliciousSweeper();

        vm.prank(owner);
        victim = new VictimWallet();

        vm.deal(address(victim), 100 ether);
    }

    function testVictimHasBalance() public view {
        assertEq(victim.getBalance(), 100 ether);
    }

    // TESTE CORRIGIDO: A vítima (owner) assina a delegação, mas o atacante
    // se beneficia do sweeper.
    function testAttackerSweepsFunds() public {
        // 1. Verifica o saldo inicial da vítima
        assertEq(victim.getBalance(), 100 ether);

        // 2. A VÍTIMA (owner) chama a função de delegação, apontando para o
        //    contrato malicioso do atacante.
        //    (Isso simula a "assinatura" da Binance na autorização EIP-7702)
        vm.prank(owner);
        victim.delegateTo(address(sweeper));

        // 3. Verifica se o saldo da vítima foi zerado
        assertEq(victim.getBalance(), 0);

        // 4. Verifica se o atacante recebeu os 100 ETH
        assertEq(attacker.balance, 100 ether);
    }
}