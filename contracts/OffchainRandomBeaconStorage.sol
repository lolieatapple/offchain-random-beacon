// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract OffchainRandomBeaconStorage {
    using SafeMath for uint256;

    // user => call this sc nonce
    mapping(address => uint) public nonces;
}
