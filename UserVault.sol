// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "./LoyalityCard.sol";
import "./DebitCard.sol";

contract UserVault{

    struct Items{
        address[] loyalityCards;
        address[] debitCards;
    }

    address owner;
    address manager;

    Items items;

    constructor(address _owner, address _manager){
        owner = _owner;
        manager = _manager;
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == manager, "Only the owner or the manager can call this function");
        _;
    }
    
    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }


    function getItems() public ownerOnly view returns (Items memory) {

        return items;
    }

    function putLoyalityItem(address _item) external ownerOnly {

        require(findIndex(_item, items.loyalityCards) > -1, "Exists");
        items.loyalityCards.push(_item);
    }

    function deleteLoyalityItem(address _item) public ownerOnly{

        int index = findIndex(_item, items.loyalityCards);
        require(index > -1 && index < int(items.loyalityCards.length), "Item not found in array");

        for (uint i = uint(index); i < items.loyalityCards.length - 1; i++) {
            items.loyalityCards[i] = items.loyalityCards[i + 1];
        }

        items.loyalityCards.pop(); 

    }

    function putDebitItem(address _item) external ownerOnly {

        require(findIndex(_item, items.debitCards) > -1, "Exists");
        items.debitCards.push(_item);
    }

    function deleteDebitItem(address _item) public ownerOnly {

        int index = findIndex(_item, items.debitCards);
        require(index > -1 && index < int(items.debitCards.length), "Value not found in array");

        for (uint i = uint(index); i < items.debitCards.length - 1; i++) {
            items.debitCards[i] = items.debitCards[i + 1];
        }

        items.debitCards.pop(); 

    }

    function findIndex(address _value, address[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _value) {
                return int(i);
            }
        }
        return -1; 
    }

    function createLoyalityCard(string memory _name, string memory _card_id) external ownerOnly {

        LoyalityCard card = new LoyalityCard( _name, _card_id, owner, address(this) );

        items.loyalityCards.push( card.getAddress() );
        
    }

    function createDebitCard(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        string memory _expire_at,
        uint _cvv
    ) external ownerOnly {

        DebitCard card = new DebitCard( _name, _card_id, _name_on_card, _expire_at, _cvv, owner, address(this));

        items.debitCards.push( card.getAddress() );
        
    }



}
