const tokenManager = artifacts.require('./TokenManager')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
      console.log("deployer is not-null : "+deployer);
      const tokenManagerDeployedInstance = await deployer.deploy(tokenManager, "0x0F0618891f05B3144d4c6Df81573EAb8826519Cb");
      console.log(`tokenManager is deployed with Address: ${tokenManagerDeployedInstance.address}`);
  });
};