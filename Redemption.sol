pragma solidity ^0.6.6;
import "./RewardsPayouts.sol";
contract Redemption is RewardsPayouts {
    
    //Change owner to a POOL address
    address public munchPool = owner();
    
    function itemRedemption(uint _itemPrice) external {
        _itemPrice = _itemPrice *(10**18);
        uint _munchMoney = (_itemPrice/100);
        _mint(owner(), _munchMoney);
    }
}