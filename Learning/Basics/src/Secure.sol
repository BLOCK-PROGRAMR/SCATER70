//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Passsword {
    bytes32 public passwordHash;

    function setPassword(string memory _password) public {
        passwordHash = keccak256(abi.encodePacked(_password));
    }

    function verifyPassword(
        string memory _password
    ) public view returns (bool) {
        return keccak256(abi.encodePacked(_password)) == passwordHash;
    }
}
