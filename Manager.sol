// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./UserVault.sol";

contract Manager{

    address owner;
    mapping (address => address) ownerToVaultMap;

    constructor(){
        owner = msg.sender;
    }

    modifier ownerOnly {
        require(owner == msg.sender, "Only the owner can call this function!");
        _;
    }

    function getVaultByOwner(address _addr) external view ownerOnly returns (address) {

        return ownerToVaultMap[_addr];
    }

    function createVault() external ownerOnly returns (address) {

        if( ownerToVaultMap[msg.sender] == address(0) ){

            UserVault vault = new UserVault( msg.sender, address(this) );
            ownerToVaultMap[msg.sender] = vault.getAddress();

        }

        return ownerToVaultMap[msg.sender];

    }


}
