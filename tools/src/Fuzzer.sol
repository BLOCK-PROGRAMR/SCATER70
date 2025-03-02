//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Fuzzer {
    uint256 public balance;
    address public owner;

    function deposit(uint256 _amount) public payable {
        if (_amount <= 0) {
            balance = 0;
            payable(owner).transfer(balance);
        }
        balance += _amount;
    }
}
