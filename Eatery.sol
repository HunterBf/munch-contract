pragma solidity ^0.6.6;
import "./SafeMath8.sol";
import "./token.sol";
contract EateryInfo {
    
    uint eateryId;
    
    // everytime a new eatery is made, we want people to know!
    event newEatery(string name,string location, uint id);
    
    using SafeMath for uint256;
    using SafeMath8 for uint8;
    
    // making sure we are the owner of the contract.
    constructor() public {
        owner = msg.sender;
    }
    
    // an array for the eateries added to the app.   
    struct Eatery {
       string name;
       string location;
       bool certified;
       bool local;
       uint munchers;
       uint id;
    }
    
    Eatery[] public eateries;
    mapping (uint => address) eateryToOwner;
    
    //a manual way to onboard eateries, however only WE can add them.
    function eateryCreator(string calldata _name, string calldata _location, bool _certified, bool _local) external {
     require(owner == msg.sender);
     eateryId = eateryId.add(1);
     eateries.push(Eatery(_name, _location, _certified, _local, 0, eateryId));
     emit newEatery(_name, _location, eateryId);
    }
}
