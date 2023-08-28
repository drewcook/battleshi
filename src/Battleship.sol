// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {
    IBattleship,
    Game,
    Location,
    Player,
    Point,
    PointStatus,
    Ship,
    ShipType,
    ShipOrientation
} from "./structs/Structs.sol";

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

contract Battleship is IBattleship, Ownable /*, CCIPReceiver */ {
    Player public initiatingPlayer; // The player who starts a new game
    Player public opposingPlayer; // The player who joins an existing game
    uint256 public stake; // The amount required to play a game and win, should be double of the stake

    uint8 private immutable i_gridSize;

    // mapping(uint64 => bool) public whitelistSourceChains;

    error Battleship__ArbitraryDepositsNotSupported();

    constructor(address _playerOne, uint8 _gridSize, uint256 _stake) payable {
        _initialize(_playerOne, _gridSize);
        // Initialize stake, support any amount
        i_gridSize = _gridSize;
        stake += _stake;
    }

    receive() external payable {
        revert Battleship__ArbitraryDepositsNotSupported();
    }

    function deposit() external payable {
        require(msg.value == stake, "Can only deposit the stake amount");
        require(
            msg.sender == initiatingPlayer.playerAddress || msg.sender == opposingPlayer.playerAddress,
            "Only valid players can deposit"
        );
        stake += msg.value;
    }

    function registerOpponent(address _opposingPlayer, uint256 _stake) external payable onlyOwner {
        require(initiatingPlayer.playerAddress != address(0) && opposingPlayer.playerAddress != address(0));
        require(_opposingPlayer == address(0), "Player address cannot be the zero address");
        require(_opposingPlayer != initiatingPlayer.playerAddress, "Player cannot play oneself");
        require(_stake == stake, "Can only deposit the stake amount");

        // opposingPlayer = Player(_opposingPlayer, _initializeBoard(i_gridSize), new Ship[](5), false);
        stake += _stake;
    }

    // function playMove(uint64 _sourceChainSelector, uint8 _x, uint8 _y) public {
    //     require(whitelistSourceChains[_sourceChainSelector], "Source chain not whitelisted");
    // }

    function _initialize(address _initiatingPlayer, uint8 _gridSize) private pure {
        require(_initiatingPlayer != address(0), "Player one cannot be the zero address");
        require(_gridSize <= type(uint8).max, "Grid size too large");
        require(_gridSize > 5, "Grid size too small");
        Ship[5] memory ships;
        _initializeShips(ships);
        // initiatingPlayer = Player(_initiatingPlayer, _initializeBoard(_gridSize), , false);

        // Player memory opponent = Player(opponentName, _initializeBoard(_gridSize), new Ship[](5), false);
        // Game memory game = Game(initiatingPlayer, opponent, address(0), defaultBoard, defaultBoard, new Turn[](0));
    }

    function _initializeBoard(uint8 _gridSize) private pure returns (Point[][] memory board) {
        for (uint8 i = 0; i < _gridSize; i++) {
            for (uint8 j = 0; j < _gridSize; j++) {
                board[i][j] = Point(Location(i, j), PointStatus.Empty);
                board[i][j] = Point(Location(i, j), PointStatus.Empty);
            }
        }
    }

    function _initializeShips(Ship[5] memory _ships) private pure {
        Ship memory destroyer;
        destroyer.shipType = ShipType.Destroyer;
        destroyer.orientation = ShipOrientation.Horizontal;
        destroyer.size = 2;

        Ship memory submarine;
        submarine.shipType = ShipType.Submarine;
        submarine.orientation = ShipOrientation.Horizontal;
        submarine.size = 3;

        Ship memory cruiser;
        cruiser.shipType = ShipType.Cruiser;
        cruiser.orientation = ShipOrientation.Horizontal;
        cruiser.size = 3;

        Ship memory battleship;
        battleship.shipType = ShipType.Battleship;
        battleship.orientation = ShipOrientation.Horizontal;
        battleship.size = 4;

        Ship memory carrier;
        carrier.shipType = ShipType.Carrier;
        carrier.orientation = ShipOrientation.Horizontal;
        carrier.size = 5;

        _ships[0] = destroyer;
        _ships[1] = submarine;
        _ships[2] = cruiser;
        _ships[3] = battleship;
        _ships[4] = carrier;
    }
}
