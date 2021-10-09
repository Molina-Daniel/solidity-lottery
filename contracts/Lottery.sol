// SPDX-License-Identifier: MIT

pragma solidity > 0.4.17 < 0.8.9;

contract Lottery {
    address public manager;
    address[] public players;
    
    constructor() {
        manager = msg.sender; // msg is a global variable available always we do either a transaction or a call
    }
    
    // modifiers let us reuse require statements in different functions
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function enter() public payable {
        // we check the player trying to enter in the lottery send a minimum of 0.01 ethers
        require(msg.value > .01 ether);
        
        players.push(msg.sender);
    }
    
    // There's no real random number generator built in Solidity
    // we'll try to creater a pseudo random number generator helper function
    // which takes the block difficulty, the current time, and the players' addresses
    // through sha3 to generate a large number
    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    function pickWinner() public restricted {
        // use the modulus to get a number included in the players' array
        uint index = random() % players.length;
        
        // transfer the current balance of the contract to the winner address
        payable(players[index]).transfer(address(this).balance);
        
        // empty the players array to restart the lottery
        players = new address[](0);
    }
    
    // Gets the addresses of all paticipants in the lottery
    function getPlayers() public view returns(address[] memory) {
        return players;
    }
}