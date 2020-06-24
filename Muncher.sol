pragma solidity ^0.6.6;
import "./Eatery.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
contract MunchCommunity is EateryInfo, MunchToken {
    
    using Strings for uint;
    
    //we want to show users when they recieve their $MNCH and where they got it from.
    event paymentNotification(string eateryname, string rewardamount);
    
    uint muncherId;
    uint muncherIdArray;
    uint rewardclock = 8 hours;
    uint referralAmount = 5 * (10**18);
   
   //a way to store all of our munchers on the blockchain!
    struct Muncher {
        string munchname;
        string rankname;
        bool isamuncher;
        bool referral;
        uint id;
        uint withdrawTime;
    }
    
    Muncher[] internal munchers;
    
    //may be too many mappings..
    mapping (uint => address) public muncherToOwner;
    mapping (string => address) public muncherNameToOwner;
    mapping (address => Muncher) public addressToMuncher;
    mapping (string => uint) public muncherNameToId;
    
    //function to put together a muncher's name.
    function munchNameMaker(string memory _nickname) internal view returns(string memory) {
        return string(abi.encodePacked(_nickname,"#",muncherId.toString()));
    }
    
    //function to make a muncher and push it to an array.
    function muncherCreator(string memory _nickname) public {
        require(addressToMuncher[msg.sender].isamuncher != true, "You're already a muncher!");
        muncherIdArray = muncherId;
        muncherId = muncherId.add(1);
        string memory munchname = munchNameMaker(_nickname);
        munchers.push(Muncher(munchname, "munchie", true, false, muncherId, now));
        muncherToOwner[muncherId] = msg.sender;
        muncherNameToOwner[munchname] = msg.sender;
        addressToMuncher[msg.sender] = munchers[muncherIdArray];
        muncherNameToId[munchname] = muncherId;
    }
    
    
    //may need to be a limitation on this...
    // chris mentioned a user should only get rewarded after they have purchased at one eatery.
    // needs to beb chang
    function muncherReferral(string memory _existingmuncher, string memory _nickname) public {
        if (muncherNameToId[_existingmuncher] > 0) {
            muncherCreator(_nickname);
            _mint(msg.sender, referralAmount);
            _mint(muncherNameToOwner[_existingmuncher], referralAmount);
            uint myArrayId = addressToMuncher[msg.sender].id - 1;
            munchers[myArrayId].referral = true;
            emit paymentNotification("Referral", "5 $MNCH");
        } else {
            revert("The muncher who referred you doesn't exist!");
        }
    }
}
