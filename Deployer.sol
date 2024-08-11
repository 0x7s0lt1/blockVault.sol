// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Manager.sol";

contract Deployer{

    address owner;
    address[] managers;

    event Deployed(address);

    constructor(){
        owner = msg.sender;
    }

    modifier ownerOnly{
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function getManagers() external view returns (address[] memory) {
        return managers;
    }

    function getCurrentManager() external view returns (address) {
        return managers[managers.length - 1];
    }


    function deploy() external ownerOnly {

        Manager manager = new Manager( address(this) );
        address addr = manager.getAddress();
       
        managers.push( addr );

        emit Deployed( addr);

    }

    


}
