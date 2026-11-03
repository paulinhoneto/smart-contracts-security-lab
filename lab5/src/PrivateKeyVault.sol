// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PrivateKeyVault {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Função para depositar ETH (qualquer um pode depositar)
    receive() external payable {}

    // Função para sacar fundos. 
    // Requer uma assinatura válida da chave privada do dono.
    function withdrawWithSignature(
        uint256 amount,
        uint256 nonce,
        bytes memory signature
    ) public {
        // 1. Cria a mensagem que foi assinada
        bytes32 messageHash = keccak256(abi.encodePacked(amount, nonce));
        
        // 2. Adiciona o prefixo padrão do Ethereum para assinaturas
        bytes32 ethSignedMessage = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );

        // 3. Recupera o endereço de quem assinou a mensagem
        address signer = recoverSigner(ethSignedMessage, signature);

        // 4. Verifica se quem assinou é o dono do cofre
        require(signer == owner, "Invalid signature");

        // 5. Transfere os fundos
        require(address(this).balance >= amount, "Insufficient funds");
        payable(msg.sender).transfer(amount);
    }

    // Função auxiliar para recuperar o endereço do assinante
    function recoverSigner(bytes32 _ethSignedMessage, bytes memory _signature)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessage, v, r, s);
    }

    // Função auxiliar para separar a assinatura (r, s, v)
    function splitSignature(bytes memory sig)
        public
        pure
        returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}