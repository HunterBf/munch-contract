pragma solidity ^0.6.6;
import "./Muncher.sol";
contract RewardsPayouts is MunchCommunity {
    
    //we want to show users when they recieve their $MNCH and where they got it from.
    event paymentNotification(string eateryname, string rewardamount);

    uint public basePay = 20 * (10**18);
    uint referralAmount = 5 * (10**18);

    function changeBasePay(uint _basePay) public onlyOwner returns(uint) {
        basePay = _basePay * (10**18);
        return basePay;
    } 
    
    function changeReferralPay(uint _referralAmount) public onlyOwner returns(uint) {
        referralAmount = _referralAmount * (10**18);
        return referralAmount;
    }
    
    //will need chainlink/plaid integration here
    function muncherPayout(address _muncherAddress, uint _eateryId) public onlyOwner returns (bool success) {
        require(now >= addressToMuncher[_muncherAddress].withdrawTime, "unable to send payout, you just recently got one.");     // Only allow payout every 8 hours
        eateryIndex[_eateryId].munchers = eateryIndex[_eateryId].munchers.add(1);
        // mints new tokens accordingly
        if (eateryIndex[_eateryId].certified == true && eateryIndex[_eateryId].local == true) {
            _mint(_muncherAddress, basePay); 
            emit paymentNotification(eateryIndex[_eateryId].name, "you've recived 20 $MNCH!");
        } else if (eateryIndex[_eateryId].certified == false && eateryIndex[_eateryId].local == true) {
            _mint(_muncherAddress, (basePay * 3) / 2);
            emit paymentNotification(eateryIndex[_eateryId].name, "you've recived 15 $MNCH!");
        } else { //chains & nonlocal eateries
            _mint(_muncherAddress, basePay / 2);
            emit paymentNotification(eateryIndex[_eateryId].name, "you've recived 10 $MNCH!");
            // change above b/c the eatery wont be in our system to take the name from.
        } 
        addressToMuncher[_muncherAddress].withdrawTime = now.add(rewardclock);
        return true;
    }
    
    // not done yet
    function referralPayout(address _referredAddress, address _referralAddress) external onlyOwner {
        _mint(_referralAddress, referralAmount);
        _mint(_referredAddress, referralAmount);
        emit paymentNotification("Referral", "5 $MNCH");
    }
}