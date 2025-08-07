# 🪙 Token Deployer dApp

Deploy your own **ERC-20 Token** on the Ethereum Sepolia Testnet in just a few clicks using this simple web interface and smart contract.

---

## 🧱 What’s Included?

- `TokenDeployer.sol` — Solidity contract for deploying new ERC-20 tokens dynamically.
- `CustomToken.sol` (inside TokenDeployer) — ERC-20 template token contract.
- `frontend.html` — Beautiful frontend UI using pure HTML + CSS + Ethers.js for MetaMask interaction.

---

## 🔗 Live Demo (Optional)
You can host the `frontend.html` using [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) on VSCode or deploy on services like Vercel/Netlify.

---

## ⚙️ Requirements

- [Node.js](https://nodejs.org/) and [Hardhat](https://hardhat.org/) (if you want to re-deploy the contract)
- MetaMask (browser extension)
- Sepolia testnet ETH (use a [Sepolia faucet](https://sepoliafaucet.com/))

---

## 🚀 Smart Contract Deployment

### 1. Compile & Deploy

Deploy the following contract to Ethereum Sepolia testnet:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TokenDeployer.sol
contract TokenDeployer {
    ...
}
