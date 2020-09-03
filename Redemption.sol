pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;
import "./Token.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Redemption is Ownable {

    MunchToken public mnchToken;

    constructor(MunchToken _token) public {
        mnchToken = _token;
    }

    //Change owner to a POOL address
    address public munchPool = msg.sender;

    function itemRedemption(uint _itemPrice, uint _munchRate, address _muncher) external onlyOwner {
        require(_munchRate >= 1);
        _itemPrice = _itemPrice * (10**18);
        mnchToken.burnFrom(_muncher, _itemPrice);
        uint _munchMoney = (_itemPrice/_munchRate);
        mnchToken._munchMint(munchPool, _munchMoney, msg.sender);
    }

    function itemRedemptionLocal(uint _itemPrice, address _localEateryAddress, uint _munchRate, uint _localRate, address _muncher) external onlyOwner {
        require(_munchRate >=1 && _localRate >= 1 && _itemPrice > ((_itemPrice/_munchRate) + (_itemPrice/_localRate)));
        _itemPrice = _itemPrice * (10**18);
        mnchToken.burnFrom(_muncher, _itemPrice);
        uint _munchMoney = (_itemPrice/_munchRate);
        mnchToken._munchMint(munchPool, _munchMoney, msg.sender);
        uint _localMoney = (_itemPrice/_localRate);
        mnchToken._munchMint(_localEateryAddress, _localMoney, msg.sender);
    }

   function itemRedemptionSponsor(uint _itemPrice, address _sponsorAddress, uint _munchRate, uint _sponsorRate, address _muncher) external onlyOwner {
       require(_munchRate >=1 && _sponsorRate >= 1 && _itemPrice > ((_itemPrice/_munchRate) + (_itemPrice/_sponsorRate)));
        _itemPrice = _itemPrice *(10**18);
        mnchToken.burnFrom(_muncher, _itemPrice);
        uint _munchMoney = (_itemPrice/_munchRate);
        mnchToken._munchMint(munchPool, _munchMoney, msg.sender);
        uint _sponsorMoney = (_itemPrice/_sponsorRate);
        mnchToken._munchMint(_sponsorAddress, _sponsorMoney, msg.sender);
    }
}
