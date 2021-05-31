# Tokenomics

 - Token Contract with SafeERC20 Specs
 - Contract to mint, burn and Lock tokens
 - Deploy Instructions


- DeFiStar token Address: 0x05fd088a8691d31682cc8f8e6869e216fcd30063
- owner: 0x1F61741610892C0A4D3e831Dc91958df2dc27182
- tokenManager: 0x9f5A6DA607a2CB47dC695Ad0437f50F34907B7f9


truffle(ropsten)> const owner = "0x1F61741610892C0A4D3e831Dc91958df2dc27182"
undefined
truffle(ropsten)> const pvtKey = "193e56edadf08310c8444b03d28105f1cd57bf0b39461975f1183cb2e4987d33"
undefined
truffle(ropsten)> const defiStarTokenAddress = "0x05fd088a8691d31682cc8f8e6869e216fcd30063"
truffle(ropsten)> const tokenManagerAddress = "0x9f5A6DA607a2CB47dC695Ad0437f50F34907B7f9"




const defiStarTokenJson = require("./build/contracts/DeFiStarToken.json");
const defiStarTokenAbi = defiStarTokenJson.abi;
const defiStarTokenInstance = await new web3.eth.Contract(defiStarTokenAbi,defiStarTokenAddress);
const kanthDefiStarTokenInstance = await new web3.eth.Contract(defiStarTokenAbi,tokenAddress);

0x48D4d85E4a8197c8Ef30E15a548a18fd53ECbd90

const tokenManagerJson = require("./build/contracts/TokenManager.json");
const tokenManagerAbi = tokenManagerJson.abi;
const tokenManagerInst = new web3.eth.Contract(tokenManagerAbi,tokenManagerAddress");

var res1 = await tokenManagerInst.methods.mintTokens("0x1F61741610892C0A4D3e831Dc91958df2dc27182", 500000).call({"from":"0x1F61741610892C0A4D3e831Dc91958df2dc27182"});


var rsp1 = await kanthDefiStarTokenInstance.methods.mintToken(owner, 500000).send({"from": minter})
var totalSupply = await kanthDefiStarTokenInstance.methods.totalSupply().call();


await kanthDefiStarTokenInstance.methods.totalSupply().call();

