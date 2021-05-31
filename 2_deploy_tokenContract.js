const kanthDeFiRewardToken = artifacts.require('./KanthDeFiRewardToken')
module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
      console.log("deployer is not-null : "+deployer);
      const kanthDeFiRewardTokenDeployedInstance = await deployer.deploy(kanthDeFiRewardToken);
      console.log(`kanthDeFiRewardToken is deployed with Address: ${kanthDeFiRewardTokenDeployedInstance.address}`);
  });
};