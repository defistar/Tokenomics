pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract LockedWallet {

    address private tokenAddress;
    address public walletManager;
    address public walletOwner;
    uint256 public createdAt;
    uint256 public isLocked;

    modifier onlyWalletManager {
        require(msg.sender == walletManager);
        _;
    }

    modifier onlyWalletOwner {
        require(msg.sender == walletOwner);
        _;
    }

    modifier isAnUnlockedWallet {
        require(isLocked == 0, "Wallet should be unlocked");
        _;
    }

    function initWallet(
        address _tokenAddress,
        address _walletManager,
        address _walletOwner
    ) public {
        tokenAddress = _tokenAddress;
        walletManager = _walletManager;
        walletOwner = _walletOwner;
        createdAt = now;
        isLocked = now;
    }

    // keep all the ether and tokens sent to this address
    fallback() payable external { 
        Received(msg.sender, msg.value);
    }

    function unlockWallet() onlyWalletManager public returns (bool){
        require(isLocked > 0, "Cannot unlock an already unlocked Wallet");
        isLocked = 0;
        return true;
    }

    function getWalletBalance() public returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function fullWithdraw(address _assetAddress, address _recipient) onlyWalletOwner isAnUnlockedWallet public {
    
       uint256 tokenBalance = IERC20(_assetAddress).balanceOf(address(this));
       require(tokenBalance > 0, "wallet is empty");

       //now send all the balance
       IERC20(tokenAddress).transfer(_recipient, tokenBalance);
       
       FullWithdrawal(_assetAddress, msg.sender, tokenBalance);
    }

    // callable by owner only, and if wallet is unlocked
    function fullWithdrawRewardToken(address _recipient) onlyWalletOwner isAnUnlockedWallet public {
    
       uint256 tokenBalance = IERC20(tokenAddress).balanceOf(address(this));
       require(tokenBalance > 0, "wallet is empty");

       //now send all the balance
       IERC20(tokenAddress).transfer(_recipient, tokenBalance);
       
       FullWithdrawal(tokenAddress, msg.sender, tokenBalance);
    }

    function withdraw(address _assetAddress, address _recipient, uint256 _amount) onlyWalletOwner isAnUnlockedWallet public {
                     
       uint256 tokenBalance = IERC20(_assetAddress).balanceOf(address(this));
       
       require(tokenBalance > 0, "wallet is empty");
       require(_amount >= tokenBalance, "withdrawal amount exceeds the tokenBalance of Wallet");
       
       IERC20(_assetAddress).transfer(_recipient, _amount);
       
       WithdrawTokens(_assetAddress, msg.sender, _amount);
    }

    function withdrawRewardToken(address _recipient, uint256 _amount) onlyWalletOwner isAnUnlockedWallet public {
                     
       uint256 tokenBalance = IERC20(tokenAddress).balanceOf(address(this));
       
       require(tokenBalance > 0, "wallet is empty");
       require(_amount >= tokenBalance, "withdrawal amount exceeds the tokenBalance of Wallet");
       
       IERC20(tokenAddress).transfer(_recipient, _amount);
       WithdrawTokens(tokenAddress, msg.sender, _amount);
    }

    function info() public view returns(address, address, bool, uint256, uint256) {
        uint256 tokenBalance = IERC20(tokenAddress).balanceOf(address(this));
        return (walletManager, walletOwner, isLocked > 0, createdAt, tokenBalance);
    }

    event Received(address from, uint256 amount);
    event FullWithdrawal(address assetAddress, address to, uint256 amount);
    event WithdrawTokens(address assetAddress, address to, uint256 amount);
}