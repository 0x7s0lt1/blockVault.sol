// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "Libs/Constants.sol";

library VaultUtils{


    function getItems( Constants.ItemType _type, mapping (Constants.ItemType => address[]) storage _items ) public view returns (address[] memory) {

        return _items[_type];
    }

    function getAllItems( mapping (Constants.ItemType => address[]) storage _items) public view returns (address[][3] memory) {

        return [
            _items[Constants.ItemType.LOYALITY_CARD],
            _items[Constants.ItemType.DEBIT_CARD],
            _items[Constants.ItemType.PASSWORD]
        ];
    }

    function deleteItem( mapping (Constants.ItemType => address[]) storage _items, Constants.ItemType _type, address _item ) public {

        int idx = Constants.findAddressIndex(_item, _items[_type]);
        require(idx > -1 && idx < int(_items[_type].length), "No index");

        Constants.deleteAddressFrom(idx, _items[_type]);

    }
    

}
