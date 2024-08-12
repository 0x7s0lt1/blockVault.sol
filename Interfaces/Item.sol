// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "../Libs/Constants.sol";

interface Item{

    event Created(address);
    event Updated(address);
    event AddedToOrganisation(address);
    event RemovedFromOrganisation(address);
    // event Deleted(address);

    function getItemType() external view returns (Constants.ItemType);

    function getParent() external view returns (address);

    function setParent( address _parent ) external;

    function setName( string memory _name ) external;

    // function addToOrganisation(address _org ) external;
    // function removeFromOrganisation(address _org) external;

    // function duplicate( address _to) external;

}