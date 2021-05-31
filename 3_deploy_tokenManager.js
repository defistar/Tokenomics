const tokenManager = artifacts.require('./TokenManager')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
      console.log("deployer is not-null : "+deployer);
      const tokenManagerDeployedInstance = await deployer.deploy(tokenManager, "0x05fd088a8691d31682cc8f8e6869e216fcd30063", "0x1F61741610892C0A4D3e831Dc91958df2dc27182");
      console.log(`tokenManager is deployed with Address: ${tokenManagerDeployedInstance.address}`);
  });
};