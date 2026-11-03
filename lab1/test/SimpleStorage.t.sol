// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public simpleStorage;
    address public owner;
    address public attacker;

    function setUp() public {
        owner = address(0x1);
        attacker = address(0x2);
        
        vm.prank(owner);
        simpleStorage = new SimpleStorage();
    }

    // o dono consegue  mudar o valor
    function testOwnerCanStore() public {
        vm.prank(owner);
        simpleStorage.store(42);
        assertEq(simpleStorage.retrieve(), 42);
    }

    // O atacante NÃO consegue mais mudar o valor (deve reverter)
    function testAttackerCannotStore() public {
        vm.prank(attacker);
        // Espera que a transação seja revertida com a mensagem "Not the owner"
        vm.expectRevert("Not the owner");
        simpleStorage.store(666);
    }

}