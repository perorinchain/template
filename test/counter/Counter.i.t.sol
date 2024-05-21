// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {MCTest} from "@mc/devkit/MCTest.sol";
import {MCDevKit} from "@mc/devkit/MCDevKit.sol";
import {DeployLib} from "../../script/DeployLib.sol";
import {stdError} from "forge-std/StdError.sol";

import {Storage} from "bundle/counter/storage/Storage.sol";
import {ICounter} from "bundle/counter/interfaces/ICounter.sol";

contract CounterIntegrationTest is MCTest {
    using DeployLib for MCDevKit;
    ICounter public counter;

    function setUp() public {
        counter = ICounter(mc.deployCounter(0).toProxyAddress());
    }

    function test_Success(uint256 fuzzInitialNumber, uint256 fuzzNumber) public {
        counter.initialize(fuzzInitialNumber);
        assertEq(counter.getNumber(), fuzzInitialNumber);

        counter.setNumber(fuzzNumber);
        assertEq(counter.getNumber(), fuzzNumber);

        vm.assume(fuzzNumber != type(uint256).max);
        counter.increment();
        assertEq(counter.getNumber(), fuzzNumber + 1);
    }

    function test_increment_Revert_Overflow() public {
        counter.setNumber(type(uint256).max);
        vm.expectRevert(stdError.arithmeticError);
        counter.increment();

    }

}
