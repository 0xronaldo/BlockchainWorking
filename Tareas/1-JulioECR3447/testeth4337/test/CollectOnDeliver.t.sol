// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {SimpleAccount} from "../src/SimpleAccount.sol";
import {SimpleAccountFactory} from "../src/SimpleAccountFactory.sol";
import {IEntryPoint} from "../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract CollectOnDeliverTest is Test {
    SimpleAccountFactory public factory;
    address constant ENTRY_POINT = 0x0000000071727De22E5E9d8BAf0edAc6f37da032;
    
    function setUp() public {
        // Crear la fábrica utilizando la dirección del EntryPoint predefinida
        factory = new SimpleAccountFactory(IEntryPoint(ENTRY_POINT));
    }

    function test_SetCollectOnDeliverDirectly() public {
        //for onlyOwner calls, startPrank is needed
        vm.startPrank(address(0x123));
        SimpleAccount acc = factory.createAccount(address(0x123), 123456);

        assertEq(acc.letCollectOnDeliver(), false);
        //direct call is possible, but not usual
        acc.setCollectOnDeliver(true);
        assertEq(acc.letCollectOnDeliver(), true);
        vm.stopPrank();
    }

    function test_SetCollectOnDeliverByOwner() public {
        vm.startPrank(address(0x123));
        SimpleAccount acc = factory.createAccount(address(0x123), 123456);

        assertEq(acc.letCollectOnDeliver(), false);

        //encode the function and the parameter
        bytes memory func = abi.encodeWithSignature("setCollectOnDeliver(bool)", true);
        //call execute with the same contract address, 0 value, and the encoded func
        acc.execute(address(acc), 0, func);

        assertEq(acc.letCollectOnDeliver(), true);
        vm.stopPrank();
    }
}
