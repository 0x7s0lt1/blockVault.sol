// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "../Libs/Constants.sol";

contract LoyalityCard is VaultItem{

    string card_id;

    constructor(
        string memory _name,
        string memory _card_id,
        address _owner,
        address _parent
    ) VaultItem( 
        _name,
        Constants.ItemType.LOYALITY_CARD,
        _owner,
        _parent
    ){

        card_id = _card_id;
    
        owner = _owner;
        parent = _parent;

        emit Created(msg.sender);
    }


    function setCardId(string memory _card_id) external ownerOnly {
        card_id = _card_id;

        emit Updated(msg.sender);
    }

    function setItem(string memory _name, string memory _card_id) external ownerOnly {
        name = _name;
        card_id = _card_id;

        emit Updated(msg.sender);
    }

    function expose() external view ownerOnly returns ( string memory, string memory) {
        return ( name, card_id );
    }


}
