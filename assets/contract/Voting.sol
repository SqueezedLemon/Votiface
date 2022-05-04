// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;

contract Voting {
    struct Voter {
        string id;
        uint area;
        bool canVote;
        bool votedForCandidate;
        bool votedForParty;
    }

    struct Party {
        string name;
        uint256 voteCount;
    }

    struct Candidate {
        string name;
        string party;
        uint area;
        uint256 voteCount;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    uint256 voter_count = 0;
    Candidate[] public candidates;
    Party[] public parties;

    constructor(
        string[3][] memory candidateNamesParty,
        string[] memory partyNames
    ) payable {
        chairperson = msg.sender;
        voters[chairperson].canVote = true;
        for (uint256 i = 0; i < candidateNamesParty.length; i++) {
            candidates.push(
                Candidate({
                    name: candidateNamesParty[i][0],
                    party: candidateNamesParty[i][1],
                    area: stringToUint(candidateNamesParty[i][2]),
                    voteCount: 0
                })
            );
        }
        for (uint256 i = 0; i < partyNames.length; i++) {
            parties.push(Party({name: partyNames[i], voteCount: 0}));
        }
        voter_count += 1;
    }

    function stringToUint(string memory numString) public pure returns(uint) {
            uint  val=0;
            bytes   memory stringBytes = bytes(numString);
            for (uint  i =  0; i<stringBytes.length; i++) {
                uint exp = stringBytes.length - i;
                bytes1 ival = stringBytes[i];
                uint8 uval = uint8(ival);
            uint jval = uval - uint(0x30);
    
            val +=  (uint(jval) * (10**(exp-1))); 
            }
        return val;
        }
    function addCandidates(string[3][] memory candidateNamesParty) external {
        require(
            msg.sender == chairperson,
            "Only chairman can give the right to vote"
        );
        for (uint256 i = 0; i < candidateNamesParty.length; i++) {
            candidates.push(
                Candidate({
                    name: candidateNamesParty[i][0],
                    party: candidateNamesParty[i][1],
                    area: stringToUint(candidateNamesParty[i][2]),
                    voteCount: 0
                })
            );
        }
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function getParties() public view returns (Party[] memory) {
        return parties;
    }

    function giveRightToVote(
        address payable voter,
        string memory id,
        string memory area
    ) external {
        require(
            msg.sender == chairperson,
            "Only chairman can give the right to vote"
        );
        require(
            !voters[voter].votedForCandidate || !voters[voter].votedForParty,
            "The voter already voted"
        );
        require(!voters[voter].canVote, "Voter can already vote");
        voters[voter].canVote = true;
        voters[voter].id = id;
        voters[voter].area = stringToUint(area);
        voters[voter].votedForCandidate= false;
        voters[voter].votedForParty = false;
        voter.transfer(10000000000000);
        voter_count += 1;
    }
    

    function removeRightToVote(address voter) external {
        require(
            msg.sender == chairperson,
            "Only chairman can give denounce right to vote"
        );
        require(
            !voters[voter].votedForCandidate || !voters[voter].votedForParty,
            "The voter already voted"
        );
        require(voters[voter].canVote, "Voter doesn't have right to vote");
        voters[voter].canVote = false;
        voter_count -= 1;
    }

    function voteCandidate(uint256 candidate) external {
        Voter storage sender = voters[msg.sender];
        require(sender.canVote, "Has no right to vote");
        require(!sender.votedForCandidate, "already voted for candidate");
        require(sender.area == candidates[candidate].area, "cannot vote candidate in this area");
        candidates[candidate].voteCount += 1;
        sender.votedForCandidate = true;
    }

    function voteParty(uint256 party) external {
        Voter storage sender = voters[msg.sender];
        require(sender.canVote, "Has no right to vote");
        require(!sender.votedForParty, "already voted for party");
        parties[party].voteCount += 1;
        sender.votedForCandidate = true;
    }

    function winningCandidate()
        public
        view
        returns (uint256 winningCandidate_)
    {
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidate_ = i;
            }
        }
    }

    function winningParty() public view returns (uint256 winningParty_) {
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < parties.length; i++) {
            if (parties[i].voteCount > winningVoteCount) {
                winningVoteCount = parties[i].voteCount;
                winningParty_ = i;
            }
        }
    }

    function voters_count() public view returns (uint256) {
        return voter_count;
    }

    function fund() public payable {}

    function get_balance() public view returns(uint256){
        return address(this).balance;
    }
}
