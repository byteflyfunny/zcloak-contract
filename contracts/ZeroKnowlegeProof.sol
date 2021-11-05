// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import "./common/Ownable.sol";

// import "@openzeppelin/contracts/proxy/Initializable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract ZeroKnowlegeProof is ERC20{

    event CreateTaskEvent(address sender, bytes programHash, uint128[] publicInputs, uint128[] outputs, string proofId);
    event AddWhitelistEvent(address sender, address white);
    event SaveProofEvent(address sender, address owner, bytes programHash, bool result);
    event SaveProofFailedEvent(address sender, address owner, bytes programHash, bool result);
    event AddClassTypeEvent(string class, bytes programHash);
    event RemoveClassTypeEvent(string class);
    event RemoveProofEvent(address owner, bytes programHash);

    mapping (address => mapping (bytes => bool)) proofs;
    mapping (address => bool) whitelist;
    mapping (string => bytes) classes;

    // function initialize() public initializer {
    //     ownableConstructor();
    // }

  constructor(uint256 initialSupply) ERC20("Proof", "PROOFTOK") {
    _mint(msg.sender, initialSupply);
  }

    function verify(
        bytes memory programHash,
        uint128[] memory publicInputs,
        uint128[] memory outputs,
        string memory proofId
    ) public {
        emit CreateTaskEvent(msg.sender, programHash, publicInputs, outputs, proofId);

    }

    function saveProof(
        address sender,
        address owner, 
        bytes memory programHash, 
        bool result
        ) public {
        if (isWhitelist(sender)){
            proofs[owner][programHash] = result;
            emit SaveProofEvent(sender, owner, programHash, result);
        }else{
            emit SaveProofFailedEvent(sender, owner, programHash, result);
        }
    }

    function getProof(
        address sender,
        bytes memory programHash
        ) public view returns (bool) {
        if (proofs[sender][programHash]) {
            return true;
        } else {
            return false;
        }
    }

    function removePoorf(
        address owner,
        bytes memory programHash
    ) public {
        delete proofs[owner][programHash];
        emit RemoveProofEvent(owner, programHash);
    }
    

    function addWhitelist(address white) public {
        _setWhite(white);
        emit AddWhitelistEvent(msg.sender, white);
    }

    function _setWhite(address white) internal {
        whitelist[white] = true;
    }

    function isWhitelist(address addr) public view returns (bool) {
        if (whitelist[addr]) {
            return true;
        }else{
            return false;
        }
    }

    function registerClass (
         string memory class,
         bytes memory programHash
        ) public {
        _addClass(class, programHash);
        emit AddClassTypeEvent(class, programHash);

    }

    function removeClass(string memory class) public {
        delete classes[class];
        emit RemoveClassTypeEvent(class);
    }

    function getClass(string memory class) public view returns (bytes memory) {
        return classes[class];
    }

    function _addClass(string memory class, bytes memory programHash) internal {
        classes[class] = programHash;
    }
}