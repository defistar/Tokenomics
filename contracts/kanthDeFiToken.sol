//SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";

contract KanthDeFiToken is AccessControl, ERC20, ERC20Pausable {
    
    /// @dev Libraries
    using SafeMath for uint;

    /// @dev Roles
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant FEE_SETTER_ROLE = keccak256("FEE_SETTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    /// @dev Data
    uint private _fee;
    address private _feeTo;

    /// @dev Events
    event Wrapped(address to, uint wrapOut, uint wrapFee);
    event Unwrapped(string filaddress, uint unwrapOut, uint unwrapFee);
    event NewFee(uint fee);
    event NewFeeTo(address feeTo);

    constructor(address minter_, address feeTo_, uint fee_)
        public
        ERC20("KanthDeFi Token", "KANTHDEFI")
    {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(FEE_SETTER_ROLE, msg.sender);

        _setupRole(MINTER_ROLE, minter_);
        _setFee(fee_);
        _setFeeTo(feeTo_);
    }

    /// @notice Fallback function
    /// @dev Added not payable to revert transactions not matching any other function which send value
    fallback() external {
        revert();
    }

    /// @notice Getter function for the wrap/unwrap fee
    /// @return _fee current fee
    function fee() external view returns (uint) {
        return _fee;
    }

    /// @notice Set a new fee
    /// @dev Access restricted only for Fee Setters
    /// @dev Call internal function _setFee()
    /// @param kanthDeFiFee fee to set
    /// @return True if kanthDeFiFee is successfully set
    function setFee(uint kanthDeFiFee) external returns (bool) {
        require(hasRole(FEE_SETTER_ROLE, msg.sender), "KANTHDEFI: caller is not the fee setter");
        _setFee(kanthDeFiFee);
        return true;
    }

    /// @notice Set a new feeTo address
    /// @dev Access restricted only for Fee Setters
    /// @dev Call internal function _setFeeTo()
    /// @param feeTo address to set
    /// @return True if feeTo is successfully set
    function setFeeTo(address feeTo) external returns (bool) {
        require(hasRole(FEE_SETTER_ROLE, msg.sender), "KANTHDEFI: caller is not the fee setter");
        _setFeeTo(feeTo);
        return true;
    }

    /// @notice Wrap KANTHDEFI, mint amount (wrapFee + wrapOut)
    /// @dev Access restricted only for Minters
    /// @param to Address of the recipient
    /// @param amount Amount of KANTHDEFI issued
    /// @return True if KANTHDEFI is successfully wrapped
    function wrap(address to, uint amount) external returns (bool) {
        require(hasRole(MINTER_ROLE, msg.sender), "KANTHDEFI: caller is not a minter");
        uint wrapFee = amount.mul(_fee).div(1000);
        uint wrapOut = amount.sub(wrapFee);
        _mint(_feeTo, wrapFee);
        _mint(to, wrapOut);
        emit Wrapped(to, wrapOut, wrapFee);
        return true;
    }

    /// @notice Unwrap KANTHDEFI, transfer unwrapFee + burn uwnrapOut
    /// @dev Emit an event with the Filecoin Address to UI
    /// @param filaddress The Filecoin Address to uwrap KANTHDEFI
    /// @param amount The amount of KANTHDEFI to unwrap
    /// @return True if KANTHDEFI is successfully unwrapped
    function unwrap(string calldata filaddress, uint amount) external returns (bool) {
        uint unwrapFee = amount.mul(_fee).div(1000);
        uint unwrapOut = amount.sub(unwrapFee);
        _transfer(msg.sender, _feeTo, unwrapFee);
        _burn(msg.sender, unwrapOut);
        emit Unwrapped(filaddress, unwrapOut, unwrapFee);
        return true;
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

    /// @notice Add a new Fee Setter
    /// @dev Access restricted only for Default Admin
    /// @param account Address of the new Fee Setter
    /// @return True if the account address is added as Fee Setter
    function addFeeSetter(address account) external returns (bool) {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "KANTHDEFI: caller is not the default admin");
        grantRole(FEE_SETTER_ROLE, account);
        return true;
    }

    /// @notice Remove a Fee Setter
    /// @dev Access restricted only for Default Admin
    /// @param account Address of the Fee Setter
    /// @return True if the account address is removed as Fee Setter
    function removeFeeSetter(address account) external returns (bool) {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "KANTHDEFI: caller is not the default admin");
        revokeRole(FEE_SETTER_ROLE, account);
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

    /// @notice Internal function to set fee
    /// @dev set function visibility to private
    /// @param kanthDeFiFee fee to set
    function _setFee(uint kanthDeFiFee) private {
        _fee = kanthDeFiFee;
        emit NewFee(kanthDeFiFee);
    }

    /// @notice Internal function to set feeTo address
    /// @dev set function visibility to private
    /// @param feeTo address to set
    function _setFeeTo(address feeTo) private {
        require(feeTo != address(0), "KANTHDEFI: set to zero address");
        require(feeTo != address(this), "KANTHDEFI: set to contract address");
        _feeTo = feeTo;
        emit NewFeeTo(feeTo);
    }
}