// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Battleship} from "./Battleship.sol";
import {IBattleship, GameSession} from "./structs/Structs.sol";

// uint64 sourceChainSelector;
// uint64 destinationChainSelector;

contract BattleshipGameFactory is Ownable {
    bytes32[] public s_sessionIds;
    mapping(bytes32 => GameSession) public s_gameSessions;

    event NewGameCreated(bytes32 indexed sessionId, address deployedAt);
    event GameDeleted(bytes32 indexed sessionId);

    function createNewGame(uint8 _gridSize) external payable {
        bytes32 uniqueId = keccak256(abi.encodePacked(block.timestamp, msg.sender));

        s_sessionIds.push(uniqueId);

        Battleship game = new Battleship(
            msg.sender,
            _gridSize,
            msg.value
        );

        s_gameSessions[uniqueId] = GameSession({
            sessionId: uniqueId,
            deployedAt: address(game),
            playerOne: msg.sender,
            playerTwo: address(0),
            winner: address(0),
            stake: msg.value
        });

        emit NewGameCreated(uniqueId, address(game));
    }

    function joinExistingGame(bytes32 _sessionId) external payable {
        // require(s_gameSessions[_sessionId], "Game session does not exist");
        require(s_gameSessions[_sessionId].playerTwo == address(0), "Game session is full");
        require(s_gameSessions[_sessionId].playerOne != msg.sender, "Player cannot join their own game");
        require(msg.value == s_gameSessions[_sessionId].stake, "Must deposit the stake amount");

        IBattleship(s_gameSessions[_sessionId].deployedAt).registerOpponent(msg.sender, msg.value);
        s_gameSessions[_sessionId].playerTwo = msg.sender;
    }

    function removeGame(bytes32 _sessionId) external onlyOwner {
        delete s_gameSessions[_sessionId];
        emit GameDeleted(_sessionId);
    }
}
