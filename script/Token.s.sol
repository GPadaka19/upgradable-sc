// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";

import {Token} from "../src/Token.sol";

contract TokenScript is Script {
    Token public token;

    uint256 public privateKey = vm.envUint("BASE_SEPOLIA_PRIVATE_KEY");

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    function run() public {
        vm.startBroadcast(privateKey);
        token = new Token();
        console.log("token = ", address(token));
        vm.stopBroadcast();
    }
}

// RUN
// forge script TokenScript --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY
// forge script TokenScript --broadcast -vvv

// DRY RUN
// forge script TokenScript -vvv

