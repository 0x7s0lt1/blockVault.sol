// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";

contract Password is VaultItem{

    string url;
    string user_name;
    string password;

    constructor(
        string memory _name,
        string memory _url,
        string memory _user_name,
        string memory _password,
        address _owner,
        address _parent
    ) VaultItem(
        2,
        _name,
        _owner,
        _parent
    ){

        url = _url;
        user_name = _user_name;
        password = _password;

        emit Created(msg.sender);
    }


    function setUrl(string memory _u) external ownerOnly {
        url = _u;

        emit Updated(msg.sender);
    }

    function setUserName(string memory _un) external ownerOnly {
        user_name = _un;

        emit Updated(msg.sender);
    }

    function setPassword(string memory _p) external ownerOnly {
        password = _p;

        emit Updated(msg.sender);
    }

    function setItem(
        string memory _n,
        string memory _u,
        string memory _un,
        string memory _p
    ) external ownerOnly {
        name = _n;
        url = _u;
        user_name = _un;
        password = _p;

        emit Updated(msg.sender);
    }
    
    function expose() external view ownerOrShared returns ( string memory, string memory, string memory, string memory) {
        return ( name, url, user_name, password );
    }


}
