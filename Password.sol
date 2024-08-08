// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";

contract Password is VaultItem{

    string name;
    string url;
    string user_name;
    string password;

    address owner;
    address parent;

    constructor(string memory _name, string memory _url, string memory _user_name, string memory _password, address _owner, address _parent){

        name = _name;
        url = _url;
        user_name = _user_name;
        password = _password;
    
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

    function setParent( address _parnet) external  ownerOnly {
        parent = _parnet;
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;
    }

    function setUrl(string memory _url) external ownerOnly {
        url = _url;
    }

    function setUserName(string memory _user_name) external ownerOnly {
        user_name = _user_name;
    }

    function setPassworde(string memory _password) external ownerOnly {
        password = _password;
    }
    

    function expose() external view ownerOnly returns ( string memory, string memory, string memory, string memory) {
        return ( name, url, user_name, password );
    }


}
