pragma solidity ^0.6.6;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/token/ERC20/ERC20.sol";

contract RockToken is ERC20 {
    
    constructor() public ERC20("Rockies", "ROCK") {
        _mint(msg.sender, 9999999 *10**18);
        // we multiply by 10^18 because there are that many decimal places.
    }
}
