// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuardTransient} from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import {OwnableUpgradeable} from "@openzeppelin-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ContextUpgradeable} from "@openzeppelin-upgradeable/utils/ContextUpgradeable.sol";

contract TabunganBersamaImplementation is
    Initializable,
    ContextUpgradeable,
    OwnableUpgradeable,
    ReentrancyGuardTransient,
    UUPSUpgradeable
{
    using SafeERC20 for IERC20;

    error AmountIsZero();
    error InsufficientBalance();

    address public token;

    mapping(address => uint256) public userSupplyShares;
    uint256 public totalSupplyAssets;

    constructor() {
        _disableInitializers();
    }
    uint256 public totalSupplyShares;

    function initialize(address _token) public initializer {
        token = _token;

        __Context_init();
        __Ownable_init(_msgSender());
    }

    function deposit(uint256 _amount) public nonReentrant {
        if (_amount == 0) revert AmountIsZero();
        if (_amount <= 1e18) revert InsufficientBalance();

        uint256 shares = 0;

        if (totalSupplyShares == 0) {
            shares = _amount;
        } else {
            shares = _amount * totalSupplyShares / totalSupplyAssets;
        }

        IERC20(token).safeTransferFrom(_msgSender(), address(this), _amount);

        userSupplyShares[_msgSender()] += shares;
        totalSupplyShares += shares;
        totalSupplyAssets += _amount;
    }

    function withdraw(uint256 _shares) public nonReentrant {
        if (_shares == 0) revert AmountIsZero();
        if (userSupplyShares[_msgSender()] < _shares) revert InsufficientBalance();

        uint256 amount = _shares * totalSupplyAssets / totalSupplyShares;

        userSupplyShares[_msgSender()] -= _shares;
        totalSupplyShares -= _shares;
        totalSupplyAssets -= amount;

        IERC20(token).safeTransfer(_msgSender(), amount);
    }

    function distributeYield(uint256 _amount) public onlyOwner {
        totalSupplyAssets += _amount;

        IERC20(token).safeTransferFrom(_msgSender(), address(this), _amount);
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
