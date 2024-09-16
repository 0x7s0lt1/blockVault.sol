// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "../Interfaces/Item.sol";
import "../Libs/Constants.sol";

abstract contract VaultItem is Item{

    string name;
    uint public item_type;

    address owner;
    address parent;
    address[] sharedWith;


    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "403");
        _;
    }
    modifier ownerOrShared{
        require( msg.sender == owner || Constants.findAddressIndex( msg.sender, sharedWith ) != -1, "403");
        _;
    }

    constructor(
        uint _itm_typ,
        string memory _n,
        address _o,
        address _p
    ){
    
        item_type = _itm_typ;
        name = _n;

        owner = _o;
        parent = _p;
    }

    function isOwn() external view  returns (bool) {
        return msg.sender == owner || msg.sender == parent;
    }

    function setName(string memory _n) external ownerOnly {
        name = _n;

        emit Updated(msg.sender);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function isSharedWith() external view returns (bool) {
        return Constants.findAddressIndex( msg.sender, sharedWith ) != -1;
    }

    function getSharedWith() external view ownerOnly returns (address[] memory) {
    
        return sharedWith;
    }

    function shareWith(address _w) external ownerOnly {

        require( _w != owner && _w != address(0) && Constants.findAddressIndex( _w, sharedWith ) == -1, "403");

        sharedWith.push(_w);

    }

    function restictFrom( address _f ) external {
        
        require(_f != address(0) || ( msg.sender == parent || msg.sender == owner || msg.sender == _f ), "403");

        int _idx = Constants.findAddressIndex( _f, sharedWith );

        require(_idx > -1, "404");

        Constants.deleteAddressFrom( _idx, sharedWith );

    }



}
