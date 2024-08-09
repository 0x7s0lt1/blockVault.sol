// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "./Utils.sol";

contract DebitCard is VaultItem{

    string name;
    string card_id;
    string name_on_card;
    uint8 expire_at;
    uint8 cvv;

    address owner;
    address parent;

    Utils.ItemType item_type = Utils.ItemType.DEBIT_CARD;

    constructor(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint8 _expire_at,
        uint8 _cvv,
        address _owner,
        address _parent
        )
    {

        name = _name;
        card_id = _card_id;
        name_on_card = _name_on_card;
        expire_at = _expire_at;
        cvv = _cvv;

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

    function setParent( address _parent) external  ownerOnly {
        parent = _parent;

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

    function setNameOnCard(string memory _name_on_card) external ownerOnly {
        name_on_card = _name_on_card;

        emit Updated(msg.sender);
    }

    function setExpireAt(uint8 _expire_at) external ownerOnly {
        expire_at = _expire_at;

        emit Updated(msg.sender);
    }

    function setCvv(uint8 _cvv) external ownerOnly {
        cvv = _cvv;

        emit Updated(msg.sender);
    }

    function setItem(string memory _name, string memory _card_id, string memory _name_on_card, uint8 _expire_at, uint8 _cvv) external ownerOnly {

        name = _name;
        card_id = _card_id;
        name_on_card = _name_on_card;
        expire_at = _expire_at;
        cvv = _cvv;

        emit Updated(msg.sender);
    }

    function expose() external view ownerOnly returns (string memory, string memory, string memory, uint8, uint8) {
        return ( name, card_id, name_on_card, expire_at, cvv );
    }


}
