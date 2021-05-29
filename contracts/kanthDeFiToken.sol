pragma solidity 0.5.16;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

/**
 * @dev Example of the ERC20 Token.
 */
contract KanthDeFiToken is Ownable, ERC20Detailed {

    using SafeMath for uint256;

     uint256 CAP = 1000000000;
     uint256 TOTALSUPPLY = CAP.mul(10 ** 18);

    constructor() 
	public 
	ERC20Detailed('KanthDeFiToken', 'KanthDeFiToken', 18) 
	ERC20Capped(TOTALSUPPLY) Ownable()
	{
		_mint(msg.sender, TOTALSUPPLY);
	}
}