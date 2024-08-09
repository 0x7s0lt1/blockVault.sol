// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Payable.sol";

library Utils{

    enum ItemType{ LOYALITY_CARD, DEBIT_CARD, PASSWORD }

    function isValidItemType(uint8 _type) internal pure returns (bool) {
        return _type < uint8(ItemType.PASSWORD) + 1;
    } 

    function findIndex(address _value, address[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _value) {
                return int(i);
            }
        }
        return -1; 
    }

    function getAllItems( mapping (ItemType => address[]) storage _items) public view returns (address[][3] memory) {

        return [
            _items[ItemType.LOYALITY_CARD],
            _items[ItemType.DEBIT_CARD],
            _items[ItemType.PASSWORD]
        ];
    }

    function getItems( ItemType _type, mapping (ItemType => address[]) storage _items ) public view returns (address[] memory) {

        return _items[_type];
    }

    function deleteItem( mapping (ItemType => address[]) storage _items, ItemType _type, address _item ) public {

        int index = Utils.findIndex(_item, _items[_type]);
        require(index > -1 && index < int(_items[_type].length), "Item not found in array");

        for (uint i = uint(index); i < _items[_type].length - 1; i++) {
            _items[_type][i] = _items[_type][i + 1];
        }

        _items[_type].pop();

    }

}
