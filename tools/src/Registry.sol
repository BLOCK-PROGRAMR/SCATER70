//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Registry {
    error PaymentNotEnough(uint256 expected, uint256 actual);

    uint256 public constant PRICE = 1 ether;

    mapping(address account => bool registered) private registry;

    function register() external payable {
        if (msg.value < PRICE) {
            revert PaymentNotEnough(PRICE, msg.value);
        }

        registry[msg.sender] = true;
        if (msg.value > PRICE) {
            payable(msg.sender).transfer(msg.value - PRICE);
        }
    }

    function isRegistered(address account) external view returns (bool) {
        return registry[account];
    }
}
