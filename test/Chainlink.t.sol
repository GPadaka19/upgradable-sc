// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {IChainLink} from "../src/interfaces/IChainLink.sol";

// forge test --match-contract ChainlinkTest
contract ChainlinkTest is Test {
    function setUp() public {
        // vm.createSelectFork(vm.rpcUrl("base_sepolia"));
        vm.createSelectFork(vm.rpcUrl("base_mainnet"));
    }

    // RUN
    // forge test --match-contract ChainlinkTest --match-test testChainId -vvv
    function testChainId() public view {
        console.log("chainid: ", block.chainid);
    }

    // RUN
    // forge test --match-contract ChainlinkTest --match-test testChainlinkPricefeed -vvv
    function testChainlinkPricefeed() public view {
        // TESTNET
        // address pricefeed = 0x0FB99723Aee6f420beAD13e6bBB79b7E6F034298; // BTC/USD
        // address pricefeed = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1; // ETH/USD

        // MAINNET
        address pricefeed = 0xB48ac6409C0c3718b956089b0fFE295A10ACDdad; // PEPE/USD

        (uint80 roundId, int256 price, uint256 startedAt, uint256 updatedAt, uint256 answeredInRound) =
            IChainLink(pricefeed).latestRoundData();

        console.log("roundId:", roundId);
        console.log("price:", price);
        console.log("startedAt:", startedAt);
        console.log("updatedAt:", updatedAt);
        console.log("answeredInRound:", answeredInRound);
        //0.00000510
    }
}
