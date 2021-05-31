
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./LockedWallet.sol";

contract LockedWalletFactory {
 
    address private walletManager;
    address private tokenAddress;

    constructor(address _walletManager, address _tokenAddress) public {
        walletManager =  _walletManager;
        tokenAddress = _tokenAddress;
    }

    //walletAddress -> WalletInfo
    mapping(address => WalletInfo) walletMap;

    //walletOwnerAddress -> walletAddress
    mapping(address => address) walletOwnerToWalletMap;

    address[] private wallets;

    struct WalletInfo {
        address walletAddress;
        address walletOwner;
        uint256 doesExist;
    }

    modifier onlyWalletManager {
        require(msg.sender == walletManager);
        _;
    }

    function updateWalletManager(address _newWalletManager) onlyWalletManager public returns(bool) {
        require(_newWalletManager != address(0), "new WalletManager should be a valid Address");
        address currentWalletManagerAddress = walletManager;
        walletManager = _newWalletManager;
        emit WalletManagerUpdated(currentWalletManagerAddress, walletManager);
        return true;
    }

    function updateTokenAddress(address _newTokenAddress) onlyWalletManager public returns(bool) {
        require(_newTokenAddress != address(0), "newTokenAddress should be a valid Address");
        address currentTokenAddress = tokenAddress;
        tokenAddress = _newTokenAddress;
        emit TokenAddressUpdated(currentTokenAddress, tokenAddress);
        return true;
    }

    function doesWalletExist(address _walletAddress) 
        public
        view
        returns(bool)
    {
        return walletMap[_walletAddress].doesExist > 0;
    }

    function createNewLockedWallet(address _walletOwner) onlyWalletManager 
        payable
        public
        returns(address wallet)
    {
        require(walletOwnerToWalletMap[_walletOwner] == address(0), "Wallet exists for the User");

        // Create new wallet.
        LockedWallet lockedWallet = new LockedWallet();
        lockedWallet.initWallet(tokenAddress, walletManager, _walletOwner);
        wallet = address(lockedWallet);
        
        // Add wallet to sender's mapping in walletMap.
        walletOwnerToWalletMap[_walletOwner] = wallet;

        WalletInfo memory walletInfo = WalletInfo(
                                                {
                                                  walletAddress: wallet,
                                                  walletOwner: _walletOwner,
                                                  doesExist: now
                                                }
                                             );

        walletMap[wallet] = walletInfo;
        wallets.push(wallet);

        // Emit event.
        emit WalletCreated(wallet, walletManager, _walletOwner, now);
    }

    function getWalletInfo(address _walletAddress) view public returns(WalletInfo memory walletInfo){
        return walletMap[_walletAddress];
    }

    function getWalletInfoByWalletOwner(address _walletOwner) view public returns(WalletInfo memory walletInfo){
        require(_walletOwner != address(0), "walletAddress is invalid");
        address wallet = walletOwnerToWalletMap[_walletOwner];
        require(wallet != address(0), "walletAddress doesnot exist for wallet Owner");
        return getWalletInfo(wallet);
    }

    function getAllWallets() view public returns(address[] memory){
        return wallets;
    }

    // Prevents accidental sending of ether to the factory
    fallback() external {
        revert();
    }

    event WalletCreated(address walletAddress, address walletManager, address walletOwner, uint256 createdAt);
    event TokenAddressUpdated(address currentTokenAddress, address newtokenAddress);
    event WalletManagerUpdated(address oldWalletManagerAddress, address newWalletManagerAddress);
}