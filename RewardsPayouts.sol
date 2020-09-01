pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;
import "./Token.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
contract RewardsPayouts is Ownable, MunchToken {
    
    //we want to show users when they recieve their $MNCH and where they got it from.
    event paymentNotification(string rewardamount);

    uint public certifiedPay = 1 * (10**18);
    uint public localPay = (10**18)/2;
    uint public chainPay = (10**18)/4;

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
            _mint(_muncherAddress, certifiedPay * _fiatAmount); 
            emit paymentNotification(string(abi.encodePacked(certifiedPay * _fiatAmount/(10**18), " $MNCH!")));
            return true;
        } else if (hashCompareWithLengthCheck(_eateryStatus, "local")) {
            _mint(_muncherAddress, localPay * _fiatAmount); 
            emit paymentNotification(string(abi.encodePacked(localPay * _fiatAmount/(10**18), " $MNCH!")));
            return true;
        } else { //chains & nonlocal eateries
            _mint(_muncherAddress, chainPay * _fiatAmount); 
            emit paymentNotification(string(abi.encodePacked(chainPay * _fiatAmount/(10**18), " $MNCH!")));
            return true;
        }
        
    }
}
