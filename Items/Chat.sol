// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

import "./VaultItem.sol";
import "../Libs/ItemTypes.sol";

contract Chat is VaultItem{

    address guest;

    struct Message {
        uint256 timestamp;
        string text; 
        address author; 
    }

    Message[] messages;

    modifier onlyOwnerOrGuest {
        require(msg.sender == owner || msg.sender == guest, "403");
        _;
    }

    event NewMessage(address indexed sender, uint256 timestamp);

    constructor(
        string memory _name,
        address _guest,
        address _owner,
        address _parent
    ) VaultItem(
        _name,
        ItemTypes.Type.CHAT,
        _owner,
        _parent
    ){

        guest = _guest;
        
        emit Created(msg.sender);
    }
 
    function getMessages() external onlyOwnerOrGuest view returns ( Message[] memory ){
        return messages;
    }

    function sendMessage(string memory _text) external onlyOwnerOrGuest {

        messages.push(
            Message(block.timestamp, _text, msg.sender)
        );

        emit NewMessage(msg.sender, block.timestamp );
    }


    
}
