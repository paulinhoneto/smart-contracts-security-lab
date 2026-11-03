// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PrivateKeyVault.sol";

contract PrivateKeyVaultTest is Test {
    PrivateKeyVault public vault;
    address public owner;
    uint256 public ownerPrivateKey;
    address public attacker;

    function setUp() public {
        // 1. Gera uma chave privada e o endereço correspondente para o dono
        ownerPrivateKey = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
        owner = vm.addr(ownerPrivateKey);

        // 2. O dono (que tem a chave) implanta o cofre
        vm.prank(owner);
        vault = new PrivateKeyVault();

        // 3. Deposita 10 ETH no cofre
        vm.deal(address(vault), 10 ether);

        // 4. Define o atacante
        attacker = address(0x2);
    }

    // Teste 1: O cofre tem saldo
    function testVaultHasBalance() public view {
        assertEq(address(vault).balance, 10 ether);
    }

    // Teste 2: O vazamento da chave privada permite o roubo
    function testPrivateKeyLeak() public {
        // 1. Verifica o saldo inicial do cofre
        assertEq(address(vault).balance, 10 ether);

        // 2. O "VAZAMENTO": A chave privada do dono é exposta (simulando um print ou log)
        // Em um cenário real, o atacante teria acesso a essa chave.
        uint256 leakedPrivateKey = ownerPrivateKey;

        // 3. O atacante forja a assinatura usando a chave vazada
        // Mensagem: amount = 10 ether, nonce = 1
        uint256 amount = 10 ether;
        uint256 nonce = 1;

        // Cria o hash da mensagem (igual ao contrato)
        bytes32 messageHash = keccak256(abi.encodePacked(amount, nonce));
        bytes32 ethSignedMessage = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );

        // Assina a mensagem com a chave vazada
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(leakedPrivateKey, ethSignedMessage);
        bytes memory signature = abi.encodePacked(r, s, v);

        // 4. O atacante chama a função de saque com a assinatura forjada
        vm.prank(attacker);
        vault.withdrawWithSignature(amount, nonce, signature);

        // 5. Verifica se o cofre foi zerado
        assertEq(address(vault).balance, 0);

        // 6. Verifica se o atacante recebeu os 10 ETH
        assertEq(attacker.balance, 10 ether);
    }
}