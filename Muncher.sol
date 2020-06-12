pragma solidity ^0.6.6;
import "./Eatery.sol";
contract MunchCommunity is EateryInfo, RockToken {
    
    uint muncherId;
    uint rewardclock = 8 hours;
    uint rankUpFee = 100 * (10**18);
    uint referralAmount = 5 * (10**18);
   
   //a way to store all of our munchers on the blockchain!
    struct Muncher {
        string nickname;
        string rankname;
        uint8 rank;
        uint id;
        uint withdrawTime;
    }
    
    Muncher[] public munchers;
    
    mapping (uint => address) public muncherToOwner;
    
    //a function to make a muncher and push it to an array.
    function muncherCreator(string memory _nickname) public {
        muncherId = muncherId.add(1);
        muncherToOwner[muncherId] = msg.sender;
        munchers.push(Muncher(_nickname, "munchie", 1, muncherId, now));
    }
    
    function muncherReferral(uint _muncherId, string memory _nickname) public {
        //may need to be a limitation on this...
        muncherCreator(_nickname);
        _mint(msg.sender, referralAmount);
        _mint(muncherToOwner[_muncherId], referralAmount);
    }
    
    //rank up after acquiring a certain amount of $MNCH.
    function rankUp(uint _id) external payable {
        require(msg.sender == muncherToOwner[_id]);
        burn(rankUpFee);
        //require(msg.value == rankUpFee, "wrong amount of rockies provided");
        Muncher storage myMuncher = munchers[_id.sub(1)];
        myMuncher.rank = myMuncher.rank.add(1); //finding the muncher from the array and increasing its rank.
    }
}
