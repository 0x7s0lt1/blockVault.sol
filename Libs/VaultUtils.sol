// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "Libs/Constants.sol";


library VaultUtils{


    function getItems( uint8 _t, mapping (uint8 => address[]) storage _itms ) internal view returns (address[] memory) {

        return _itms[_t];
    }

    function deleteItem( mapping (uint8 => address[]) storage _itms, uint8 _t, address _itm ) internal {

        int i = Constants.findAddressIndex(_itm, _itms[_t]);
        require(i > -1 && i < int(_itms[_t].length), "404");

        Constants.deleteAddressFrom(i, _itms[_t]);

    }

    function addSharedItem( uint8 _t, mapping (uint8 => address[]) storage _shItms, address _shItm ) internal {

        require( Constants.findAddressIndex(_shItm, _shItms[_t]) == -1, "409");

        _shItms[_t].push( _shItm );
    }

    function deleteSharedItem( uint8 _type, mapping (uint8 => address[]) storage _shItems, address _shItem ) internal {

        int i = Constants.findAddressIndex(_shItem, _shItems[_type]);
        require(i > -1 && i < int(_shItems[_type].length), "404");

        Constants.deleteAddressFrom(i, _shItems[_type]);
    }
    

}
