// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin-contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin-contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    error ERC20ExceedsMaxMintAmount(uint256 amount);

    // constructor == function
    // constructor function yang dieksekusi pertama kali saat contract di deploy
    constructor() ERC20("BAHLIL MENTERI", "BAHLIL") Ownable(msg.sender) {}

    modifier maxMint(uint256 _amount) {
        _maxMint(_amount);
        _;
    }

    function _maxMint(uint256 _amount) internal pure {
        if (_amount > 1_000e19) revert ERC20ExceedsMaxMintAmount(_amount);
    }

    // function a
    function mint(address to, uint256 amount) public onlyOwner maxMint(amount) {
        _mint(to, amount);
    }

    // function b
    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }

    //
    function decimals() public pure override returns (uint8) {
        return 19;
    }

    // function _NamaFunction() _public/_private/_external/_internal _view(read)/_pure(read)
}

// 89694.90970923
