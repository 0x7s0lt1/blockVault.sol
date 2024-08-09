// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "./Utils.sol";

contract LoyalityCard is VaultItem{

    string name;
    string card_id;

    address owner;
    address parent;

    Utils.ItemType item_type = Utils.ItemType.LOYALITY_CARD;

    constructor(string memory _name, string memory _card_id, address _owner, address _parent){

        name = _name;
        card_id = _card_id;
    
        owner = _owner;
        parent = _parent;

        emit Created(msg.sender);
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getItemType() external view ownerOnly returns (Utils.ItemType) {
        return item_type;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setParent( address _parnet) external  ownerOnly {
        parent = _parnet;

        emit Updated(msg.sender);
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;

        emit Updated(msg.sender);
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
