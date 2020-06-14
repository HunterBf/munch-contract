pragma solidity ^0.6.6;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Burnable.sol";

contract MunchToken is ERC20Burnable {
    
    constructor() public ERC20 ("Munchcoin", "MNCH") {
        _mint(msg.sender, 9999999 *10**18);
        // we multiply by 10^18 because there are that many decimal places.
    }
}
