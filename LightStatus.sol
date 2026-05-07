// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract LightStatus{

    string private lightStatus = "empty";

    function turnOnLight() public {

        lightStatus= "Light is ON";

    }

    function getLightStatus() public view returns (string memory) { 
        //there could be a better method for this as we haven't learned about the returns in the class for solidity. 
    return lightStatus;
}

}