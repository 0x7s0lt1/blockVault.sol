// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;


abstract contract Payable{

    address payable owner;
    address manager;

    constructor(address payable _owner, address _manager){
        owner = _owner;
        manager = _manager;
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == manager, "Only owner");
        _;
    }

    receive() external payable { }

    fallback() external payable { }

    function deposit() external payable { }


    function getBalance() external view ownerOnly returns (uint) {
        return address(this).balance;
    }

    function withdraw( uint _amount) external payable ownerOnly {
        require(address(this).balance >= _amount, "Insufficient");

        (bool success, ) = owner.call{value: _amount}("");
        
        require(success, "Failed");

    }

    function sendTo(address payable _to, uint _amount) external payable ownerOnly {
        require(_to != address(0), "Invalid address");
        require(address(this).balance >= _amount, "Insufficient");

        (bool success, ) = _to.call{value: _amount}("");
        
        require(success, "Failed");
    }



}
