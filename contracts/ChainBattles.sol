// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

//deployed to mumbai network 0x028e7DAec59498D73c6825Ee25DC75E2c3C8338c
//deployed to mumbai network 0x5FE6E8E8041FFbFddD5eC973a915f51522bff62D
//deployed to mumbai network 0xA8dd7c3B2527706f134D4E2812a7BCf35a71AD27
//deployed to mumbai network 0x9bB0528B0D800a4c70dB95bC94f985CC757D480b
//deployed to mumbai network 0x3dD5a47Db6486d4df08D0969021a496213551735
//deployed to mumbai network 0xdc5b9Ad65d17fc549d203B4032ba77a323F73527

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct pokemon {
        uint256 levels;
        uint256 attack;
        uint256 defence;
    }

    mapping(uint256 => pokemon) public tokenIdtoLevels;

    constructor() ERC721("Chain Battles", "CBTLS"){

    }

    function generateCharacter(uint256 tokenId) public returns(string memory){
       bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<style>.attack { fill: red; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="blue" />',
        '<text x="50%" y="35%" class="base" dominant-baseline="middle" text-anchor="middle">',"Pokemon",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
        '<text x="50%" y="60%" class="attack" dominant-baseline="middle" text-anchor="middle">', "Attack: ",getAttack(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Defence: ",getDefence(tokenId),'</text>',
        '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }


    function getLevels(uint256 tokenId) public view returns (string memory){
        pokemon storage p = tokenIdtoLevels[tokenId];
        uint256 levels = p.levels;
        return levels.toString();
    }

    function getAttack(uint256 tokenId) public view returns (string memory){
        pokemon storage p = tokenIdtoLevels[tokenId];
        uint256 attack = p.attack;
        return attack.toString();
    }

    function getDefence(uint256 tokenId) public view returns (string memory){
        pokemon storage p = tokenIdtoLevels[tokenId];
        uint256 defence = p.defence;
        return defence.toString();
    }

    function getTokenURI(uint256 tokenId) public returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        pokemon storage p = tokenIdtoLevels[newItemId];
        p.levels = 0;
        p.attack = 10;
        p.defence = 10;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }


    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing Token");
        require(ownerOf(tokenId) == msg.sender, "You must own the Token to train it");
        pokemon storage p = tokenIdtoLevels[tokenId];
        uint256 currentLevel = p.levels;
        uint256 currentAttack = p.attack;
        uint256 currentDefence = p.defence;

        uint256 nonce;
        uint256 random1 = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 10;
        nonce++;
        uint256 random2 = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 10;

        p.levels = currentLevel + 1;
        p.attack = currentAttack + random1;
        p.defence = currentDefence + random2;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    } 
}