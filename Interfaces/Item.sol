// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "../Libs/Constants.sol";

interface Item{

    event Created(address);
    event Updated(address);

    function getParent() external view returns (address);

    function setName( string memory _name ) external;

}