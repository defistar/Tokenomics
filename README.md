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

- tokenManager: 0xD56BFfe6A77D52600F8FE547A0548608D6670cE2
    - https://ropsten.etherscan.io/address/0xD56BFfe6A77D52600F8FE547A0548608D6670cE2


## Command execution for min, burn, totalSupply on kanthDeFiStarToken contract

```js
const owner = "0x1F61741610892C0A4D3e831Dc91958df2dc27182"
const pvtKey = "193e56edadf08310c8444b03d28105f1cd57bf0b39461975f1183cb2e4987d33"
const kanthDeFiStarTokenAddress = "0x0F0618891f05B3144d4c6Df81573EAb8826519Cb";
const kanthDeFiStarTokenJson = require("./build/contracts/KanthDeFiStarToken.json");
const kanthDeFiStarTokenAbi = kanthDeFiStarTokenJson.abi;
const kanthDefiStarTokenInstance = await new web3.eth.Contract(kanthDeFiStarTokenAbi,kanthDeFiStarTokenAddress);

var mintRsp1 = await kanthDefiStarTokenInst.methods.mintToken(owner,45555555555).send({"from" : owner})

await kanthDefiStarTokenInstance.methods.totalSupply().call()
1000000000000045555555555

var burnRsp1 = await kanthDefiStarTokenInst.methods.burnToken(owner,25555555555).send({"from" : owner})

await kanthDefiStarTokenInstance.methods.totalSupply().call()
1000000000000020000000000
```

## Command execution for min, burn, lock, release functions on TokenManager contract


```js
const owner = "0x1F61741610892C0A4D3e831Dc91958df2dc27182";
const pvtKey = "193e56edadf08310c8444b03d28105f1cd57bf0b39461975f1183cb2e4987d33";

const kanthDeFiStarTokenAddress = "0x0F0618891f05B3144d4c6Df81573EAb8826519Cb";
const kanthDeFiStarTokenJson = require("./build/contracts/KanthDeFiStarToken.json");
const kanthDeFiStarTokenAbi = kanthDeFiStarTokenJson.abi;
const kanthDefiStarTokenInstance = await new web3.eth.Contract(kanthDeFiStarTokenAbi,kanthDeFiStarTokenAddress);

const tokenManagerAddress = "0xD56BFfe6A77D52600F8FE547A0548608D6670cE2";
const tokenManagerJson = require("./build/contracts/TokenManager.json");
const tokenManagerAbi = tokenManagerJson.abi;
const tokenManagerInstance = await new web3.eth.Contract(tokenManagerAbi,tokenManagerAddress);

const user1 = accounts[1];
var lockTokensResponse = await tokenManagerInstance.methods.lockTokens(user1,45555555555).send({"from" : owner})

const user2 = accounts[2];
var lockTokensResponse = await tokenManagerInstance.methods.lockTokens(user2,25555555555).send({"from" : owner})

var releaseTokensResponse = await tokenManagerInstance.methods.releaseTokens(user1,45555555555).send({"from" : owner})
```