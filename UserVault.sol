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

    function createLoyalityCard(string memory _name, string memory _card_id) external ownerOnly {

        LoyalityCard card = new LoyalityCard( _name, _card_id, owner, address(this) );

        Items[Utils.ItemType.LOYALITY_CARD].push( card.getAddress() );
        
    }

    function createDebitCard(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        string memory _expire_at,
        uint _cvv
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


}
