// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/proxy/Initializable.sol";
import "./OffchainRandomBeaconStorage.sol";

interface Receiver {
    function inputSeed(uint randomSeed, uint id) external;
}

contract OffchainRandomBeaconDelegate is Initializable, AccessControl, OffchainRandomBeaconStorage {

    bytes32 public constant ROBOT_ROLE = keccak256("ROBOT_ROLE");

    event RequestRandom(address indexed user, uint indexed id);

    function initialize(address admin, address robot) public payable initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        _setRoleAdmin(ROBOT_ROLE, DEFAULT_ADMIN_ROLE);
        grantRole(ROBOT_ROLE, robot);
    }

    function requestRandom(uint id) external {
        emit RequestRandom(msg.sender, id);
    }

    function beaconRandom(address user, uint id, uint seed) external {
        require(hasRole(ROBOT_ROLE, msg.sender), "No access");
        uint randomSeed = uint(keccak256(abi.encode(user, id, blockhash(block.number - 1), block.coinbase, seed, nonces[user])));
        nonces[user]++;
        Receiver(user).inputSeed(randomSeed, id);
    }
}

