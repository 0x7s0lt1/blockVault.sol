// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Items/LoyalityCard.sol";
import "./Items/DebitCard.sol";
import "./Items/Password.sol";
import "./Libs/Constants.sol";
import "./Libs/VaultUtils.sol";
import "./Payable.sol";

contract Vault is Payable{


    mapping (Constants.ItemType => address[]) Items;
    mapping (Constants.ItemType => address[]) SharedItems;
    
    constructor(address payable _owner, address _manager) Payable( _owner, _manager) {}
    

     function getItem(Constants.ItemType _t) external view ownerOnly returns (address[] memory) {
        return VaultUtils.getItems(_t, Items);
    }

    function createLoyalityCard(string memory _n, string memory _crd_id) external ownerOnly {

        Items[Constants.ItemType.LOYALITY_CARD].push( address(
            (new LoyalityCard( _n, _crd_id, owner, address(this) ))
        ));
        
    }

    function createDebitCard(
        string memory _n,
        string memory _crd_id,
        string memory _noc,
        uint16 _e_at,
        uint16 _cvv
    ) external ownerOnly {

        Items[Constants.ItemType.DEBIT_CARD].push( address(
            (new DebitCard( _n, _crd_id, _noc, _e_at, _cvv, owner, address(this)))
        ));
        
    }

    function createPassword(
        string memory _n,
        string memory _u,
        string memory _un,
        string memory _p
    ) external ownerOnly {

        Items[Constants.ItemType.PASSWORD].push( address(
            (new Password( _n, _u, _un, _p, owner, address(this)))
        ));
        
    }

    function deleteItem(Constants.ItemType _t, address _a) external ownerOnly {

        VaultUtils.deleteItem( Items, _t, _a );
    }

    function addSharedItem(Constants.ItemType _t, address _a) external ownerOnly {

        VaultUtils.addSharedItem( _t, SharedItems, _a);
    }

    function removeShareditem(Constants.ItemType _t, address _a) external ownerOnly {

        VaultUtils.deleteSharedItem( _t, SharedItems, _a );
    }

}
