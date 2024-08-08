// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;


library Utils{

    enum ItemType{ LOYALITY_CARD, DEBIT_CARD, PASSWORD }

    function findIndex(address _value, address[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _value) {
                return int(i);
            }
        }
        return -1; 
    }

}
