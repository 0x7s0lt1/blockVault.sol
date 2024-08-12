// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Manager.sol";

contract Deployer{

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
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function getCurrentManager() external view returns (address) {
        return currentManager;
    }

    function getStates() external view returns (State[] memory) {
        return states;
    }

    function setBackTo(address _addr) external ownerOnly {    

        if( findSate(_addr, states) == -1) revert("State doesn't exists");

        currentManager = _addr;

        emit Set(_addr);
     }

    function deploy(bytes memory _bytecode, bool setToCurrent) external ownerOnly {

        bytes memory _bwa = bytes.concat( 
                _bytecode,
                abi.encode( address(this) )
            );
    
        address addr;
        assembly {
            addr := create(0, add(_bwa, 0x20), mload(_bwa))
        }
    
        require(addr != address(0), "Contract deployment failed");

        states.push( State(block.timestamp, addr) );
       
        if(setToCurrent) currentManager = addr;


        emit Deployed( addr );

    }

    function findSate(address _value, State[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i].addr == _value) return int(i);
        }
        return -1;
    }

    


}
