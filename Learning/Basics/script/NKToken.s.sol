// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NKToken} from "../src/NKToken.sol";

contract NKTokenScript is Script {
    NKToken public nk;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        nk = new NKToken();

        vm.stopBroadcast();
    }
}
