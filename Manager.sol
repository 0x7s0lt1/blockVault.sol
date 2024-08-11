// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./UserVault.sol";

contract Manager{

    address owner;
    address parent;

    mapping (address => address) ownerToVaultMap;

    constructor(address _parent){
        owner = msg.sender;
        parent = _parent;
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getVaultByOwner() external view returns (address) {

        return ownerToVaultMap[msg.sender];
    }

    function createVault() external returns (address) {

        if( ownerToVaultMap[msg.sender] == address(0) ){

            UserVault vault = new UserVault( payable(msg.sender), address(this) );
            ownerToVaultMap[msg.sender] = vault.getAddress();

        }

        return ownerToVaultMap[msg.sender];

    }


}
