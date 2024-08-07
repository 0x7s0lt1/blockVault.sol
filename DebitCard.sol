// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";

contract DebitCard is VaultItem{

    string name;
    string card_id;
    string name_on_card;
    string expire_at;
    uint cvv;

    address owner;
    address parent;

    constructor(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        string memory _expire_at,
        uint _cvv,
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
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;
    }

    function setCardId(string memory _card_id) external ownerOnly {
        card_id = _card_id;
    }
    
    function setParent( address _parent) external  ownerOnly {
        parent = _parent;
    }

    function getCard() external view ownerOnly returns (string memory, string memory, string memory, string memory, uint) {
        return ( name, card_id, name_on_card, expire_at, cvv);
    }


}
