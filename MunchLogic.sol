pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;
import "./Token.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract MunchLogic is Ownable {

    MunchToken public mnchToken;

    constructor(MunchToken _token) public {
        mnchToken = _token;
    }

    //Change owner to a POOL address
    address public munchPool = msg.sender;
    event paymentNotification(string rewardamount);


    uint public certifiedPay = 1 * (10**18);
    uint public localPay = (10**18)/2;
    uint public chainPay = (10**18)/4;

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



    function changeCertifiedPay(uint _newPay) public onlyOwner returns(uint) {
        certifiedPay = _newPay * (10**18);
        return certifiedPay;
    }

    function changeLocalPay(uint _newPay) public onlyOwner returns(uint) {
        localPay = _newPay * (10**18);
        return localPay;
    }

    function changeChainPay(uint _newPay) public onlyOwner returns(uint) {
        chainPay = _newPay * (10**18);
        return chainPay;
    }

    function hashCompareWithLengthCheck(string memory a, string memory b) pure internal returns (bool) {
    if (bytes(a).length != bytes(b).length) {
        return false;
    } else {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}

    function muncherPayout(address _muncherAddress, uint _fiatAmount, string memory _eateryStatus) public onlyOwner returns (bool success) {
        if (hashCompareWithLengthCheck(_eateryStatus, "certified")) {
            mnchToken._munchMint(_muncherAddress, certifiedPay * _fiatAmount, msg.sender);
            emit paymentNotification(string(abi.encodePacked(certifiedPay * _fiatAmount/(10**18), " $MNCH!")));
            return true;
        } else if (hashCompareWithLengthCheck(_eateryStatus, "local")) {
            mnchToken._munchMint(_muncherAddress, localPay * _fiatAmount, msg.sender);
            emit paymentNotification(string(abi.encodePacked(localPay * _fiatAmount/(10**18), " $MNCH!")));
            return true;
        } else { //chains & nonlocal eateries
            mnchToken._munchMint(_muncherAddress, chainPay * _fiatAmount, msg.sender);
            emit paymentNotification(string(abi.encodePacked(chainPay * _fiatAmount/(10**18), " $MNCH!")));
            return true;
        }

    }
}
