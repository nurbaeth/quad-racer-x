// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract QuadRacerX {
    uint256 public constant TRACK_LENGTH = 100;
    uint256 public constant MAX_SPEED = 10;
    uint256 public constant MIN_SPEED = 1;

    enum RaceState { Waiting, InProgress, Finished }

    struct Racer {
        address racerAddress;
        uint256 position;
        uint256 lastSpeed;
        bool hasFinished;
    }

    struct Race {
        uint256 raceId;
        address[] racers;
        mapping(address => Racer) racerInfo;
        RaceState state;
        address winner;
    }

    uint256 public raceCounter;
    mapping(uint256 => Race) public races;

    event RaceCreated(uint256 indexed raceId);
    event RacerJoined(uint256 indexed raceId, address racer);
    event RaceStarted(uint256 indexed raceId);
    event MoveMade(uint256 indexed raceId, address racer, uint256 speed, uint256 newPosition);
    event RaceFinished(uint256 indexed raceId, address winner);

    modifier onlyInState(uint256 raceId, RaceState _state) {
        require(races[raceId].state == _state, "Invalid race state");
        _;
    }

    function createRace() external returns (uint256) {
        raceCounter++;
        Race storage race = races[raceCounter];
        race.raceId = raceCounter;
        race.state = RaceState.Waiting;
        emit RaceCreated(raceCounter);
        return raceCounter;
    }

    function joinRace(uint256 raceId) external onlyInState(raceId, RaceState.Waiting) {
        Race storage race = races[raceId];
        require(race.racerInfo[msg.sender].racerAddress == address(0), "Already joined");

        race.racers.push(msg.sender);
        race.racerInfo[msg.sender] = Racer(msg.sender, 0, 0, false);
        emit RacerJoined(raceId, msg.sender);
    }

    function startRace(uint256 raceId) external onlyInState(raceId, RaceState.Waiting) {
        require(races[raceId].racers.length >= 2, "Not enough racers");
        races[raceId].state = RaceState.InProgress;
        emit RaceStarted(raceId);
    }

    function makeMove(uint256 raceId, uint256 speed) external onlyInState(raceId, RaceState.InProgress) {
        Race storage race = races[raceId];
        Racer storage racer = race.racerInfo[msg.sender];

        require(!racer.hasFinished, "You already finished");
        require(speed >= MIN_SPEED && speed <= MAX_SPEED, "Invalid speed");

        racer.position += speed;
        racer.lastSpeed = speed;

        if (racer.position >= TRACK_LENGTH) {
            racer.hasFinished = true;
            if (race.winner == address(0)) {
                race.winner = msg.sender;
                race.state = RaceState.Finished;
                emit RaceFinished(raceId, msg.sender);
            }
        }

        emit MoveMade(raceId, msg.sender, speed, racer.position);
    }

    function getRacerInfo(uint256 raceId, address racerAddr) external view returns (uint256, uint256, bool) {
        Racer memory r = races[raceId].racerInfo[racerAddr];
        return (r.position, r.lastSpeed, r.hasFinished);
    }

    function getRacers(uint256 raceId) external view returns (address[] memory) {
        return races[raceId].racers;
    }
}
