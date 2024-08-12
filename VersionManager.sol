// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;


contract VersionManager{

    struct State {
        uint256 timestamp;
        address addr;
    }

    State[] states;
    address currentManager;

    address owner;

    event Deployed(address);
    event Set(address);

    constructor(){
        owner = msg.sender;
    }

    modifier ownerOnly{
        require(msg.sender == owner, "Only owner");
        _;
    }

    function getCurrentManager() external view returns (address) {
        return currentManager;
    }

    function getStates() external view returns (State[] memory) {
        return states;
    }

    function setBackTo(address _addr) external ownerOnly {    

        if( findSate(_addr, states) == -1) revert("No index");
        currentManager = _addr;

        emit Set(_addr);
     }

     function postState(address _manager, bool setToCurrent) external ownerOnly {

        if( findSate(_manager, states) != -1) revert("Exists");
        states.push(State(block.timestamp, _manager));

        if(setToCurrent) currentManager = _manager;

        emit Deployed(_manager);
     }

    function findSate(address _value, State[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i].addr == _value) return int(i);
        }
        return -1;
    }


}
