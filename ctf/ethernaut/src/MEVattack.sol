// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract FrontRan {
    error BadWithdraw();

    bytes32 public s_secretHash;

    event success();
    event fail();

    constructor(bytes32 secretHash) payable {
        s_secretHash = secretHash;
    }

    function withdraw(string memory password) external payable {
        if (keccak256(abi.encodePacked(password)) == s_secretHash) {
            require(address(this).balance > 0, "No balance");
            (bool sent, ) = msg.sender.call{value: address(this).balance}("");
            if (!sent) {
                revert BadWithdraw();
            }
            emit success();
        } else {
            emit fail();
        }
    }

    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}

///prevent of this attack

contract SecureWithdraw {
    error BadWithdraw();
    error NotCommitted();

    bytes32 public s_secretHash;
    mapping(address => bool) public hasCommitted;

    event Success();
    event Fail();

    constructor(bytes32 secretHash) payable {
        s_secretHash = secretHash;
    }

    function commit() external {
        hasCommitted[msg.sender] = true;
    }

    function withdraw(string memory password) external payable {
        if (!hasCommitted[msg.sender]) revert NotCommitted();

        if (keccak256(abi.encodePacked(password)) == s_secretHash) {
            hasCommitted[msg.sender] = false; // Prevent replay attack
            (bool sent, ) = msg.sender.call{value: address(this).balance}("");
            if (!sent) {
                revert BadWithdraw();
            }
            emit Success();
        } else {
            emit Fail();
        }
    }

    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}
