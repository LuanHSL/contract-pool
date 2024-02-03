pragma solidity 0.4.24;

contract Pool {
  address private manager;
  address[] private players;

  constructor() public {
    manager = msg.sender;
  }

  function enter() public payable {
    require(msg.value >= 1 ether);
    players.push(msg.sender);    
  }

  function draw() public restricted {
    uint index = random() % players.length;
    players[index].transfer(address(this).balance);
    clear();
  }

  modifier restricted() {
    require(msg.sender == manager);
    _;
  }

  function getPlayers() public view returns (address[]) {
    return players;
  }

  function getManager() public view returns (address) {
    return manager;
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }

  function clear() private {
    players = new address[](0);
  }

  function random() private view returns (uint) {
    return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
  }
}