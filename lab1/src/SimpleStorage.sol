// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    uint256 public storedNumber;
    address public owner; 

    //  o construct define o dono como quem implatou o contrato 
    constructor() {
       owner = msg.sender; 
    } 

    // modificador: so permite a execução se for o dono 
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }    

    
    // Função restrita (só o dono pode mudar)
    function store(uint256 _number) public onlyOwner{
        storedNumber = _number;
    }

    // Função para ler o número 
    function retrieve() public view returns (uint256) {
        return storedNumber;
    }

}