// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MultisigWallet} from "../src/Multisigwallet.sol";
import "../lib/forge-std/src/Test.sol";
import "../lib/forge-std/src/console.sol";

contract MultisigWalletTest is Test {
    MultisigWallet wallet;
    address[] public owners;
    address owner1 = address(0xA1);
    address owner2 = address(0xA2);
    address owner3 = address(0xA3);
    address attacker = address(0xAA);
    address recipient = address(0xB0);

    function setUp() public {
        owners[0] = owner1;
        owners[1] = owner2;
        owners[2] = owner3;

        wallet = new MultisigWallet(owners, 2);

        // Fund the wallet with 5 ether
        vm.deal(address(this), 10 ether);
        payable(address(wallet)).transfer(5 ether);
    }

    function test_Submit_Confirm_Execute_Success() public {
        bytes memory data = abi.encodeWithSignature("foo()");

        // Submit transaction
        vm.prank(owner1);
        wallet.submitTransaction(recipient, 1 ether, data);

        // Confirm from owner1 and owner2
        vm.prank(owner1);
        wallet.confirmTransaction(0);

        vm.prank(owner2);
        wallet.confirmTransaction(0);

        // Check balance before
        uint before = recipient.balance;

        // Execute transaction
        vm.prank(owner3);
        wallet.executeTransaction(0);

        uint afterBal = recipient.balance;
        assertEq(afterBal - before, 1 ether);
    }

    function test_Fail_ExecuteWithoutEnoughConfirmations() public {
        bytes memory data = "";

        vm.prank(owner1);
        wallet.submitTransaction(recipient, 1 ether, data);

        vm.prank(owner1);
        wallet.confirmTransaction(0);

        vm.expectRevert();
        vm.prank(owner2);
        wallet.executeTransaction(0);
    }

    function test_RevertOn_DoubleConfirmation() public {
        vm.prank(owner1);
        wallet.submitTransaction(recipient, 1 ether, "");

        vm.prank(owner1);
        wallet.confirmTransaction(0);

        vm.expectRevert("already confirmed");
        vm.prank(owner1);
        wallet.confirmTransaction(0);
    }

    function test_RevertOn_NonOwnerSubmit() public {
        vm.prank(attacker);
        vm.expectRevert("not owner");
        wallet.submitTransaction(recipient, 1 ether, "");
    }

    function test_RevertOn_NonOwnerConfirm() public {
        vm.prank(owner1);
        wallet.submitTransaction(recipient, 1 ether, "");

        vm.prank(attacker);
        vm.expectRevert("not owner");
        wallet.confirmTransaction(0);
    }

    function test_RevertOn_RevokeWithoutConfirmation() public {
        vm.prank(owner1);
        wallet.submitTransaction(recipient, 1 ether, "");

        vm.prank(owner2);
        vm.expectRevert("tx not confirmed");
        wallet.revokeConfirmation(0);
    }

    function test_RevokeConfirmation_WorksCorrectly() public {
        vm.prank(owner1);
        wallet.submitTransaction(recipient, 1 ether, "");

        vm.prank(owner1);
        wallet.confirmTransaction(0);

        vm.warp(block.timestamp + 31); // to bypass cooldown
        vm.prank(owner1);
        wallet.revokeConfirmation(0);
    }

    function test_Fail_RevokeConfirmation_TwiceQuickly() public {
        vm.prank(owner1);
        wallet.submitTransaction(recipient, 1 ether, "");

        vm.prank(owner1);
        wallet.confirmTransaction(0);

        vm.warp(block.timestamp + 31);
        vm.prank(owner1);
        wallet.revokeConfirmation(0);

        vm.expectRevert("Wait 30s to revoke again");
        vm.prank(owner1);
        wallet.revokeConfirmation(0);
    }

    function test_Fail_SubmitTransactionToSelf() public {
        vm.prank(owner1);
        vm.expectRevert("invalid tx");
        wallet.submitTransaction(address(wallet), 1 ether, "");
    }

    // function test_DepositEventEmitted() public {
    //     vm.expectEmit(true, true, true, true);
    //     emit MultisigWallet.Deposit(
    //         address(this),
    //         1 ether,
    //         address(wallet).balance + 1 ether,""
    //     );
    //     payable(address(wallet)).transfer(1 ether);
    // }

    receive() external payable {}
}
