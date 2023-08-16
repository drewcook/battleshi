// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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

/**
 * // Game
 * export interface ITurn {
 * 	id: number
 * 	playerName: string
 * 	guess: Location
 * 	result: PointStatus
 * }
 *
 * export interface IGame {
 * 	playerBoard: IBoard,
 * 	opponentBoard: IBoard,
 * 	player: IPlayer,
 * 	opponent: IPlayer,
 * 	public turns: ITurn[] = []
 * 	public winner: IPlayer | null = null
 * 	play(): void
 * 	addTurn(turn: ITurn): ITurn[]
 * 	declareWinner(player: IPlayer): void
 * }
 *
 *
 * // Board
 * export interface IBoard {
 * 	ocean: IPoint[][]
 * 	clearBoard(): void
 * 	getPoint(location: Location): IPoint
 * 	checkShipPlacement(ship: IShip, startLocation: Location): boolean
 * }
 *
 * // Location
 * export type Location = {
 * 	x: number,
 * 	y: number,
 * }
 *
 * // Points
 * export interface IPoint {
 * 	location: Location
 * 	status: PointStatus
 * 	updateStatus(status: PointStatus): void
 * }
 *
 * // Union (enum) for point statuses
 * export type PointStatus = 'Sunk' | 'Hit' | 'Miss' | 'Ship' | 'Empty'
 *
 * // Players
 * export interface IPlayer {
 * 	name: string
 * 	board: IBoar
 * 	fleet: IShip[]
 * 	allShipsDestroyed: boolean
 * 	guessedSpaces: Map<string, PointStatus>
 * 	placeShip(ship: IBaseShip, location: Location): void
 * 	receiveGuess(location: Location): PointStatus
 * 	makeGuess(location: Location, opponent: IPlayer): ITurn
 * }
 *
 * // Ships
 * // Union (enum) for ship types
 * export type ShipType = 'Destroyer' | 'Submarine' | 'Cruiser' | 'Battleship' | 'Carrier'
 *
 * export type ShipOrientation = 'horizontal' | 'vertical'
 *
 * export interface IBaseShip {
 * 	name: string,
 * 	orientation: ShipOrientation,
 * }
 *
 * export interface IShip extends IBaseShip {
 * 	type: ShipType
 * 	spacesOccupied: IPoint[]
 * 	size: number
 * 	isSunk(): boolean
 * 	sink(): void
 * }
 */

struct Game {
    Board playerBoard;
    Board opponentBoard;
    Player player;
    Player opponent;
    Turn[] turns;
    Player winner;
}

struct Turn {
    uint256 id;
    string playerName;
    Location guess;
    PointStatus result;
}

struct Board {
    Point[][] ocean;
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
    string name;
    Board board;
    Ship[] fleet;
    bool allShipsDestroyed;
    // mapping(string => PointStatus) guessedSpaces;
}

struct Ship {
    string name;
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

    function receiveGuess(
        Location memory location
    ) external returns (PointStatus);

    function makeGuess(
        Location memory location,
        Player memory opponent
    ) external returns (Turn memory);
}

interface IBoard {
    function clearBoard() external;

    function getPoint(Location memory location) external returns (Point memory);

    function checkShipPlacement(
        Ship memory ship,
        Location memory startLocation
    ) external returns (bool);
}

interface IPoint {
    function updateStatus(PointStatus status) external;
}

contract Battleship {}
