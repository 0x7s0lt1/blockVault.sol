// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "../Libs/Constants.sol";

contract DebitCard is VaultItem{

    string card_id;
    string name_on_card;
    uint16 expire_at;
    uint16 cvv;

    constructor(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint16 _expire_at,
        uint16 _cvv,
        address _owner,
        address _parent
    ) VaultItem(
        _name,
        Constants.ItemType.DEBIT_CARD,
        _owner,
        _parent
    ){

        card_id = _card_id;
        name_on_card = _name_on_card;
        expire_at = _expire_at;
        cvv = _cvv;

        emit Created(msg.sender);
    }


    function setCardId(string memory _card_id) external ownerOnly {
        card_id = _card_id;

        emit Updated(msg.sender);
    }

    function setNameOnCard(string memory _name_on_card) external ownerOnly {
        name_on_card = _name_on_card;

        emit Updated(msg.sender);
    }

    function setExpireAt(uint16 _expire_at) external ownerOnly {
        expire_at = _expire_at;

        emit Updated(msg.sender);
    }

    function setCvv(uint16 _cvv) external ownerOnly {
        cvv = _cvv;

        emit Updated(msg.sender);
    }

    function setItem(
        string memory _n,
        string memory _c_id,
        string memory _noc,
        uint16 _e_at,
        uint16 _cvv
    ) external ownerOnly {

        name = _n;
        card_id = _c_id;
        name_on_card = _noc;
        expire_at = _e_at;
        cvv = _cvv;

        emit Updated(msg.sender);
    }

    function expose() external view ownerOrShared returns (string memory, string memory, string memory, uint16, uint16) {
        return ( name, card_id, name_on_card, expire_at, cvv );
    }


}
