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