// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";

contract LoyalityCard is VaultItem{

    string name;
    string card_id;
    address card_addr;

    address owner;
    address parent;

    constructor(string memory _name, string memory _card_id, address _owner, address _parent){

        name = _name;
        card_id = _card_id;
        card_addr = address(this);
        owner = _owner;
        parent = _parent;
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getAddress() external view ownerOnly returns (address) {

        return card_addr;
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
    
    function setParent( address _parnet) external  ownerOnly {
        parent = _parnet;
    }


}
