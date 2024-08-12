// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "../Libs/Constants.sol";

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
        _name,
        Constants.ItemType.PASSWORD,
        _owner,
        _parent
    ){

        url = _url;
        user_name = _user_name;
        password = _password;

        emit Created(msg.sender);
    }


    function setUrl(string memory _url) external ownerOnly {
        url = _url;

        emit Updated(msg.sender);
    }

    function setUserName(string memory _user_name) external ownerOnly {
        user_name = _user_name;

        emit Updated(msg.sender);
    }

    function setPassword(string memory _password) external ownerOnly {
        password = _password;

        emit Updated(msg.sender);
    }

    function setItem(
        string memory _name,
        string memory _url,
        string memory _user_name,
        string memory _password
    ) external ownerOnly {
        name = _name;
        url = _url;
        user_name = _user_name;
        password = _password;

        emit Updated(msg.sender);
    }
    
    function expose() external view ownerOnly returns ( string memory, string memory, string memory, string memory) {
        return ( name, url, user_name, password );
    }


}
