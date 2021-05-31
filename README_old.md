# Tokenomics
 - Token Contract with SafeERC20 Specs
 - Contract to mint, burn and Lock tokens
 - Deploy Instructions

## Deployment to Ropsten:
truffle migrate --reset --network ropsten

## Addresses from deployment:
- DeFiStar token Address: 0x0F0618891f05B3144d4c6Df81573EAb8826519Cb
  - https://ropsten.etherscan.io/address/0x0F0618891f05B3144d4c6Df81573EAb8826519Cb

- owner: 0x1F61741610892C0A4D3e831Dc91958df2dc27182
   - https://ropsten.etherscan.io/address/0x1F61741610892C0A4D3e831Dc91958df2dc27182

- tokenManager: 0xc81B475c24Aa09441e99ebb5dC0C24f0C89f8683
    - https://ropsten.etherscan.io/address/0xc81B475c24Aa09441e99ebb5dC0C24f0C89f8683

- user-1: 0x4f8e8d218bb72fA696742ce645d721F3B568a3Db    
    - https://ropsten.etherscan.io/address/0x4f8e8d218bb72fA696742ce645d721F3B568a3Db

- user-2: 0x5259267492F0855930072764AEa2602fC547a28f    
    - https://ropsten.etherscan.io/address/0x5259267492F0855930072764AEa2602fC547a28f

- lockedWalletFactory is deployed with Address: 0x43Bb8f1a735112aB7ECEad5E217849d81D0cF15B
    - https://ropsten.etherscan.io/address/0x43Bb8f1a735112aB7ECEad5E217849d81D0cF15B


## Command execution for min, burn, totalSupply on kanthDeFiStarToken contract

```js
const owner = "0x1F61741610892C0A4D3e831Dc91958df2dc27182"
const pvtKey = "193e56edadf08310c8444b03d28105f1cd57bf0b39461975f1183cb2e4987d33"
const kanthDeFiStarTokenAddress = "0x0F0618891f05B3144d4c6Df81573EAb8826519Cb";
const kanthDeFiStarTokenJson = require("./build/contracts/KanthDeFiStarToken.json");
const kanthDeFiStarTokenAbi = kanthDeFiStarTokenJson.abi;
const kanthDefiStarTokenInstance = await new web3.eth.Contract(kanthDeFiStarTokenAbi,kanthDeFiStarTokenAddress);

var mintRsp1 = await kanthDefiStarTokenInstance.methods.mintToken(owner, 1000000 * 10**18).send({"from" : owner})
await kanthDefiStarTokenInstance.methods.totalSupply().call()
2000000000000000000000000

var burnRsp1 = await kanthDefiStarTokenInstance.methods.burnToken(owner, 50000 * 10**18).send({"from" : owner})
await kanthDefiStarTokenInstance.methods.totalSupply().call()

```

## Command execution for min, burn, lock, release functions on TokenManager contract


```js
const owner = "0x1F61741610892C0A4D3e831Dc91958df2dc27182";
const pvtKey = "193e56edadf08310c8444b03d28105f1cd57bf0b39461975f1183cb2e4987d33";

const kanthDeFiStarTokenAddress = "0x0F0618891f05B3144d4c6Df81573EAb8826519Cb";
const kanthDeFiStarTokenJson = require("./build/contracts/KanthDeFiStarToken.json");
const kanthDeFiStarTokenAbi = kanthDeFiStarTokenJson.abi;
const kanthDefiStarTokenInstance = await new web3.eth.Contract(kanthDeFiStarTokenAbi,kanthDeFiStarTokenAddress);

const tokenManagerAddress = "0xc81B475c24Aa09441e99ebb5dC0C24f0C89f8683";
const tokenManagerJson = require("./build/contracts/TokenManager.json");
const tokenManagerAbi = tokenManagerJson.abi;
const tokenManagerInstance = await new web3.eth.Contract(tokenManagerAbi,tokenManagerAddress);
                                                                                      
var mintRsp1 = await kanthDefiStarTokenInstance.methods.mintToken(tokenManagerAddress,100000 * 10**18).send({"from" : owner})

const user1 = accounts[1];
var lockTokensResponse = await tokenManagerInstance.methods.lockTokens(user1, 2000 * 10**18).send({"from" : owner})

await tokenManagerInstance.methods.getLockedUserTokenBalance(user1).call()

var releaseTokensResponse = await tokenManagerInstance.methods.releaseTokens(user1, 1000 * 10**18).send({"from" : owner})
await kanthDefiStarTokenInstance.methods.balanceOf(user1).call()
1000000000000000000000

const user2 = accounts[2];
var lockTokensResponse = await tokenManagerInstance.methods.lockTokens(user2, 1000 * 10**18).send({"from" : owner})
```


