const lockedWalletFactory = artifacts.require('./LockedWalletFactory')
const lockedWallet = artifacts.require('./LockedWallet')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
      console.log("deployer is not-null : "+deployer);
      // const lockedWalletDeployedInstance = await deployer.deploy(lockedWallet);
      // console.log(`lockedWalletDeployedInstance is deployed with Address: ${lockedWalletDeployedInstance.address}`);
      const lockedWalletFactoryDeployedInstance = await deployer.deploy(lockedWalletFactory,
                                                                        "0x1F61741610892C0A4D3e831Dc91958df2dc27182", 
                                                                        "0xDC459462B9679Ab07983Ff3880a920F5B48F4d67");
      console.log(`lockedWalletFactory is deployed with Address: ${lockedWalletFactoryDeployedInstance.address}`);
  });
};