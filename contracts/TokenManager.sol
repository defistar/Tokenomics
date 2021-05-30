pragma solidity 0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";


interface IKanthDeFiToken {
    function mint(address account, uint256 amount) external returns (bool);
    function burn(address account, uint256 amount) external returns (bool);
}
      

contract TokenManager {

    /// @dev Libraries
    using SafeMath for uint;

    address private tokenAddress;
    address private minterAndBurnerAddress;
    address private owner;

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

    function mintTokens(address user, uint256 amount) onlyMinter external returns (bool) {
        IKanthDeFiToken(tokenAddress).mint(user, amount);
        return true;
    }

    function burnTokens(address user, uint256 amount) onlyBurner external returns (bool) {
        IKanthDeFiToken(tokenAddress).burn(user, amount);
        return true;
    }

    function lockTokens(address user, uint256 amount) onlyOwner external returns (bool) {
        


        return true;
    }

}