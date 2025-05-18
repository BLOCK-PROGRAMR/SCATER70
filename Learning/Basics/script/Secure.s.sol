//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
import {Script, console} from "forge-std/Script.sol";
import {Passsword} from "../src/Secure.sol";

contract Secure is Script {
    Passsword public pass;

    function setUp() public {
        vm.startBroadcast();
        pass = new Passsword();
        vm.stopBroadcast();
    }

    function run() public {
        pass.setPassword("password");
        console.log(pass.verifyPassword("password"));
    }
}
