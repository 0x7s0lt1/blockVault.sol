// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;


library ItemTypes{

    enum Type{ 

        LOYALITY_CARD,
        DEBIT_CARD,
        PASSWORD,
        CHAT,
        TIME_CAPSULE
        
    }

    function isValidItemType(uint8 _t) internal pure returns (bool) {
        return _t < uint8(Type.TIME_CAPSULE) + 1;
    }

}