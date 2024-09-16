// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "Libs/Constants.sol";
import "Libs/ItemTypes.sol";


library VaultUtils{


    function getItems( ItemTypes.Type _t, mapping (ItemTypes.Type => address[]) storage _itms ) internal view returns (address[] memory) {

        return _itms[_t];
    }

    function deleteItem( mapping (ItemTypes.Type => address[]) storage _itms, ItemTypes.Type _t, address _itm ) internal {

        int i = Constants.findAddressIndex(_itm, _itms[_t]);
        require(i > -1 && i < int(_itms[_t].length), "No index");

        Constants.deleteAddressFrom(i, _itms[_t]);

    }

    function addSharedItem( ItemTypes.Type _t, mapping (ItemTypes.Type => address[]) storage _shItms, address _shItm ) internal {

        require( Constants.findAddressIndex(_shItm, _shItms[_t]) == -1, "Exist");

        _shItms[_t].push( _shItm );
    }

    function deleteSharedItem( ItemTypes.Type _type, mapping (ItemTypes.Type => address[]) storage _shItems, address _shItem ) internal {

        int i = Constants.findAddressIndex(_shItem, _shItems[_type]);
        require(i > -1 && i < int(_shItems[_type].length), "No idx");

        Constants.deleteAddressFrom(i, _shItems[_type]);
    }
    

}
