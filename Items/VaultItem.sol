// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "../Interfaces/Item.sol";
import "../Libs/Constants.sol";

abstract contract VaultItem is Item{

    string name;
    Constants.ItemType item_type;

    address owner;
    address parent;


    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only owner");
        _;
    }

    constructor(
        string memory _name,
        Constants.ItemType _item_type,
        address _owner,
        address _parent
    ){
        name = _name;
        item_type = _item_type;

        owner = _owner;
        parent = _parent;
    }

    function getItemType() external view ownerOnly returns (Constants.ItemType) {
        return item_type;
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




}
