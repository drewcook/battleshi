// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

struct GameSession {
    bytes32 sessionId;
    address deployedAt;
    address playerOne;
    address playerTwo;
    address winner;
    uint256 stake;
}

struct Game {
    Player player;
    Player opponent;
    address winner;
    Point[][] playerBoard;
    Point[][] opponentBoard;
    Turn[] turns;
}

struct Turn {
    uint256 id;
    string playerName;
    Location guess;
    PointStatus result;
}

struct Point {
    Location location;
    PointStatus status;
}

struct Location {
    uint256 x;
    uint256 y;
}

enum PointStatus {
    Sunk,
    Hit,
    Miss,
    Ship,
    Empty
}

struct Player {
    address playerAddress;
    Point[][] board;
    Ship[5] fleet;
    bool allShipsDestroyed;
}
// mapping(string => PointStatus) guessedSpaces;

struct Ship {
    ShipType shipType;
    ShipOrientation orientation;
    Point[] spacesOccupied;
    uint256 size;
    bool isSunk;
}

enum ShipType {
    Destroyer,
    Submarine,
    Cruiser,
    Battleship,
    Carrier
}

enum ShipOrientation {
    Horizontal,
    Vertical
}

interface IGame {
    function play() external;

    function addTurn(Turn memory turn) external returns (Turn[] memory);

    function declareWinner(Player memory player) external;
}

interface IPlayer {
    function placeShip(Ship memory ship, Location memory location) external;

    function receiveGuess(Location memory location) external returns (PointStatus);

    function makeGuess(Location memory location, Player memory opponent) external returns (Turn memory);
}

interface IBoard {
    function clearBoard() external;

    function getPoint(Location memory location) external returns (Point memory);

    function checkShipPlacement(Ship memory ship, Location memory startLocation) external returns (bool);
}

interface IPoint {
    function updateStatus(PointStatus status) external;
}

interface IBattleship {
    function deposit() external payable;
    function registerOpponent(address _opposingPlayer, uint256 _stake) external payable;
}
