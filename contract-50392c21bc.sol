// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Happy Diwali 🪔

import "@openzeppelin/contracts@4.3.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.3.2/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.3.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.3.2/utils/Counters.sol";

contract SoanPapdi is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    uint256 public MAX_SUPPLY = 1000;
    uint256 public mintRate = 15 ether;
    string private _baseURIExtended;

    constructor(string memory baseURI_) ERC721("SoanPapdi", "SP") {
        _baseURIExtended = baseURI_;
    }

    function gift(address to) public payable {
        require(totalSupply() + 1 < MAX_SUPPLY, "No more Soan Papdi left.");
        require(msg.value >= mintRate, "Not enough tokens sent.");
        require(msg.sender != to, "You never buy Soan Papdi for yourself.");

        _tokenIdCounter.increment();
        _safeMint(to, _tokenIdCounter.current());
    }
    
    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Balance should be > 0.");
        payable(owner()).transfer(address(this).balance);
    }
    
    function _baseURI() internal view override returns (string memory) {
        return _baseURIExtended;
    }
    
    // Sets base URI for all tokens, only able to be called by contract owner
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIExtended = baseURI_;
    }
    
    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
    }
    
    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
