pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;
import "./RewardsPayouts.sol";
contract Redemption is RewardsPayouts {

    //Change owner to a POOL address
    address public munchPool = owner();

    function itemRedemption(uint _itemPrice, uint _munchRate) external onlyOwner {
        require(_munchRate >= 1);
        _itemPrice = _itemPrice * (10**18);
        _burn(msg.sender, _itemPrice);
        uint _munchMoney = (_itemPrice/_munchRate);
        _mint(munchPool, _munchMoney);
    }

    function itemRedemptionLocal(uint _itemPrice, address _localEateryAddress, uint _munchRate, uint _localRate) external onlyOwner {
        require(_munchRate >=1 && _localRate >= 1 && _itemPrice > ((_itemPrice/_munchRate) + (_itemPrice/_localRate)));
        _itemPrice = _itemPrice * (10**18);
        _burn(msg.sender, _itemPrice);
        uint _munchMoney = (_itemPrice/_munchRate);
        _mint(munchPool, _munchMoney);
        uint _localMoney = (_itemPrice/_localRate);
        _mint(_localEateryAddress, _localMoney);
    }

   function itemRedemptionSponsor(uint _itemPrice, address _sponsorAddress, uint _munchRate, uint _sponsorRate) external onlyOwner {
       require(_munchRate >=1 && _sponsorRate >= 1 && _itemPrice > ((_itemPrice/_munchRate) + (_itemPrice/_sponsorRate)));
        _itemPrice = _itemPrice *(10**18);
        _burn(msg.sender, _itemPrice);
        uint _munchMoney = (_itemPrice/_munchRate);
        _mint(munchPool, _munchMoney);
        uint _sponsorMoney = (_itemPrice/_sponsorRate);
        _mint(_sponsorAddress, _sponsorMoney);
    }
}