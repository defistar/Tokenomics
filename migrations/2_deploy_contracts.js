const kanthDeFiToken = artifacts.require('./KanthDeFiToken.sol')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    const kanthDeFiTokenDeployedInstance = await deployer.deploy(kanthDeFiToken);
    console.log(`kanthDeFiToken is deployed with Address: ${kanthDeFiTokenDeployedInstance.address}`);
  
    



});





};