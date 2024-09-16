// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "../Libs/ItemTypes.sol";

contract TimeCapsule is VaultItem{

    string text;
    uint256 public time;

    constructor(
        string memory _name,
        string memory _text,
        uint256 _time,
        address _owner,
        address _parent
    ) VaultItem(
        _name,
        ItemTypes.Type.TIME_CAPSULE,
        _owner,
        _parent
    ){

        text = _text;
        time = _time;

        emit Created(msg.sender);
    }

    function expose() external view ownerOrShared returns (string memory) {

        require( time < block.timestamp, "425");

        return text;
    }


}
