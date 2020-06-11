pragma solidity ^0.6.6;
import "./Muncher.sol";
contract RewardsPayouts is MunchCommunity {
    
    //we want to show users when they recieve their $MNCH and where they got it from.
    event paymentNotification(string eateryname, string rewardamount);
    
    // Rewarding users with different rank names when they rank up high enough.
    modifier rankReward(uint _rank, uint _id) {
        require(msg.sender == muncherToOwner[_id]);
        _;
    }
    
    function muncherRankReward5(uint _id) external rankReward(5 *(10**18), _id) {
        munchers[_id].rankname = "muncher";
    }
    
    function muncherRankReward10(uint _id) external rankReward(10 *(10**18), _id) {
        munchers[_id].rankname = "munchboy";
    }
    
    //should be in $MNCH but this is the rewards system.
    function muncherPayOut(uint _id, uint _eateryId) external returns(string memory) {
        require(msg.sender == muncherToOwner[_id]);
        _id = _id.sub(1);
        _eateryId = _eateryId.sub(1);
        require(now >= munchers[_id].withdrawTime, "unable to send payout, you just recently got one.");
        eateries[_eateryId].munchers = eateries[_eateryId].munchers.add(1);
        increaseAllowance(address(this), 20 *(10**18));
        if (eateries[_eateryId].certified == true && eateries[_eateryId].local == true) {
            transferFrom(address(this), msg.sender, 20 *(10**18));
            emit paymentNotification(eateries[_eateryId].name, "you've recived 20 $MNCH!");
        } else if (eateries[_eateryId].certified == false && eateries[_eateryId].local == true) {
            transferFrom(address(this), msg.sender, 15 *(10**18));
            emit paymentNotification(eateries[_eateryId].name, "you've recived 15 $MNCH!");
        } else { //chains & nonlocal eateries
            transferFrom(address(this), msg.sender, 10 *(10**18));
            emit paymentNotification(eateries[_eateryId].name, "you've recived 10 $MNCH!");
        } 
        munchers[_id].withdrawTime = now.add(rewardclock);
        return "success!";
    } 
}