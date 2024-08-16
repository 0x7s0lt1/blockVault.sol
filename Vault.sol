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
    

     function getItem(Constants.ItemType _type) external view ownerOnly returns (address[] memory) {
        return VaultUtils.getItems(_type, Items);
    }

    function createLoyalityCard(string memory _name, string memory _card_id) external ownerOnly {

        Items[Constants.ItemType.LOYALITY_CARD].push( address(
            (new LoyalityCard( _name, _card_id, owner, address(this) ))
        ));
        
    }

    function createDebitCard(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint16 _expire_at,
        uint16 _cvv
    ) external ownerOnly {

        Items[Constants.ItemType.DEBIT_CARD].push( address(
            (new DebitCard( _name, _card_id, _name_on_card, _expire_at, _cvv, owner, address(this)))
        ));
        
    }

    function createPassword(
        string memory _name,
        string memory _url,
        string memory _user_name,
        string memory _password
    ) external ownerOnly {

        Items[Constants.ItemType.PASSWORD].push( address(
            (new Password( _name, _url, _user_name, _password, owner, address(this)))
        ));
        
    }

    function deleteItem(Constants.ItemType _type, address _addr) external ownerOnly {

        VaultUtils.deleteItem( Items, _type, _addr );
    }

    function addSharedItem(Constants.ItemType _type, address _addr) external ownerOnly {

        VaultUtils.addSharedItem( _type, SharedItems, _addr);
    }

    function removeShareditem(Constants.ItemType _type, address _addr) external ownerOnly {

        VaultUtils.deleteSharedItem( _type, SharedItems, _addr );
    }

}
