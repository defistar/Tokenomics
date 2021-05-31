pragma solidity 0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IKanthDeFiToken {
    function mintToken(address account, uint256 amount) external returns (bool);
    function burnToken(address account, uint256 amount) external returns (bool);
}

contract TokenManager {

    /// @dev Libraries
    using SafeMath for uint;

    address private tokenAddress;
    address private minterAndBurnerAddress;
    address private owner;

    mapping(address => uint256) private lockedUserBalances;
    mapping(address => address) private usersWithLockedBalance;
    uint256 private totalLockedUserTokens;

    constructor(address _tokenAddress, address _minterAndBurnerAddress) public {
        tokenAddress =  _tokenAddress;
        minterAndBurnerAddress = _minterAndBurnerAddress;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "only owner can execute the function");
        _;
    }

    modifier onlyMinter {
        require(msg.sender == minterAndBurnerAddress, "only Minter can mint tokens");
        _;
    }

    modifier onlyBurner {
        require(msg.sender == minterAndBurnerAddress, "only Burner can burn tokens");
        _;
    }

    function mintTokens(address user, uint256 amount) onlyMinter public returns (bool) {
        require(user != address(0),"user should be a valid address");
        require(amount > 0, "amount should be valid");
        IKanthDeFiToken(tokenAddress).mintToken(user, amount);
        return true;
    }

    function burnTokens(address user, uint256 amount) onlyBurner public returns (bool) {
        require(user != address(0),"user should be a valid address");
        require(amount > 0, "amount should be valid");
        IKanthDeFiToken(tokenAddress).burnToken(user, amount);
        return true;
    }

    function lockTokens(address user, uint256 amount) onlyOwner public returns (bool) {
        require(amount > 0, "nonZero AMount to be locked");
        require(user != address(0), "user should be a valid address");
        lockedUserBalances[user].add(amount);
        usersWithLockedBalance[user] = user;
        totalLockedUserTokens = totalLockedUserTokens + amount;
        return true;
    }

    function releaseTokens(address user, uint256 amount) onlyOwner public returns(bool){
        require(amount > 0, "locked amount should be nonZero Amount");
        require(user != address(0), "user should be a valid address");
        require(usersWithLockedBalance[user] != address(0), "user is not in lockedBalances mapping");
        require(amount >= lockedUserBalances[user], "cannot release amount more than locked in User Account");
        IERC20(tokenAddress).transfer(user, amount);
        totalLockedUserTokens = totalLockedUserTokens - amount;
    }

    function getTotalLockedUserTokens() view external returns (uint256) {
        return totalLockedUserTokens;
    }

    function getLockedUserTokenBalance(address user) view external returns (uint256) {
        require(user != address(0), "user should be a valid address");
        return lockedUserBalances[user];
    }

    function doesUserHaveLockedBalance(address user) view external returns (bool) {
        require(user != address(0), "user should be a valid address");
        return usersWithLockedBalance[user]!= address(0);
    }
}