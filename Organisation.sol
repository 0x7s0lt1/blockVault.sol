// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Utils.sol";

contract Organisation{

    string name;
    Utils.OrgMember[] members;

    mapping (Utils.ItemType => address[]) Items;

    address owner;
    address parent;

    event Created(address, address);

    constructor(string memory _name, address _owner, address _parent){

        name = _name;
    
        owner = _owner;
        parent = _parent;
        members.push( Utils.OrgMember("*", owner) );

        emit Created(msg.sender, address(this));
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    modifier memberOnly{
        require( Utils.findOrgMember(msg.sender, members) > -1, "Only a member can call this function");
        _;
    }

    modifier ownerOrSelfOnly(address self){
        require( msg.sender == owner || (Utils.findOrgMember(msg.sender, members) > -1 && msg.sender == self ), "Only owner or self can call this function");
        _;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function isOwn() external view ownerOnly returns (bool) {

        return owner == msg.sender;
    }

    function getName() external view memberOnly returns (string memory) {

        return name;
    }

    function getMembers() external view ownerOnly returns (Utils.OrgMember[] memory) {

        return members;
    }

    function addMember(string memory _name, address _addr) external ownerOnly {
        int index = Utils.findOrgMember( _addr, members );

        if( index != -1 ) revert("Member already exists");

        members.push( Utils.OrgMember(_name, _addr) );
    
    }
    
    function removeMember(address _addr) external ownerOrSelfOnly(_addr) {
        int index = Utils.findOrgMember( _addr, members );

        if( index != -1 ) revert("Member doesn't exists");

        members[uint(index)] = members[members.length - 1];
        members.pop();
    }

    function getItems(Utils.ItemType _type, address _addr) external memberOnly {

        int index = Utils.findItem()

    }

    function addItem(Utils.ItemType _type, address _addr) external memberOnly {

        int index = Utils.findItem()

    }








}
