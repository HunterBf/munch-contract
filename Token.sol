pragma solidity ^0.6.6;
import "./openzeppelin-contracts-master/contracts/token/ERC20/ERC20Burnable.sol";

contract RockToken is ERC20Burnable {
    
    constructor() public ERC20 ("Rockies", "ROCK") {
        _mint(msg.sender, 9999999 *10**18);
        // we multiply by 10^18 because there are that many decimal places.
    }
}
