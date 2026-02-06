// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";

import {TabunganBersamaImplementation} from "../src/TabunganBersamaImplementation.sol";
import {ERC1967Proxy} from "@openzeppelin-contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {MockWETH} from "../src/MockWETH.sol";
import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";

contract TabunganBersamaUpgradeableScript is Script {
    TabunganBersamaImplementation public tabunganBersamaImplementation;
    TabunganBersamaImplementation public tabunganBersamaProxy;
    ERC1967Proxy public proxy;

    address mockWeth = 0xaA3C334FE819Ff64d0DA96A278207CaDe41C4F0F;
    address user = 0x706723D538C979507a386096F5246dE8E7A8A42C;

    uint256 public privateKey = vm.envUint("BASE_SEPOLIA_PRIVATE_KEY");

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
        tabunganBersamaProxy = TabunganBersamaImplementation(0x0B79989c29500e93D0Cf140460C1Be804c1e03EE);

        // _mint();
        // _deposit();
        // _upgrade();
        // _deposit();
        // _upgrade();
        _deposit();
    }

    function run() public {}

    function _deployTabungan() internal {
        vm.startBroadcast(privateKey);
        tabunganBersamaImplementation = new TabunganBersamaImplementation();
        console.log("tabunganBersamaImplementation = ", address(tabunganBersamaImplementation));
        bytes memory data = abi.encodeWithSelector(TabunganBersamaImplementation.initialize.selector, mockWeth);
        proxy = new ERC1967Proxy(address(tabunganBersamaImplementation), data);
        console.log("proxy = ", address(proxy));
        vm.stopBroadcast();
    }

    function _mint() internal {
        vm.startBroadcast(privateKey);
        MockWETH(mockWeth).mint(user, 100e18);
        vm.stopBroadcast();
    }

    function _deposit() internal {
        vm.startBroadcast(privateKey);
        console.log("tabunganBersamaProxy = ", address(tabunganBersamaProxy));
        IERC20(mockWeth).approve(address(tabunganBersamaProxy), 1e18);
        tabunganBersamaProxy.deposit(1e18);
        vm.stopBroadcast();
    }

    function _upgrade() internal {
        vm.startBroadcast(privateKey);
        tabunganBersamaImplementation = new TabunganBersamaImplementation();
        console.log("tabunganBersamaImplementation = ", address(tabunganBersamaImplementation));

        tabunganBersamaProxy.upgradeToAndCall(address(tabunganBersamaImplementation), "");
        console.log("tabunganBersamaProxy = ", address(tabunganBersamaProxy));
        vm.stopBroadcast();
    }
}

//   tabunganBersamaImplementation =  0x57Ff5341AB71E148652c57483BAE40f099173d67 // V1
//   tabunganBersamaImplementation =  0x2771aB87D0c257a99a203880b76dC08CE51978c3 // V2
//   tabunganBersamaImplementation =  0x92D055f99B9F3B9C723a68106609018C3AfB9AA9 // V3 RUSAK, harusnya sih
//   proxy =  0x0B79989c29500e93D0Cf140460C1Be804c1e03EE

// RUN
// forge script TabunganBersamaUpgradeableScript --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY
// forge script TabunganBersamaUpgradeableScript --broadcast
// forge script TabunganBersamaUpgradeableScript -vvv
