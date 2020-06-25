pragma solidity ^0.6.6;
import "./token.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
contract EateryInfo is Ownable, MunchToken {
    
    uint eateryId;
    
    // everytime a new eatery is made, we want people to know!
    event newEatery(string name,string location, uint id);
    
    using SafeMath for uint256;
    
    // an array for the eateries added to the app.   
    struct Eatery {
       string name;
       string location;
       bool certified;
       bool local;
       uint munchers;
       uint id;
    }
    
    mapping (uint => Eatery) public eateryIndex;
    
     //a manual way to onboard eateries, however only WE can add them.
    function eateryCreator(string calldata _name, string calldata _location, bool _certified, bool _local) external onlyOwner {
     eateryId = eateryId.add(1);
     eateryIndex[eateryId] = Eatery(_name, _location, _certified, _local, 0, eateryId);
     emit newEatery(_name, _location, eateryId);
    }
    
    function eateryNameChanger(uint _eateryId, string calldata _name) external onlyOwner {
        eateryIndex[_eateryId].name = _name;
    }
    
    function eateryLocationChanger(uint _eateryId, string calldata _location) external onlyOwner {
        eateryIndex[_eateryId].location = _location;
    }
    
    function eateryLocalityChanger(uint _eateryId, bool _local) external onlyOwner {
        eateryIndex[_eateryId].local = _local;
    }
}
