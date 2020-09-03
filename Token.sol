pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract MunchToken is ERC20Burnable, Ownable {

    constructor() public ERC20 ("Munchcoin", "MNCH") {
        _mint(msg.sender, 1000 *10**18);
        // we multiply by 10^18 because there are that many decimal places.
    }

    function _munchMint(address _muncherAddress, uint _amount, address _owner) external {
        require(_owner == owner());
        _mint(_muncherAddress, _amount);
    }
}
