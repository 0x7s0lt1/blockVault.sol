// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Libs/OrgUtils.sol";
import "./Libs/Constants.sol";

contract Organisation{

    string name;
    OrgUtils.Member[] members;

    mapping (Constants.ItemType => OrgUtils.Item[]) Items;

    address owner;
    address parent;

    event Created(address, address);

    constructor(string memory _name, address _owner, address _parent){

        name = _name;
    
        owner = _owner;
        parent = _parent;
        members.push( OrgUtils.Member("*", owner) );

        emit Created(msg.sender, address(this));
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only owner");
        _;
    }

    modifier memberOnly{
        require( OrgUtils.findOrgMember(msg.sender, members) > -1, "Only member");
        _;
    }

    modifier ownerOrSelfOnly(address self){
        require( msg.sender == owner || (OrgUtils.findOrgMember(msg.sender, members) > -1 && msg.sender == self ), "Only owner|self");
        _;
    }

    function isOwn() external view memberOnly returns (bool) {

        return owner == msg.sender;
    }

    function getName() external view memberOnly returns (string memory) {

        return name;
    }

    function getMembers() external view ownerOnly returns (OrgUtils.Member[] memory) {

        return members;
    }

    function addMember(string memory _name, address _addr) external ownerOnly {
        int index = OrgUtils.findOrgMember( _addr, members );

        if( index != -1 ) revert("Exists");

        members.push( OrgUtils.Member(_name, _addr) );
    
    }
    
    function removeMember(address _addr) external ownerOrSelfOnly(_addr) {
        int index = OrgUtils.findOrgMember( _addr, members );

        if( index != -1 ) revert("No index");

        members[uint(index)] = members[members.length - 1];
        members.pop();
    }

    function getItems(Constants.ItemType _type) external view memberOnly returns (address[] memory) {

        //TODO: visible creator?
        address[] memory _items;

        for (uint i = 0; i < Items[_type].length; i++){
            _items[i] = Items[_type][i].addr;
        }

        return _items;

    }

    function addItem(Constants.ItemType _type, address _addr) external memberOnly {

        int _index = OrgUtils.findOrgItem( _addr, Items[_type] );

        if( _index > -1 ) revert("Exists");

        Items[_type].push( OrgUtils.Item( _addr, msg.sender ) );

    }

    function deleteItem(Constants.ItemType _type, address _addr) external memberOnly {

        int _index = OrgUtils.findOrgItem( _addr, Items[_type] );

        if( _index < 0 ) revert("No index");
        if( Items[_type][uint(_index)].creator != msg.sender ) revert("Only creator");

        Items[_type][uint(_index)] = Items[_type][Items[_type].length - 1];
        Items[_type].pop();

    }

}
