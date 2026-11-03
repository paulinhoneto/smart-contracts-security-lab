\# Smart Contracts Security Lab



Laboratório de estudo de vulnerabilidades em contratos inteligentes (Solidity/Foundry).



\## 🎯 Inspiração



Este laboratório foi inspirado no incidente de segurança ocorrido na \*\*Binance (Outubro de 2026)\*\*, onde atacantes (atribuídos ao grupo Lazarus) exploraram a funcionalidade \*\*EIP-7702\*\* do Ethereum para sequestrar a execução de uma carteira e drenar fundos bilionários.



O objetivo é compreender, na prática, como falhas de controle de acesso e o uso indevido de `delegatecall` podem levar ao sequestro de contratos e carteiras.



\## 🧪 Labs



| Lab   | Conceito           | Descrição                                                                                         |

|-------|--------------------|---------------------------------------------------------------------------------------------------|

| Lab 1 | Controle de Acesso | Falha em `SimpleStorage` que permite qualquer usuário alterar o estado. Correção com `onlyOwner`. |

| Lab 2 | Delegatecall 97    | Sequestro de contexto via `delegatecall`, alterando o `owner` do contrato.                        |

| Lab 3 | Sweeper (EIP-7702) | Simulação de um contrato "sweeper" que drena os fundos da carteira vítima usando delegação.       |



\## 🛠️ Tecnologias



\- Solidity

\- Foundry (Forge)

\- Git Bash (Windows)



\## 📁 Estrutura



smart-contracts/

├── lab1/ # Controle de Acesso

├── lab2/ # Delegatecall

├── lab3/ # Sweeper / EIP-7702

└── docs/ # Issues e relatórios

# 📋 Issues e Relatórios de Segurança



Este diretório contém os relatórios de vulnerabilidades identificadas e simuladas nos laboratórios de smart contracts.



| Lab   | Issue | Vulnerabilidade                                                                              |

|-------|-------|----------------------------------------------------------------------------------------------|

| Lab 1 | \[carpc\_issue\_simple\_storage\_access\_control.txt](./carpc\_issue\_simple\_storage\_access\_control.txt)     | Falha de Controle de Acesso     |

| Lab 2 | \[carpc\_issue\_delegatecall\_hijack.txt](./carpc\_issue\_delegatecall\_hijack.txt)                         | Sequestro via Delegatecall      |

| Lab 3 | \[carpc\_issue\_lab3\_sweeper\_eip7702\_simulation.txt](./carpc\_issue\_lab3\_sweeper\_eip7702\_simulation.txt) | Simulação de Sweeper (EIP-7702) |





