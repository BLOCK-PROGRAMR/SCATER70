// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/NFT.sol"; // Import your NFT contract

contract DeployNFT is Script {
    function run() external {
        vm.startBroadcast(); // Start broadcasting transactions using your private key

        MyNFT nft = new MyNFT(); // Deploy the contract

        vm.stopBroadcast();

        console.log("NFT Contract Address:", address(nft)); // Print the deployed address
    }
}
