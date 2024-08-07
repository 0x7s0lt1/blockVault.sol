// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

interface VaultItem{

    function getParent() external view returns (address);

    // function copyTo( address _to) external;

}