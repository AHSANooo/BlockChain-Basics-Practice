// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";

contract Calculator {

        int256 private lastResult;

    function add (int256 a, int256 b) external returns (int256){

        lastResult = a+b;
        return lastResult;

    }

     function subtract (int256 a, int256 b) external returns (int256){

        lastResult = a-b;
        return lastResult;

    }

     function divide (int256 a, int256 b) external returns (int256){

        require(b != 0 , "Cannot divide by zero");
        lastResult = a/b;
        return lastResult;

    }

     function multiply (int256 a, int256 b) external returns (int256){
        lastResult= a*b;
        return lastResult;

    

    }

    function readLastResult() external view returns (int256){

        console.log("Hello");
        return lastResult;


    }




}

