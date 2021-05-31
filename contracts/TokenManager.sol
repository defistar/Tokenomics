pragma solidity 0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenManager {

    /// @dev Libraries
    using SafeMath for uint;

    address private tokenAddress;
    address private owner;

    mapping(address => uint256) private lockedUserBalances;
    mapping(address => address) private usersWithLockedBalance;
    uint256 private totalLockedUserTokens;

    event LockedTokens(address indexed user, uint256 lockedAmount, uint256 totalLockedAmount);
    event ReleasedTokens(address indexed user, uint256 releasedAmount, uint256 totalLockedAmount);

    constructor(address _tokenAddress) public {
        tokenAddress =  _tokenAddress;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "only owner can execute the function");
        _;
    }

    function lockTokens(address user, uint256 amount) onlyOwner public returns (bool) {
        require(amount > 0, "nonZero Amount to be locked");
        require(amount <= IERC20(tokenAddress).balanceOf(address(this)), "amount to be locked cannot exceed balance of the tokenManager");
        require(user != address(0), "user should be a valid address");
        uint256 userLockedAmount = lockedUserBalances[user];
        uint256 newUserLockedAmount = userLockedAmount.add(amount);
        lockedUserBalances[user] = newUserLockedAmount;
        totalLockedUserTokens = totalLockedUserTokens.add(amount);
        usersWithLockedBalance[user] = user;
        emit LockedTokens(user, amount, lockedUserBalances[user]);
        return true;
    }

    function releaseTokens(address user, uint256 amount) onlyOwner public returns(bool){
        require(amount > 0, "locked amount should be nonZero Amount");
        require(amount <= IERC20(tokenAddress).balanceOf(address(this)), "amount to be released cannot exceed balance of the tokenManager");
        require(user != address(0), "user should be a valid address");
        require(usersWithLockedBalance[user] != address(0), "user is not in lockedBalances mapping");
        require(amount >= lockedUserBalances[user], "cannot release amount more than locked in User Account");
        IERC20(tokenAddress).transfer(user, amount);
        uint256 userLockedAmount = lockedUserBalances[user];
        uint256 newUserLockedAmount = userLockedAmount.sub(amount);
        lockedUserBalances[user] = newUserLockedAmount;
        totalLockedUserTokens = totalLockedUserTokens.sub(amount);
        emit ReleasedTokens(user, amount, lockedUserBalances[user]);
        return true;
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