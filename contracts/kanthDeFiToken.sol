pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract KanthDeFiToken is AccessControl, ERC20, ERC20Pausable {
    
    /// @dev Libraries
    using SafeMath for uint;

    /// @dev Roles
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor(address minter_)
        public
        ERC20("KanthDeFi Token", "KANTHDEFI") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, minter_);
		_mint(msg.sender, 1000000);
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
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "KANTHDEFI: caller is not the default admin");
        grantRole(MINTER_ROLE, account);
        return true;
    }

    /// @notice Remove a Minter
    /// @dev Access restricted only for Default Admin
    /// @param account Address of the Minter
    /// @return True if the account address is removed as Minter
    function removeMinter(address account) external returns (bool) {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "KANTHDEFI: caller is not the default admin");
        revokeRole(MINTER_ROLE, account);
        return true;
    }


    /// @notice Pause all the functions
    /// @dev the caller must have the 'PAUSER_ROLE'
    function pause() external {
        require(hasRole(PAUSER_ROLE, msg.sender), "KANTHDEFI: must have pauser role to pause");
        _pause();
    }

    /// @notice Unpause all the functions
    /// @dev the caller must have the 'PAUSER_ROLE'
    function unpause() external {
        require(hasRole(PAUSER_ROLE, msg.sender), "KANTHDEFI: must have pauser role to unpause");
        _unpause();
    }

    /// @notice Prevent transfer to the token contract
    /// @dev Override ERC20 _transfer()
    /// @param sender Sender address
    /// @param recipient Recipient address
    /// @param amount Token amount
    function _transfer(address sender, address recipient, uint amount) internal override {
         require(recipient != address(this), "KANTHDEFI: transfer to the token contract");
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

}