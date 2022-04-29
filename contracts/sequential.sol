// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyToken is ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint;

    Counters.Counter private _tokenIdCounter;
    
    uint public totalSupply;
    string public baseTokenURI;
    uint public mintPrice;
    address immutable private pixeltrue = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;


    constructor(string memory _name, string memory _symbol,uint _price,uint _supply) ERC721(_name, _symbol) {
        totalSupply = _supply;
        mintPrice = _price;
    }

    function safeMint(address to) public payable {
        require(_tokenIdCounter.current() <= totalSupply,"limit completed");
        require(msg.value == mintPrice,"less amount");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        uint Tax = calculateTax(msg.value);
        address _owner = owner();
        payable(pixeltrue).transfer(Tax);
        payable(_owner).transfer(msg.value - Tax);

    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

      // Set new baseURI
    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    { 
        return string(abi.encodePacked(baseTokenURI,tokenId.toString(),".json"));
    }

    function calculateTax(uint _value)public pure returns(uint){
        return _value/10000 * 927;
    }
}