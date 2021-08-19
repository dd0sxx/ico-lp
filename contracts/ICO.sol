pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ICO is Ownable {

    mapping (address => uint) balances;
    mapping (address => bool) whitelist;
    uint constant goal = 30000 ether;
    uint totalFunds;
    bool paused;
    phases phase;

    enum phases {
        seed,
        general,
        open
    }

    constructor () {
        phase = phases.seed;
    }

    function changePhase () external onlyOwner {
        if (phase == phases.seed) {
            phase = phases.general;
        } else if (phase == phases.general) {
            phase = phases.open;
        } else {
            revert("ICO is in phase open");
        }
    }

    function togglePause (bool state) public onlyOwner {
        paused = state;
    }

    function addToWhitelist (address[] memory privateInvestors) external onlyOwner {
        uint i;
        for (i = 0; i < privateInvestors.length; i++) {
            whitelist[privateInvestors[i]] = true;
        }
    }

    function recieve () external payable {
        require (msg.value > 0.01 ether, "not enough ether");

        if (phase == phases.seed) {
            require(totalFunds + msg.value <= 15000 ether, "seed phase goal cannot be surpassed");
            require(whitelist[msg.sender] == true, "address not whitelisted for seed sale");
            require(balances[msg.sender] + msg.value <= 1500 ether, "amount would be more than 1500 ether contributed");
            totalFunds += msg.value;
            balances[msg.sender] += msg.value;
            if (totalFunds == 15000 ether) {
                phase = phases.general;
            }
        }

        if (phase == phases.general) {}
        if (phase == phases.open) {}
    }



}