// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

// RUN
// forge test -vvv
// forge test --match-contract TokenTest
contract TokenTest is Test {
    Token public token;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        // console.log("before");
        // console.log("token = ", address(token));
        token = new Token();

        // console.log("after");
        // console.log("token = ", address(token));

        // console.log("alice = ", alice);
        // console.log("bob = ", bob);
    }

    // RUN
    // forge test --match-test testName
    function testName() public view {
        // console.log("token.name()", token.name());
        assertEq(token.name(), "BAHLIL MENTERI");
    }

    function testSymbol() public view {
        assertEq(token.symbol(), "BAHLIL");
    }

    function testDecimals() public view {
        assertEq(token.decimals(), 19);
    }

    function testMint() public {
        token.mint(alice, 1e19);
        assertEq(token.balanceOf(alice), 1e19);
    }

    function testBurn() public {
        token.mint(alice, 1e19);
        token.burn(alice, 1e19);
        assertEq(token.balanceOf(alice), 0);
    }

    function testTransfer() public {
        // alice punya duit 1000 $Bahlil
        // bob gapunya duit, 0 $Bahlil

        // alice transfer 500 $bahlil

        token.mint(alice, 1000e19);
        console.log("====== before");
        console.log("Alice Balance = ", token.balanceOf(alice));
        console.log("Bob Balance = ", token.balanceOf(bob));

        vm.startPrank(alice);
        bool success = token.transfer(bob, 500e19);
        assertEq(success, true);
        vm.stopPrank();

        console.log("====== after");
        console.log("Alice Balance = ", token.balanceOf(alice));
        console.log("Bob Balance = ", token.balanceOf(bob));
    }

    // RUN
    // forge test --match-test testMint_error
    function testMint_error() public {
        token.mint(alice, 1_000e19);
    }
}
