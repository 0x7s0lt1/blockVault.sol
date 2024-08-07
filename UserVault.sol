// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "./LoyalityCard.sol";

contract UserVault{

    address owner;
    address[] items;
    address vault_addr;

    constructor(){
        owner = msg.sender;
        vault_addr = address(this);
    }

    modifier ownerOnly{
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }


    function getItems() public ownerOnly view returns (address[] memory) 
    {
        return items;
    }

    function putItem(address _item) external ownerOnly
    {
        require(findIndex(_item) > -1, "Exists");
        items.push(_item);
    }

    function deleteItem(address _item) public ownerOnly{

        int index = findIndex(_item);
        require(index > -1 && index < int(items.length), "Value not found in array");

        for (uint i = uint(index); i < items.length - 1; i++) {
            items[i] = items[i + 1];
        }

        items.pop(); 

    }

    function findIndex(address value) internal view returns (int) {
        for (uint i = 0; i < items.length; i++) {
            if (items[i] == value) {
                return int(i);
            }
        }
        return -1; 
    }

    function createLoyalityCard(string memory _name, string memory _card_id) external ownerOnly {

        LoyalityCard card = new LoyalityCard( _name, _card_id, owner, vault_addr);

        items.push( card.getAddress() );
        
    }



}
