# Tokenomics
 - Token Contract with SafeERC20 Specs
 - Contract to mint, burn and Lock tokens
 - Deploy Instructions

## You will need to:
- put an initial supply of 1,000,000 tokens
- add a mint function and mint another 1,000,000 tokens using this function
- add a token burn function and burn 500,000 token by sending tokens into this function
- create a lock function. eg: send your tokens to an address (wallet A) from the contract address / token owner. You can lock wallet A, so wallet A cannot move the tokens.

For mint, burn and lock function, please execute it in a smart contract. Once you are done, kindly share the token address and any smart contract address, if any.


## Deployment to Ropsten:
truffle migrate --reset --network ropsten

## Addresses from deployment:
- KANTH_DEFI_REWARD token Address: 0xDC459462B9679Ab07983Ff3880a920F5B48F4d67
  - https://ropsten.etherscan.io/address/0xDC459462B9679Ab07983Ff3880a920F5B48F4d67

- owner: 0x1F61741610892C0A4D3e831Dc91958df2dc27182
   - https://ropsten.etherscan.io/address/0x1F61741610892C0A4D3e831Dc91958df2dc27182

- user-1: 0x4f8e8d218bb72fA696742ce645d721F3B568a3Db    
    - https://ropsten.etherscan.io/address/0x4f8e8d218bb72fA696742ce645d721F3B568a3Db

- user-2: 0x5259267492F0855930072764AEa2602fC547a28f    
    - https://ropsten.etherscan.io/address/0x5259267492F0855930072764AEa2602fC547a28f

- lockedWalletFactory is deployed with Address: 0xAe4a9345283eFD78Fad6FD05d16819f626c62a78    
    - https://ropsten.etherscan.io/address/0xAe4a9345283eFD78Fad6FD05d16819f626c62a78

## Command execution for min, burn, totalSupply on kanthDeFiRewardToken contract

- Token Logs:
  - https://ropsten.etherscan.io/token/0xDC459462B9679Ab07983Ff3880a920F5B48F4d67

- Token Commands:

```js
const owner = "0x1F61741610892C0A4D3e831Dc91958df2dc27182"
const pvtKey = "193e56edadf08310c8444b03d28105f1cd57bf0b39461975f1183cb2e4987d33"
const kanthDeFiRewardTokenAddress = "0xDC459462B9679Ab07983Ff3880a920F5B48F4d67";

const kanthDeFiRewardTokenJson = require("./build/contracts/KanthDeFiRewardToken.json");
const kanthDeFiRewardTokenAbi = kanthDeFiRewardTokenJson.abi;

const kanthDeFiRewardTokenInstance = await new web3.eth.Contract(kanthDeFiRewardTokenAbi,kanthDeFiRewardTokenAddress);

await kanthDeFiRewardTokenInstance.methods.totalSupply().call()
1000000000000000000000000

var mintRsp1 = await kanthDeFiRewardTokenInstance.methods.mintToken(owner, web3.utils.toBN("1000000000000000000000000")).send({"from" : owner})
await kanthDeFiRewardTokenInstance.methods.totalSupply().call()
2000000000000000000000000

var burnRsp1 = await kanthDeFiRewardTokenInstance.methods.burnToken(owner, web3.utils.toBN("50000000000000000000000")).send({"from" : owner})
await kanthDeFiRewardTokenInstance.methods.totalSupply().call()
1950000000000000000000000


```

## Command execution for createWallet, lock, release on LockedWallet contract

```js
const owner = "0x1F61741610892C0A4D3e831Dc91958df2dc27182";
const pvtKey = "193e56edadf08310c8444b03d28105f1cd57bf0b39461975f1183cb2e4987d33";
const user1 = accounts[1];
const user2 = accounts[2];
const user3 = accounts[3];
const walletManagerAddress = "0x1F61741610892C0A4D3e831Dc91958df2dc27182";

//https://ropsten.etherscan.io/address/0xAe4a9345283eFD78Fad6FD05d16819f626c62a78

const lockedWalletFactoryAddress = "0xAe4a9345283eFD78Fad6FD05d16819f626c62a78";

const lockedWalletFactoryJson = require("./build/contracts/LockedWalletFactory.json");
const lockedWalletFactoryAbi = lockedWalletFactoryJson.abi;

const lockedWalletJson = require("./build/contracts/LockedWallet.json");
const lockedWalletAbi = lockedWalletJson.abi;

const lockedWalletFactoryInstance = await new web3.eth.Contract(lockedWalletFactoryAbi, lockedWalletFactoryAddress);

await lockedWalletFactoryInstance.methods.createNewLockedWallet(user1).send({"from" : walletManagerAddress});

await lockedWalletFactoryInstance.methods.getWalletInfoByWalletOwner(user1).call()

[ '0x5E58760eED5dCb0DFb94B1a87Ec8d19E0c514045',
  '0x4f8e8d218bb72fA696742ce645d721F3B568a3Db',
  '1622489821',
  walletAddress: '0x5E58760eED5dCb0DFb94B1a87Ec8d19E0c514045',
  walletOwner: '0x4f8e8d218bb72fA696742ce645d721F3B568a3Db',
  doesExist: '1622489821' ]

// Wallet-1: https://ropsten.etherscan.io/address/0x5e58760eed5dcb0dfb94b1a87ec8d19e0c514045

const walletAddress_1 = "0x5E58760eED5dCb0DFb94B1a87Ec8d19E0c514045";
const walletOwner = "0x4f8e8d218bb72fA696742ce645d721F3B568a3Db";
var walletInstance_1 = await new web3.eth.Contract(lockedWalletAbi, walletAddress_1);
await walletInstance_1.methods.isLocked().call();
await walletInstance_1.methods.info().call();
await kanthDeFiRewardTokenInstance.methods.transfer(walletAddress_1, web3.utils.toBN("100000000000000000000") ).send({"from" : owner});
await walletInstance_1.methods.unlockWallet().send({"from" : walletManagerAddress});
await walletInstance_1.methods.fullWithdrawRewardToken(user1).send({"from" : walletOwner});



await kanthDeFiRewardTokenInstance.methods.transfer(walletAddress_1, web3.utils.toBN("100000000000000000000")).send({"from" : owner});
token.mint(accounts[2], web3.utils.toBN("555000000000000000000"),{from:accounts[2]})