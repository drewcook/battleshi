// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/Script.sol";
import {DeployBattleship} from "../../script/DeployBattleship.s.sol";
import {BattleshipGameFactory, GameSession} from "../../src/BattleshipGameFactory.sol";
import {IBattleship} from "../../src/structs/Structs.sol";

contract BattleshipGameFactoryTest is Test {
    BattleshipGameFactory factory;

    address public ALICE = makeAddr("initiator");
    address public BOB = makeAddr("opponent");

    function setUp() external {
        DeployBattleship deployer = new DeployBattleship();
        factory = deployer.run();
        vm.deal(ALICE, 1 ether);
        vm.deal(BOB, 1 ether);
    }

    function testFail_creatNewGameGridSize() external {
        vm.prank(ALICE);
        factory.createNewGame{value: 1 ether}(1);
    }

    // function testFail_creatNewGameNoStake() external {
    //     vm.prank(ALICE);
    //     factory.createNewGame(10);
    // }

    function test_createNewGame() external {
        vm.prank(ALICE);
        factory.createNewGame{value: 1 ether}(10);
        (bytes32 sessionId, address deployedAt, address playerOne, address playerTwo, address winner, uint256 stake) =
            factory.s_gameSessions(factory.s_sessionIds(0));
        console.log("BattleshipGameFactory deployed to:", deployedAt);
        assertEq(playerOne, ALICE);
        assertEq(playerTwo, address(0));
        assertEq(winner, address(0));
        assertEq(stake, 1 ether);
    }

    function test_joinExistingGame() external {
        // Create a game session
        vm.prank(ALICE);
        factory.createNewGame{value: 1 ether}(10);
        (bytes32 sessionId, address deployedAt,,,,) = factory.s_gameSessions(factory.s_sessionIds(0));

        // Join the game session
        (,,, address newPlayerTwo,,) = factory.s_gameSessions(sessionId);
        vm.prank(BOB);
        factory.joinExistingGame{value: 1 ether}(sessionId);
        // IBattleship(deployedAt).registerOpponent(BOB, 1 ether);
        assertEq(newPlayerTwo, BOB);
    }

    function test_removeGame() external {
        // Create a game session
        vm.startPrank(ALICE);
        factory.createNewGame{value: 1 ether}(10);
        (bytes32 sessionId,,,,,) = factory.s_gameSessions(factory.s_sessionIds(0));
        vm.stopPrank();

        // Remove the game session
        factory.removeGame(sessionId);
        // assertEq(factory.s_gameSessions(0), address(0));
    }
}
