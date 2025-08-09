// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;

pragma solidity >=0.6.0 <0.9.0;

contract election {
    //struct to store data of the Voters
    struct Voter {
        string nameVoter;
        uint nifVoter;
        string nameCandidate;
    }

    //struct to store data of the Voters
    struct Candidate {
        string nameCandidate;
        uint idCandidate;
        uint votesCandidate;
    }

    //array of type struct candidate
    Candidate[] public candidates;

    constructor() {
        addCandidate("Alice");
        addCandidate("Bob");
        addCandidate("Charlie");
    }

    function addCandidate(string memory _name) private {
        candidates.push(Candidate(_name, candidates.length, 0));
    }

    // Function that return candidates
    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    // dynamic array to store voters
    Voter[] public voter;

    // Insert a voter to be able to vote
    function addVoter(
        string memory _voterName,
        uint _nifVoter,
        string memory _candidateName
    ) public {
        // Variable to help checking existence of candidate
        bool candidateExists = false;
        // Variable to help checking existence of a new Voter
        bool voterExists = false;

        // Check the existence of a NIF
        for (uint i = 0; i < voter.length; i++) {
            if (voter[i].nifVoter == _nifVoter) {
                voterExists = true;
                break;
            }
        }

        // Do not allow repeat NIF
        require(!voterExists, "Voter with this NIF already exists");

        // Check candidates array
        for (uint i = 0; i < candidates.length; i++) {
            if (
                keccak256(abi.encodePacked(candidates[i].nameCandidate)) ==
                keccak256(abi.encodePacked(_candidateName))
            ) {
                candidateExists = true;
                candidates[i].votesCandidate += 1; // increment candidate votes
                break; // jump out of the loop
            }
        }

        // If candidate not exist, reverse the transaction
        require(candidateExists, "Candidate does not exist");

        // After check the existence of candidate, add voter
        voter.push(Voter(_voterName, _nifVoter, _candidateName));
    }

    // Return votes Number
    function showVotes() public view returns (uint[] memory) {
        uint count = candidates.length; // Number of candidates

        uint[] memory votes = new uint[](count);

        for (uint i = 0; i < count; i++) {
            votes[i] = candidates[i].votesCandidate;
        }

        return votes;
    }
}
