// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "Libs/Constants.sol";

library OrgUtils{

    struct Member {
        string name;
        address addr;
    }

    struct Item {
        address addr;
        address creator;
    }

    function isValidItemType(uint8 _type) internal pure returns (bool) {
        return _type < uint8(Constants.ItemType.PASSWORD) + 1;
    } 

    function findIndex(address _value, address[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _value) return int(i);
        }
        return -1; 
    }

    function findOrgMember(address _value, Member[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i].addr == _value) return int(i);
        }
        return -1; 
    }

    function findOrgItem(address _value, Item[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i].addr == _value) return int(i);
        }
        return -1; 
    }
    

}
