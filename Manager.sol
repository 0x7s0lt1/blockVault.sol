// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Vault.sol";

contract Manager{

    address owner;
    address parent;

    mapping (address => address) ownerToVaultMap;

    constructor(address _parent){
        owner = msg.sender;
        parent = _parent;
    }

    function getVaultByOwner() external view returns (address) {

        return ownerToVaultMap[msg.sender];
    }

    function createVault() external returns (address) {

        if( ownerToVaultMap[msg.sender] == address(0) ){

            ownerToVaultMap[msg.sender] = address(
                (new Vault( payable(msg.sender), address(this) ))
            );

        }

        return ownerToVaultMap[msg.sender];

    }


}
