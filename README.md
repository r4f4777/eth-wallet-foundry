#  Wallet Contract — Secure ETH Custody (Solidity + Foundry)

A minimal, fully-tested Ethereum wallet smart contract for secure ETH deposits, owner-restricted withdrawals, and ownership transfers.  
Built with **Solidity 0.8.20** and **Foundry**, this project demonstrates clean contract architecture and production-grade testing.

---

##  Table of Contents
- [Overview](#-overview)
- [Features](#-features)
- [Contract Architecture](#-contract-architecture)
- [Events](#-events)
- [Access Control](#-access-control)
- [Testing (Foundry)](#-testing-foundry)
- [Running Tests](#️-running-tests)
- [Project Structure](#-project-structure)
- [Security Considerations](#-security-considerations)
- [Future Improvements](#-future-improvements)
- [License](#-license)

---

##  Overview

This wallet contract implements core Ethereum concepts:

- ownership & access control  
- ETH deposits & withdrawals  
- event logging  
- fallback & receive handlers  
- comprehensive unit tests (Foundry)

It serves as a learning-friendly yet production-accurate example of on-chain value management, similar to real wallets, treasuries, escrow systems, and DeFi modules.

---

##  Features

- Deposit ETH using `deposit()` or direct transfers  
- Track **last deposit** (amount, sender, timestamp)  
- Owner-only withdrawals (restricted via modifier)  
- Ownership transfer with `changeOwner()`  
- Fully compatible with ETH transfers (`receive` & `fallback`)  
- **Complete Foundry test suite** covering:
  - deposits  
  - withdrawals  
  - reverts  
  - permission checks  
  - ownership changes  

---

##  Contract Architecture

### **Core Variables**
- `owner` — address controlling the wallet  
- Deposit tracking:
  - `lastDepositAmount`
  - `lastDepositTime`
  - `lastDepositFrom`

### **Key Functions**
- `deposit()` — external payable ETH deposit  
- `withdraw(uint256 amount)` — owner-only withdrawal  
- `changeOwner(address newOwner)` — assign new owner  
- `getLastDeposit()` — deposit info  
- `getTotalBalance()` — contract ETH balance  

### **Fallback Handlers**
- `receive()` — accepts plain ETH transfers  
- `fallback()` — catches unknown calldata  

---

##  Events

| Event | Description |
|-------|-------------|
| `Deposit(address from, uint256 amount, uint256 timestamp)` | Emitted when ETH is deposited |
| `Withdrawal(address to, uint256 amount, uint256 timestamp)` | Emitted when owner withdraws ETH |
| `OwnerChanged(address oldOwner, address newOwner, uint256 timestamp)` | Emitted when ownership changes |

---

##  Access Control

The wallet uses a strict permission model:

- Only the **owner** can withdraw funds  
- Only the **owner** can change ownership  

Enforced via:
require(msg.sender == owner, "Only owner can call this function");

Unauthorized access attempts revert immediately.

##  Testing (Foundry)

This project includes a 9-test Foundry suite validating:

- correct owner initialization
- deposit mechanics
- last deposit tracking
- owner-only withdrawals
- insufficient balance reverts
- unauthorized access reverts
- ownership transfers
- new owner permissions

**Foundry cheatcodes used:**

vm.deal() — fund accounts

vm.prank() — simulate msg.sender

vm.expectRevert() — check revert messages

assertEq() — validate state/balances

##  Running Tests

1. Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

2. Build
forge build

3. Run tests
forge test -vv

##  Project Structure

Main smart contract path: wallet-contract/src/Wallet.sol
Test smart contract path: wallet-contract/test/Wallet.t.sol


##  Security Considerations

No reentrancy risk (transfer() gas stipend = 2300)

Only owner may withdraw funds

Ownership cannot be set to zero address

Minimal state surface

Assumes trusted owner (centralized wallet model)

##  Future Improvements

Multi-signature support

ERC20 support

Pausable withdrawals

Emergency admin features

EIP-712 meta-transactions

Withdrawal recipient parameter

Full deposit history tracking

##  License

MIT License — free to use, modify, and distribute.
