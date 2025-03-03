// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract EvidenceTracker {
    struct FIR {
        string ipfsHash;
        address officer;
        uint256 timestamp;
        bool isOpen;
    }
    
    struct Evidence {
        string ipfsHash;
        uint256 caseId;
        uint256 timestamp;
    }

    FIR[] public firs;
    Evidence[] public evidences;

    event FIRCreated(uint256 indexed firId, string ipfsHash);
    event EvidenceAdded(uint256 indexed evidenceId, uint256 caseId);

    function createFIR(string memory _ipfsHash) public {
        firs.push(FIR(
            _ipfsHash,
            msg.sender,
            block.timestamp,
            true
        ));
        emit FIRCreated(firs.length - 1, _ipfsHash);
    }

    function addEvidence(uint256 _caseId, string memory _ipfsHash) public {
        evidences.push(Evidence(
            _ipfsHash,
            _caseId,
            block.timestamp
        ));
        emit EvidenceAdded(evidences.length - 1, _caseId);
    }

    function getFIR(uint256 _firId) public view returns (string memory, address, uint256, bool) {
        FIR memory fir = firs[_firId];
        return (fir.ipfsHash, fir.officer, fir.timestamp, fir.isOpen);
    }

    function getEvidence(uint256 _evidenceId) public view returns (string memory, uint256, uint256) {
        Evidence memory evidence = evidences[_evidenceId];
        return (evidence.ipfsHash, evidence.caseId, evidence.timestamp);
    }
}