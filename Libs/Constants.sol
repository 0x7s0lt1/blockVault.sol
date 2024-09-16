// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

library Constants{

    function findAddressIndex(address _addr, address[] memory _a) internal pure returns (int) {
        for (uint i = 0; i < _a.length; i++) {
            if (_a[i] == _addr) return int(i);
        }
        return -1; 
    } 

    function deleteAddressFrom(int idx, address[] storage _a) internal {
        require(idx >= 0 && uint(idx) < _a.length, "404");
        for (uint i = uint(idx); i < _a.length - 1; i++) {
            _a[i] = _a[i + 1];
        }

        _a.pop();
    }

}
