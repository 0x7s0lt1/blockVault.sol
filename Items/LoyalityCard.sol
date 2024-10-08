// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";

contract LoyalityCard is VaultItem{

    string card_id;

    constructor(
        string memory _name,
        string memory _card_id,
        address _owner,
        address _parent
    ) VaultItem( 
        0,
        _name,
        _owner,
        _parent
    ){

        card_id = _card_id;
    
        owner = _owner;
        parent = _parent;

        emit Created(msg.sender);
    }


    function setCardId(string memory _c_id) external ownerOnly {
        card_id = _c_id;

        emit Updated(msg.sender);
    }

    function setItem(string memory _n, string memory _c_id) external ownerOnly {
        name = _n;
        card_id = _c_id;

        emit Updated(msg.sender);
    }

    function expose() external view ownerOrShared returns ( string memory, string memory) {
        return ( name, card_id );
    }


}
