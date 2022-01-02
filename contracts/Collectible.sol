// # export NODE_OPTIONS=--openssl-legacy-provider
pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Collectible is ERC721, VRFConsumerBase {
    uint256 public tokenCounter;
    bytes32 public keyHash;
    uint256 public fee;
    enum Breed{PUG,SHIBA_INU,ST_BERNARD}
    mapping(uint256 => Breed) public tokenIdToBreed;
    mapping(bytes32 => address) public requestIdToSender;
    mapping(uint256 => uint256) public tokenIdToCuteness;

    event requestedCollectible(bytes32 indexed requestId, address requester);
    event breedAssigned(uint256 indexed tokenId, Breed breed);
    event cutenessAssigned(uint256 indexed tokenId, uint256 cuteness);

    constructor(address _VRFCoordinator, address _linkToken, bytes32 _keyHash, uint256 _fee) public
    VRFConsumerBase(_VRFCoordinator, _linkToken)
    ERC721("Doggie","DOG")
    { tokenCounter = 0; keyHash = _keyHash; fee = _fee;}
    
    function createCollectible() public returns(bytes32) {
        // get random breed of dogie
        bytes32 requestId = requestRandomness(keyHash,fee);
        requestIdToSender[requestId] = msg.sender;
        emit requestedCollectible(requestId, msg.sender);
    } 

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        Breed breed = Breed(randomNumber % 3);
        uint256 cuteness = randomNumber % 100;
        uint256 newTokenId = tokenCounter;
        tokenIdToBreed[newTokenId] = breed;
        tokenIdToCuteness[newTokenId] = cuteness;
        emit breedAssigned(newTokenId, breed);
        address owner = requestIdToSender[requestId];
        _safeMint(owner, newTokenId);
        tokenCounter = tokenCounter+1;
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: Caller is not owner");
        _setTokenURI(tokenId, _tokenURI);
    }
}