// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Utils.sol";

interface VaultItem{

    event Created(address);
    event Updated(address);
    // event Deleted(address);

    function getItemType() external view returns (Utils.ItemType);

    function getParent() external view returns (address);

    function setParent( address _parent ) external;

    function getAddress() external view returns (address); 

    function setName( string memory _name ) external;

    // function duplicate( address _to) external;

}