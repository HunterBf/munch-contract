pragma solidity ^0.6.6;
import "./Muncher.sol";
contract RewardsPayouts is MunchCommunity {

    uint basePay = 20 * (10**18);

    //should be in $MNCH but this is the rewards system.
    function muncherPayout(uint _id, uint _eateryId) public returns (bool success) {
        require(msg.sender == muncherToOwner[_id]);
        _id = _id.sub(1);
        _eateryId = _eateryId.sub(1);
        require(now >= munchers[_id].withdrawTime, "unable to send payout, you just recently got one.");     // Only allow payout every 8 hours
        eateries[_eateryId].munchers = eateries[_eateryId].munchers.add(1);
        // mints new tokens accordingly
        if (eateries[_eateryId].certified == true && eateries[_eateryId].local == true) {
            _mint(msg.sender, basePay); 
            emit paymentNotification(eateries[_eateryId].name, "you've recived 20 $MNCH!");
        } else if (eateries[_eateryId].certified == false && eateries[_eateryId].local == true) {
            _mint(msg.sender, (basePay * 3) / 2);
            emit paymentNotification(eateries[_eateryId].name, "you've recived 15 $MNCH!");
        } else { //chains & nonlocal eateries
            _mint(msg.sender, basePay / 2);
            emit paymentNotification(eateries[_eateryId].name, "you've recived 10 $MNCH!");
            // change above b/c the eatery wont be in our system to take the name from.
        } 
        munchers[_id].withdrawTime = now.add(rewardclock);
        return true;
    }
}
