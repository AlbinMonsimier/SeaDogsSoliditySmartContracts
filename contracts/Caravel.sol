// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Caravel is ERC1155, Ownable {

  string baseURI;
  string public baseExtension = ".json";
  uint256 public cost = 0.05 ether;
  uint256 public maxSupply = 10000;
  uint256 public maxMintAmount = 20;
  bool public paused = false;


mapping(uint256 => Boat) private _tokenDetatils;

struct Boat {
    Life life;
    Position Position;
    uint16 speed;
    uint16 maxCrew;
    uint16 maxCannon;
}

struct Life {
    uint8 mast;
    uint8 hull; 
}

struct Position {
    uint8 x;
    uint8 y;
}

  constructor(
    // string memory _name,
    // string memory _symbol,
    string memory _initBaseURI
  ) ERC1155(_initBaseURI) {
    setBaseURI(_initBaseURI);
    mint(1);
  }

 event boatMoved(address _owner, uint256 _boatId, Position _position);

  // public
  function mint(uint32 _mintAmount) public payable onlyOwner {
    require(!paused);
    require(_mintAmount <= maxSupply, "sold out");

    if (msg.sender != owner()) {
      require(msg.value >= cost * _mintAmount);
    }

    for (uint256 i=0; i < 1; i++) {
        _tokenDetatils[i] = Boat(Life(1,2),Position(1,1),1,1,1);
    }
    _mint(msg.sender, 1, _mintAmount, "test");
  }

  function moveBoat(uint32 boatId, uint8 x , uint8 y ) public {
      bool ownTheBoat = _ownerOf(boatId);
      require(ownTheBoat, "you dont own this token");
    _tokenDetatils[boatId].Position = Position(x,y);
    emit boatMoved(msg.sender, boatId, Position(x,y));
  }

  // function walletOfOwner (address _owner)
  //   public
  //   view
  //   returns (uint256[] memory)
  // {
  //   uint256 ownerTokenCount = balanceOf(_owner);
  //   uint256[] memory tokenIds = new uint256[](ownerTokenCount);
  //   for (uint256 i; i < ownerTokenCount; i++) {
  //     tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
  //   }
  //   return tokenIds;
  // }

function _ownerOf(uint256 tokenId) internal view returns (bool) {
    return balanceOf(msg.sender, tokenId) != 0;
}

  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }
  
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
  function withdraw() public payable onlyOwner { 
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }
}
