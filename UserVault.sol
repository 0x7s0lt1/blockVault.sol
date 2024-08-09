// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./LoyalityCard.sol";
import "./DebitCard.sol";
import "./Password.sol";
import "./Payable.sol";
import "./Utils.sol";

contract UserVault is Payable{


    mapping (Utils.ItemType => address[]) Items;

    constructor(address payable _owner, address _manager) Payable( _owner, _manager) {}

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getAllItems() external view ownerOnly returns (address[][3] memory) {
        return Utils.getAllItems(Items);
    }

     function getItem(Utils.ItemType _type) external view ownerOnly returns (address[] memory) {

        require(Utils.isValidItemType(uint8(_type)), "Invalid Item type");

        return Utils.getItems(_type, Items);
    }

    function createLoyalityCard(string memory _name, string memory _card_id) external ownerOnly {

        LoyalityCard card = new LoyalityCard( _name, _card_id, owner, address(this) );

        Items[Utils.ItemType.LOYALITY_CARD].push( card.getAddress() );
        
    }

    function createDebitCard(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint16 _expire_at,
        uint16 _cvv
    ) external ownerOnly {

        DebitCard card = new DebitCard( _name, _card_id, _name_on_card, _expire_at, _cvv, owner, address(this));

        Items[Utils.ItemType.DEBIT_CARD].push( card.getAddress() );
        
    }

    function createPassword(
        string memory _name,
        string memory _url,
        string memory _user_name,
        string memory _password
    ) external ownerOnly {

        Password psw = new Password( _name, _url, _user_name, _password, owner, address(this));

        Items[Utils.ItemType.PASSWORD].push( psw.getAddress() );
        
    }

    function deleteItem(Utils.ItemType _type, address _addr) external ownerOnly {

        require(Utils.isValidItemType(uint8(_type)), "Invalid Item type");
        require(_addr != address(0), "Invalid address");

        Utils.deleteItem( Items, _type, _addr );
    }


}
