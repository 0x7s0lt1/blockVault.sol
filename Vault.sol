// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./Items/LoyalityCard.sol";
import "./Items/DebitCard.sol";
import "./Items/Password.sol";
import "./Items/Chat.sol";
import "./Items/TimeCapsule.sol";
import "./Libs/ItemTypes.sol";
import "./Libs/VaultUtils.sol";
import "./Payable.sol";

contract Vault is Payable{

    mapping (ItemTypes.Type => address[]) Items;
    mapping (ItemTypes.Type => address[]) SharedItems;
    
    constructor(address payable _owner, address _manager) Payable( _owner, _manager) {}
    

    function getItem(ItemTypes.Type _t) external view ownerOnly returns (address[] memory) {
        return VaultUtils.getItems(_t, Items);
    }

    function deleteItem(ItemTypes.Type _t, address _a) external ownerOnly {

        VaultUtils.deleteItem( Items, _t, _a );
    }

    function createLoyalityCard(string memory _n, string memory _crd_id) external ownerOnly {

        Items[ItemTypes.Type.LOYALITY_CARD].push( address(
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

        Items[ItemTypes.Type.DEBIT_CARD].push( address(
            (new DebitCard( _n, _crd_id, _noc, _e_at, _cvv, owner, address(this)))
        ));
        
    }

    function createPassword(
        string memory _n,
        string memory _u,
        string memory _un,
        string memory _p
    ) external ownerOnly {

        Items[ItemTypes.Type.PASSWORD].push( address(
            (new Password( _n, _u, _un, _p, owner, address(this)))
        ));
        
    }

    function createChat(
        string memory _n,
        address _g
    ) external ownerOnly {
        Items[ItemTypes.Type.CHAT].push( address(
            (new Chat( _n, _g, owner, address(this)))
        ));
    }

    function createTimeCapsule(
        string memory _n,
        string memory _te,
        uint256 _t
    ) external ownerOnly {
        Items[ItemTypes.Type.TIME_CAPSULE].push( address(
            (new TimeCapsule( _n, _te, _t, owner, address(this)))
        ));
    }


    function getSharedItems(ItemTypes.Type _t) external view ownerOnly returns (address[] memory) {
        
        return VaultUtils.getItems(_t, SharedItems);
    }

    function addSharedItem(ItemTypes.Type _t, address _a) external ownerOnly {

        VaultUtils.addSharedItem( _t, SharedItems, _a);
    }

    function removeShareditem(ItemTypes.Type _t, address _a) external ownerOnly {

        VaultUtils.deleteSharedItem( _t, SharedItems, _a );
    }
    

}
