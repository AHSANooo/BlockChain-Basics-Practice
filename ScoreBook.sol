// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract ScoreBook{


    uint256[] private scores;

    function addScore(uint256 a) external  {
        scores.push(a);
    }

    function getScore(uint256 i) external  view returns (uint256) {

        require(i < scores.length && i >= 0, "index invalid");
            return scores[i];
    }

    function getTotal() external view returns (uint256){

        return scores.length;

    }

}