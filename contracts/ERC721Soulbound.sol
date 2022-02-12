// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./brightid/BrightIDRegistry.sol";

contract ERC721Soulbound is ERC721, BrightIDRegistry {
    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxSupply = 10000;  // Make 10k
    uint256 public maxMintAmount = 1;
    uint256 public totalMinted = 0;
    bool public paused = false;
    mapping(address => uint256) public addressMintedBalance;


    constructor(
        IERC20 verifierToken,
        bytes32 context,
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) BrightIDRegistry(verifierToken, context) {

        setBaseURI("ipfs://QmRte2aJTeFtwC6YjsVTseY2wigvc7dUU5TqugR2cTwcHX/1.json");

    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function mintNFT(uint256 _mintAmount) public payable {
    require(!paused, "the contract is paused");
    uint256 supply = totalMinted;
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");

    _safeMint(msg.sender, supply++);
    totalMinted++;

    }

  /*  function walletOfOwner(address _owner) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
    return tokenIds;
    }
*/

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? //string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        string(abi.encodePacked(currentBaseURI))
        : "";
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
    }

    function pause(bool _state) public onlyOwner {
    paused = _state;
    }

    /**
     * @dev See {ERC721-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - `from` and `to` must belong to the same BrightID.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        // Ignore transfers during minting
        if (from == address(0)) {
            return;
        }
        require(
            _isSameBrightID(from, to),
            "ERC721Soulbound: Not linked to the same BrightID"
        );
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        virtual
        override
        returns (bool)
    {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
        );
        address owner = ERC721.ownerOf(tokenId);
        return _isSameBrightID(spender, owner);
    }
}
