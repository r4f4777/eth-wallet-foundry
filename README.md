📄 Wallet Contract — Secure ETH Custody Smart Contract (Solidity + Foundry)

A minimal, fully-tested Ethereum wallet contract that allows secure ETH deposits, owner-restricted withdrawals, and ownership transfers.
Built entirely with Solidity 0.8.20 and tested using Foundry, this project demonstrates a clean on-chain architecture and strong testing discipline suitable for real-world Web3 development.

Table of Contents

Overview

Features

Contract Architecture

Events

Access Control

Testing (Foundry)

Running Tests

Project Structure

Security Considerations

Future Improvements

License

🧩 Overview

The Wallet Contract is a simple yet secure ETH custody smart contract designed to explore essential Ethereum concepts:

ownership control

deposits and withdrawals

access-restricted functions

event logging

fallback and receive handlers

full unit-test coverage with Foundry

This project serves as a strong foundation for understanding on-chain value management and permissioned flows, commonly used in real wallets, treasuries, escrow systems, and DeFi modules.

✨ Features

Deposit ETH using a direct transaction or the deposit() function

Track last deposit (amount, sender, timestamp)

Owner-only withdrawals to prevent unauthorized transfers

Ownership transfer via changeOwner()

Full ETH compatibility through receive() and fallback() functions

Comprehensive test suite (9 unit tests) covering:

deposits

withdrawals

reverts

permissions

ownership transfers

🏗️ Contract Architecture

The core components of the contract include:

owner: the address controlling withdrawals and ownership changes

deposit tracking:

lastDepositAmount

lastDepositTime

lastDepositFrom

modifiers:

onlyOwner()

_onlyOwner() (internal logic layer)

ETH management:

deposit() (external payable)

withdraw() (owner-only)

receive()

fallback()

The contract follows a clear structure used in professional audits:

State Variables

Events

Constructor

Core Functions

View Functions

Access Control

Fallback Handlers

📡 Events
Event	Description
Deposit(address from, uint256 amount, uint256 timestamp)	Emitted when ETH is deposited
Withdrawal(address to, uint256 amount, uint256 timestamp)	Emitted when the owner withdraws
OwnerChanged(address oldOwner, address newOwner, uint256 timestamp)	Emitted when ownership is transferred

Events are essential for frontends, monitoring, and off-chain indexing systems like The Graph.

🔐 Access Control

This contract uses a simple but powerful permission model:

Only the owner may withdraw funds

Only the owner may change ownership

Ownership is enforced via the onlyOwner modifier, which checks:

require(msg.sender == owner, "Only owner can call this function");


Unauthorized calls revert immediately.

🧪 Testing (Foundry)

The project includes a full Foundry test suite covering:

correct owner initialization

deposit behavior

last deposit tracking

successful withdrawals

unauthorized withdrawals (reverts)

insufficient balance reverts

ownership transfers

unauthorized owner changes

new owner permissions

Example test cases include:

testing balance changes before/after withdrawing

simulating external users with vm.prank()

funding accounts with vm.deal()

verifying reverts with specific messages (vm.expectRevert())

This mirrors real smart contract auditing and production-grade testing practices.

▶️ Running Tests

Install Foundry (if you haven’t already):

curl -L https://foundry.paradigm.xyz | bash
foundryup


Build the project:

forge build


Run the full test suite:

forge test -vv


Where:

-v shows logs

-vv shows stack traces and detailed gas reports

📁 Project Structure
wallet-contract/
│
├── src/
│   └── Wallet.sol         # Main smart contract
│
├── test/
│   └── Wallet.t.sol       # Full Foundry test suite
│
├── foundry.toml
└── README.md

🔒 Security Considerations

Although simple, the contract follows best practices:

No reentrancy risk (uses transfer(), which provides 2300 gas stipend)

Only the owner can withdraw funds

Ownership cannot be assigned to the zero address

Direct ETH transfers are supported via receive() and fallback()

State changes are minimal and predictable

Threat model:
This contract assumes a trusted owner (centralized wallet model).

🚀 Future Improvements

Potential enhancements:

Multi-signature ownership (multi-owner wallets)

ERC20 token support

Add pausable withdrawals

Add emergency withdrawal or rescue functionality

Implement EIP-712 typed structured data for meta-transactions

Make withdrawals configurable (recipient argument)

Add more advanced tracking (total deposits, deposit history array, etc.)

📜 License

This project is released under the MIT License, allowing full reuse and modification.