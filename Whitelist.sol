// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Whitelist {

    address public immutable owner;

    address[] public  allowed; 
    constructor (){
        owner = msg.sender;
    }


    function addAddress (address user) external {

        require(owner == msg.sender, "Not owner");
        require(user != address(0), "Zero Address");
        allowed.push(user);

    }

    function getAddress (uint256 i) external view returns (address){

        require(i< allowed.length, "Invalid Index");
        return allowed[i];

    }

    function totalAddresses () external view returns (uint256){
        return allowed.length;
    }



}