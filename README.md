# 🛡️ Smart Contracts Security Lab

Laboratório prático de estudo de vulnerabilidades em contratos inteligentes (Solidity/Foundry). 

## 🎯 Inspiração

Este laboratório foi inspirado no incidente de segurança ocorrido na **Binance (Outubro de 2026)**, onde atacantes (atribuídos ao grupo Lazarus) exploraram a funcionalidade **EIP-7702** do Ethereum para sequestrar a execução de uma carteira e drenar fundos bilionários.

O objetivo deste repositório é compreender, na prática, como falhas de controle de acesso e o uso indevido de `delegatecall` podem levar ao sequestro de contratos e carteiras.

---

## 🧪 Laboratórios Desenvolvidos

### 🔹 Lab 1: Controle de Acesso
**Conceito:** Falha de permissão em funções que alteram o estado do contrato.
- **Cenário:** Um contrato `SimpleStorage` que permite que qualquer pessoa altere o valor armazenado.
- **Correção:** Implementação do modificador `onlyOwner` para restringir o acesso.
- **Local:** `lab1/`

### 🔹 Lab 2: Delegatecall (Hijack de Contexto)
**Conceito:** Execução de código externo no contexto de um contrato vulnerável.
- **Cenário:** Um contrato `VulnerableDelegate` que executa código de um endereço arbitrário via `delegatecall`, permitindo que um atacante sobrescreva a variável `owner`.
- **Local:** `lab2/`

### 🔹 Lab 3: Simulação de Sweeper (EIP-7702)
**Conceito:** Sequestro de carteira e drenagem de fundos.
- **Cenário:** Simulação de uma carteira vítima que "delega" a execução de seu código para um contrato malicioso (`MaliciousSweeper`), esvaziando seu saldo.
- **Local:** `lab3/`

---

## 📂 Documentação e Issues

Todos os relatórios de vulnerabilidades, PoCs e análises técnicas estão documentados no diretório [`docs/`](./docs/). Lá você encontrará os detalhes de como cada ataque foi executado e as recomendações de mitigação (Blue Team).

---

## 🛠️ Tecnologias Utilizadas

- **Solidity** (Linguagem dos contratos)
- **Foundry** (Framework de testes)
- **Git Bash** (Ambiente de desenvolvimento no Windows)

---
*Este projeto é estritamente para fins educacionais e de pesquisa em segurança.*
