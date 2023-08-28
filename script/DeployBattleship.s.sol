// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BattleshipGameFactory} from "../src/BattleshipGameFactory.sol";

contract DeployBattleship is Script {
    function run() external returns (BattleshipGameFactory factory) {
        vm.startBroadcast();
        factory = new BattleshipGameFactory();
        vm.stopBroadcast();
    }
}
