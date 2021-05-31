const kanthDeFiStarToken = artifacts.require('./KanthDeFiStarToken')
module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
      console.log("deployer is not-null : "+deployer);
      const kanthDeFiStarTokenDeployedInstance = await deployer.deploy(kanthDeFiStarToken);
      console.log(`kanthDeFiStarToken is deployed with Address: ${kanthDeFiStarTokenDeployedInstance.address}`);
  });
};