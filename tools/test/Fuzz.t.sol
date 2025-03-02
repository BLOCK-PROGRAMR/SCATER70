//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Test.sol";
import "../lib/forge-std/src/console.sol";
import {Fuzzer} from "../src/Fuzzer.sol";

contract Fuzz is Test {
    Fuzzer public fuzz;

    function setUp() public {
        fuzz = new Fuzzer();
    }

    function testcheckDeposit(uint256 _amount) public {
        fuzz.deposit(_amount);
        assertTrue(fuzz.balance() == 0, "Balance should be equal to amount");
    }
}
