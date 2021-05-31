pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract KanthDeFiStarToken is AccessControl, ERC20, ERC20Pausable {
    
    /// @dev Libraries
    using SafeMath for uint;

    /// @dev Roles
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor()
        public
        ERC20("KanthDeFiPool-Token", "KANTHDEFIPOOL") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(BURNER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
		_mint(msg.sender, 1000000 * 10**18);
    }

    /// @notice Fallback function
    /// @dev Added not payable to revert transactions not matching any other function which send value
    fallback() external {
        revert();
    }

    /// @notice Add a new Minter
    /// @dev Access restricted only for Default Admin
    /// @param account Address of the new Minter
    /// @return True if the account address is added as Minter
    function addMinter(address account) external returns (bool) {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "DEFISTAR: caller is not the default admin");
        grantRole(MINTER_ROLE, account);
        return true;
    }

    /// @notice Remove a Minter
    /// @dev Access restricted only for Default Admin
    /// @param account Address of the Minter
    /// @return True if the account address is removed as Minter
    function removeMinter(address account) external returns (bool) {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "DEFISTAR: caller is not the default admin");
        revokeRole(MINTER_ROLE, account);
        return true;
    }

    /// @notice Pause all the functions
    /// @dev the caller must have the 'PAUSER_ROLE'
    function pause() external {
        require(hasRole(PAUSER_ROLE, msg.sender), "DEFISTAR: must have pauser role to pause");
        _pause();
    }

    /// @notice Unpause all the functions
    /// @dev the caller must have the 'PAUSER_ROLE'
    function unpause() external {
        require(hasRole(PAUSER_ROLE, msg.sender), "DEFISTAR: must have pauser role to unpause");
        _unpause();
    }

    /// @notice Prevent transfer to the token contract
    /// @dev Override ERC20 _transfer()
    /// @param sender Sender address
    /// @param recipient Recipient address
    /// @param amount Token amount
    function _transfer(address sender, address recipient, uint amount) internal override {
         require(recipient != address(this), "DEFISTAR: transfer to the token contract");
         super._transfer(sender, recipient, amount);
    }

    /// @notice Hook to pause _mint(), _transfer() and _burn()
    /// @dev Override ERC20 and ERC20Pausable Hooks
    /// @param from Sender address
    /// @param to Recipient address
    /// @param amount Token amount
    function _beforeTokenTransfer(address from, address to, uint amount) internal override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }

    function mintToken(address user, uint256 amount) external returns (bool){
        require(hasRole(MINTER_ROLE, msg.sender), "DEFISTAR: caller is not allowed to mint tokens");
        require(user != address(0),"user should be a valid address");
        require(amount > 0, "amount should be valid");
        _mint(user, amount);
        return true;
    }

    function burnToken(address user, uint256 amount) external returns (bool){
        require(hasRole(BURNER_ROLE, msg.sender), "DEFISTAR: caller is not allowed to burn tokens");
        require(user != address(0),"user should be a valid address");
        require(amount > 0, "amount should be valid");
        require(amount <= totalSupply(), "cannot burn more than totalSupply");
        _burn(user, amount);
        return true;
    }
}