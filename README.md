# Tokenomics
 - Token Contract with SafeERC20 Specs
 - Contract to mint, burn and Lock tokens
 - Deploy Instructions

## Deployment to Ropsten:
truffle migrate --reset --network ropsten

## Addresses from deployment:
- DeFiStar token Address: 0x0F0618891f05B3144d4c6Df81573EAb8826519Cb
- owner: 0x1F61741610892C0A4D3e831Dc91958df2dc27182
- tokenManager: 


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