## Command execution for createWallet, lock, release on LockedWallet contract


```js
const owner = "0x1F61741610892C0A4D3e831Dc91958df2dc27182";
const pvtKey = "193e56edadf08310c8444b03d28105f1cd57bf0b39461975f1183cb2e4987d33";
const user1 = accounts[1];
const user2 = accounts[2];
const user3 = accounts[3];
const walletManagerAddress = "0x1F61741610892C0A4D3e831Dc91958df2dc27182";

const kanthDeFiStarTokenAddress = "0x0F0618891f05B3144d4c6Df81573EAb8826519Cb";
const kanthDeFiStarTokenJson = require("./build/contracts/KanthDeFiStarToken.json");
const kanthDeFiStarTokenAbi = kanthDeFiStarTokenJson.abi;
const kanthDefiStarTokenInstance = await new web3.eth.Contract(kanthDeFiStarTokenAbi,kanthDeFiStarTokenAddress);

const lockedWalletFactoryAddress = "0x1ee58F7331244AedA3bf0e39eE44672031ee72C2";

const lockedWalletFactoryJson = require("./build/contracts/LockedWalletFactory.json");
const lockedWalletFactoryAbi = lockedWalletFactoryJson.abi;

const lockedWalletJson = require("./build/contracts/LockedWallet.json");
const lockedWalletAbi = lockedWalletJson.abi;

const lockedWalletFactoryInstance = await new web3.eth.Contract(lockedWalletFactoryAbi, lockedWalletFactoryAddress);

await lockedWalletFactoryInstance.methods.createNewLockedWallet(user1).send({"from" : walletManagerAddress});

await lockedWalletFactoryInstance.methods.getWalletInfoByWalletOwner(user1).call()
[ '0xCd493046fea4d9E3682ABC5DdEE9D7Ec82616d7B',
  '0x4f8e8d218bb72fA696742ce645d721F3B568a3Db',
  '1622472983',
  walletAddress: '0xCd493046fea4d9E3682ABC5DdEE9D7Ec82616d7B',
  walletOwner: '0x4f8e8d218bb72fA696742ce645d721F3B568a3Db',
  doesExist: '1622472983' ]

const walletAddress_1 = "0xbeC082e364e77c77D56fa40f88C92937c0049C10";
const walletOwner = "0x4f8e8d218bb72fA696742ce645d721F3B568a3Db";
var walletInstance_1 = await new web3.eth.Contract(lockedWalletAbi, walletAddress_1);
await walletInstance_1.methods.isLocked().call();
await walletInstance_1.methods.info().call();
await kanthDefiStarTokenInstance.methods.transfer(walletAddress_1, 100).send({"from" : owner});
await walletInstance_1.methods.unlockWallet().send({"from" : walletManagerAddress});
await walletInstance_1.methods.fullWithdrawRewardToken(user1).send({"from" : walletOwner});



await kanthDefiStarTokenInstance.methods.transfer(walletAddress_1, web3.utils.toBN("100000000000000000000")).send({"from" : owner});




token.mint(accounts[2], web3.utils.toBN("555000000000000000000"),{from:accounts[2]})