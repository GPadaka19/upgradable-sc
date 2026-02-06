// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {TabunganBersamaImplementation} from "../src/TabunganBersamaImplementation.sol";
import {ERC1967Proxy} from "@openzeppelin-contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {MockWETH} from "../src/MockWETH.sol";
import {IChainLink} from "../src/interfaces/IChainLink.sol";

// RUN
// forge test --match-contract TabunganBersamaImplementationTest
contract TabunganBersamaImplementationTest is Test {
    TabunganBersamaImplementation public tabunganBersamaImplementation;
    TabunganBersamaImplementation public tabunganBersamaProxy;
    ERC1967Proxy public proxy;
    MockWETH public mockWeth;

    address public pricefeedEth = 0x71041dddad3595F9CEd3DcCFBe3D1F4b0a16Bb70; // ETH/USD
    address public pricefeedUsdc = 0x7e860098F58bBFC8648a4311b374B1D669a2bc6B; // USDC/USD

    address public deployer = makeAddr("deployer");
    address public pepeng = makeAddr("pepeng");

    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("base_mainnet"));
        // deal(token, deployer, 100_000_000_000e2);
        // deal(token, alice, 1_000_000e2);
        // deal(token, bob, 9_000_000e2);

        vm.startPrank(deployer);

        mockWeth = new MockWETH();

        tabunganBersamaImplementation = new TabunganBersamaImplementation();
        console.log("tabunganBersamaImplementation address:", address(tabunganBersamaImplementation));
        bytes memory data = abi.encodeWithSelector(TabunganBersamaImplementation.initialize.selector, address(mockWeth));
        proxy = new ERC1967Proxy(address(tabunganBersamaImplementation), data);
        console.log("proxy address:", address(proxy));
        tabunganBersamaProxy = TabunganBersamaImplementation(address(proxy));
        console.log("tabunganBersamaProxy address:", address(tabunganBersamaProxy));

        mockWeth.mint(alice, 10e18);
        mockWeth.mint(bob, 20e18);
        mockWeth.mint(deployer, 20e18);

        vm.stopPrank();
    }

    // RUN
    // forge test --match-contract TabunganBersamaImplementationTest --match-test testCheckBalance -vvv
    function testCheckBalance() public {
        // uint256 tokenBalanceBefore = IERC20(token).balanceOf(deployer);
        // console.log("deployer balance: ", tokenBalanceBefore);
        // simulasi bahwa deployer seolah2 punya idrx sebanyak (amount)
        // deal(token, deployer, 100_000_000_000e2);
        // uint256 tokenBalanceAfter = IERC20(token).balanceOf(deployer);
        // console.log("deployer balance: ", tokenBalanceAfter);

        // console.log("==================");

        // console.log("balance deployer before", IERC20(token).balanceOf(deployer));
        // console.log("balance pepeng before", IERC20(token).balanceOf(pepeng));

        // vm.startPrank(deployer);
        // uint256 amountToTransfer = 19_000_000e2;
        // IERC20(token).approve(pepeng, amountToTransfer);
        // IERC20(token).transfer(pepeng, amountToTransfer);
        // vm.stopPrank();

        // console.log("balance deployer after", IERC20(token).balanceOf(deployer));
        // console.log("balance pepeng after", IERC20(token).balanceOf(pepeng));
    }

    // RUN
    // forge test --match-contract TabunganBersamaImplementationTest --match-test testDeposit -vvv
    function testDeposit() public {
        // vm.startPrank(deployer);
        // uint256 amountToTransfer = 19_000_000e2;

        // IERC20(token).approve(address(tabunganBersama), amountToTransfer);
        // tabunganBersama.deposit(amountToTransfer);
        // vm.stopPrank();

        // console.log("tabunganBersama.totalSupplyShares():", tabunganBersama.totalSupplyShares());
        // console.log("tabunganBersama.totalSupplyAssets():", tabunganBersama.totalSupplyAssets());
        // console.log("tabunganBersama.userSupplyShares(deployer):", tabunganBersama.userSupplyShares(deployer));

        // assertEq(tabunganBersama.totalSupplyAssets(), amountToTransfer);

        uint256 amountToTransfer = 1e18;

        vm.startPrank(alice);
        IERC20(address(mockWeth)).approve(address(tabunganBersamaProxy), amountToTransfer);
        tabunganBersamaProxy.deposit(amountToTransfer);
        vm.stopPrank();

        vm.startPrank(bob);
        IERC20(address(mockWeth)).approve(address(tabunganBersamaProxy), amountToTransfer);
        tabunganBersamaProxy.deposit(amountToTransfer);
        vm.stopPrank();

        console.log("tabunganBersamaProxy.totalSupplyShares():", tabunganBersamaProxy.totalSupplyShares());
        console.log("tabunganBersamaProxy.totalSupplyAssets():", tabunganBersamaProxy.totalSupplyAssets());

        console.log("tabunganBersamaProxy.userSupplyShares(alice):", tabunganBersamaProxy.userSupplyShares(alice));
        console.log("tabunganBersamaProxy.userSupplyShares(bob):", tabunganBersamaProxy.userSupplyShares(bob));
    }

    // RUN
    // forge test --match-contract TabunganBersamaTest --match-test testWithdraw -vvv
    function testWithdraw() public {
        // uint256 amountToTransfer = 1e18;

        // vm.startPrank(alice);
        // IERC20(address(mockWeth)).approve(address(tabunganBersama), amountToTransfer);
        // tabunganBersama.deposit(amountToTransfer);
        // vm.stopPrank();

        // vm.startPrank(bob);
        // IERC20(address(mockWeth)).approve(address(tabunganBersama), amountToTransfer);
        // tabunganBersama.deposit(amountToTransfer);
        // vm.stopPrank();

        // vm.startPrank(alice);
        // tabunganBersama.withdraw(amountToTransfer / 2);
        // vm.stopPrank();

        // console.log("tabunganBersama.totalSupplyShares():", tabunganBersama.totalSupplyShares());
        // console.log("tabunganBersama.totalSupplyAssets():", tabunganBersama.totalSupplyAssets());

        // console.log("tabunganBersama.userSupplyShares(alice):", tabunganBersama.userSupplyShares(alice));
        // console.log("tabunganBersama.userSupplyShares(bob):", tabunganBersama.userSupplyShares(bob));
    }

    // RUN
    // forge test --match-contract TabunganBersamaTest --match-test testDistributeYieldWithWithdraw -vvv
    function testDistributeYieldWithWithdraw() public {
        // uint256 amountToTransfer1 = 1e18;
        // uint256 amountToTransfer2 = 2e18;

        // uint256 amountToDistribute = 2e18;

        // vm.startPrank(alice);
        // IERC20(address(mockWeth)).approve(address(tabunganBersama), amountToTransfer1);
        // tabunganBersama.deposit(amountToTransfer1);
        // vm.stopPrank();

        // vm.startPrank(bob);
        // IERC20(address(mockWeth)).approve(address(tabunganBersama), amountToTransfer2);
        // tabunganBersama.deposit(amountToTransfer2);
        // vm.stopPrank();

        // vm.startPrank(deployer);
        // IERC20(address(mockWeth)).approve(address(tabunganBersama), amountToDistribute);
        // tabunganBersama.distributeYield(amountToDistribute);
        // vm.stopPrank();

        // console.log("alice balance before:", IERC20(address(mockWeth)).balanceOf(alice));

        // uint256 balanceBefore = IERC20(address(mockWeth)).balanceOf(alice);

        // vm.startPrank(alice);
        // tabunganBersama.withdraw(amountToTransfer1);
        // vm.stopPrank();

        // console.log("alice dapat berapa?");

        // console.log("alice balance after:", IERC20(address(mockWeth)).balanceOf(alice));
        // uint256 balanceAfter = IERC20(address(mockWeth)).balanceOf(alice);

        // uint256 yield = balanceAfter - balanceBefore;
        // console.log("yield WETH:", yield);
        // // 1.666666666666666666
        // (, int256 priceEth,,,) = IChainLink(pricefeedEth).latestRoundData();
        // (, int256 priceUsdc,,,) = IChainLink(pricefeedUsdc).latestRoundData();

        // console.log("priceEth:", priceEth); // 1 ETH = 2952.92642389 USD
        // console.log("priceUsdc:", priceUsdc); // 1 USDC = 0.99961385 USD
        // // uint256 realPrice = ((yield * uint256(priceEth) * 1e6 / uint256(priceUsdc)) / 1e8) / 1e18;
        // // console.log("realPrice:", realPrice);

        // // forge-lint: disable-next-line(unsafe-typecast)
        // uint256 ethToUsd = yield * uint256(priceEth) / 1e18;
        // console.log("yield * priceEth:", ethToUsd); // 4921.54403981 USD
        // // forge-lint: disable-next-line(unsafe-typecast)
        // uint256 ethToUsdc = ethToUsd * 1e6 / uint256(priceUsdc);
        // console.log("yield * priceEth * priceUsdc:", ethToUsdc); // 4923.445228 USDC
    }
}
