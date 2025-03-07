// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "../lib/forge-std/src/Test.sol";
import "../lib/forge-std/src/console.sol";

import {Registry} from "../src/Registry.sol";

contract RegistryTest is Test {
    Registry registry;
    address alice;
    address nithin;

    function setUp() public {
        alice = makeAddr("alice");
        nithin = makeAddr("nithin");

        registry = new Registry();
    }

    function test_register() public {
        uint256 amountToPay = registry.PRICE(); //state variable accessing

        vm.deal(alice, amountToPay);
        vm.startPrank(alice);

        uint256 aliceBalanceBefore = address(alice).balance;
        console.log("aliceBalanceBefore", aliceBalanceBefore);

        registry.register{value: amountToPay}(); //low level call to the contract

        uint256 aliceBalanceAfter = address(alice).balance;
        console.log("aliceBalanceAfter", aliceBalanceAfter);

        assertTrue(registry.isRegistered(alice), "Did not register user");
        assertEq(
            address(registry).balance,
            registry.PRICE(),
            "Unexpected registry balance"
        );
        assertEq(
            aliceBalanceAfter,
            aliceBalanceBefore - registry.PRICE(),
            "Unexpected user balance"
        );
    }

    /** Almost the same test, but this time fuzzing amountToPay detects the bug (the Registry contract is not giving back the change) */
    function test_fuzz_register(uint256 amountToPay) public {
        vm.assume(amountToPay >= 1 ether);

        vm.deal(nithin, amountToPay);
        vm.startPrank(nithin);

        uint256 nithinBalanceBefore = address(nithin).balance;
        console.log("nithinBalanceBefore", nithinBalanceBefore);

        registry.register{value: amountToPay}();
        // I will send 4 ether, but the contract only accepts 1 ether, so it should return 3 ether
        //So, the balance of nithin should be nithinBalanceBefore - 1 ether(4  ether - 1 ether) = 3 ether

        uint256 nithinBalanceAfter = address(nithin).balance;
        console.log("nithinBalanceAfter", nithinBalanceAfter);

        assertTrue(registry.isRegistered(nithin), "Did not register user");
        assertEq(
            address(registry).balance,
            registry.PRICE(),
            "Unexpected registry balance"
        );
        assertEq(
            nithinBalanceAfter,
            nithinBalanceBefore - registry.PRICE(),
            "Unexpected user balance"
        );
    }
}
