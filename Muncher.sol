pragma solidity ^0.6.6;
import "./Eatery.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
contract MunchCommunity is EateryInfo {
    
    using Strings for uint;
    
    //we want to show users when they recieve their $MNCH and where they got it from.
    event paymentNotification(string eateryname, string rewardamount);
    
    uint muncherId;
    uint rewardclock = 8 hours;
   
   //a way to store all of our munchers on the blockchain!
    struct Muncher {
        string munchname;
        bool isamuncher;
        bool referral;
        uint referred;
        uint id;
        uint withdrawTime;
        address muncherAddress;
    }
    
    mapping (string => Muncher) public nameToMuncher;
    mapping (address => Muncher) public addressToMuncher;
    
    //function to put together a muncher's name.
    function munchNameMaker(string memory _nickname) internal view returns(string memory) {
        return string(abi.encodePacked(_nickname,"#",muncherId.toString()));
    }
    
    //function to make a muncher and push it to an array. 
    function muncherCreator(string memory _nickname) public returns (string memory) {
        require(addressToMuncher[msg.sender].isamuncher != true, "You're already a muncher!");
        muncherId = muncherId.add(1);
        string memory munchname = munchNameMaker(_nickname);
        nameToMuncher[munchname] = Muncher(munchname, true, false, 0, muncherId, now, msg.sender);
        addressToMuncher[msg.sender] = Muncher(munchname, true, false, 0, muncherId, now, msg.sender);
        return munchname;
    }
    
    // chris mentioned a user should only get rewarded after they have purchased at one eatery.
    function muncherReferral(string memory _existingmuncher, string memory _nickname) public {
        if (nameToMuncher[_existingmuncher].id > 0) {
            muncherCreator(_nickname);
            addressToMuncher[msg.sender].referral = true;
            addressToMuncher[msg.sender].referred = addressToMuncher[msg.sender].referred.add(1);
        } else {
            revert("The muncher who referred you doesn't exist!");
        }
    }
}
