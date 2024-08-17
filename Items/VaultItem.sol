// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "../Interfaces/Item.sol";
import "../Libs/Constants.sol";

abstract contract VaultItem is Item{

    string name;
    Constants.ItemType item_type;

    address owner;
    address parent;
    address[] sharedWith;


    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only owner");
        _;
    }
    modifier ownerOrShared{
        require( msg.sender == owner || Constants.findAddressIndex( msg.sender, sharedWith ) != -1, "Restrict");
        _;
    }

    constructor(
        string memory _n,
        Constants.ItemType _item_type,
        address _o,
        address _p
    ){
        name = _n;
        item_type = _item_type;

        owner = _o;
        parent = _p;
    }

    function getItemType() external view ownerOnly returns (Constants.ItemType) {
        return item_type;
    }

    function setName(string memory _n) external ownerOnly {
        name = _n;

        emit Updated(msg.sender);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setParent( address _p) external  ownerOnly {
        parent = _p;

        emit Updated(msg.sender);
    }

    function getSharedWith() external view returns (address[] memory) {
    
        require( msg.sender == owner || Constants.findAddressIndex( msg.sender, sharedWith ) == -1, "Restrict");

        return sharedWith;
    }

    function shareWith(address _w) external ownerOnly {

        require( _w != owner && _w != address(0) && Constants.findAddressIndex( _w, sharedWith ) == -1, "Restrict");

        sharedWith.push(_w);

    }

    function restictFrom( address _f ) external {
        
        require(_f != address(0) || ( msg.sender == parent || msg.sender == owner || msg.sender == _f ), "Restrict");

        int _idx = Constants.findAddressIndex( _f, sharedWith );

        require(_idx > -1, "Not found");

        Constants.deleteAddressFrom( _idx, sharedWith );

    }



}
