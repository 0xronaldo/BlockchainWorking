// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {SimpleAccount} from "../src/SimpleAccount.sol";
import {SimpleAccountFactory} from "../src/SimpleAccountFactory.sol";
import {IEntryPoint} from "../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";




contract SimpleAccountTest is Test {
    SimpleAccountFactory public factory;
    address constant ENTRY_POINT = 0x0000000071727De22E5E9d8BAf0edAc6f37da032;
    address constant TEST_USER = address(0x123);
    
    function setUp() public {
        // llamada a la fabrica 
        factory = new SimpleAccountFactory(IEntryPoint(ENTRY_POINT));
    }

    function test_CreateAccount() public {
        // Crear una cuenta con la fábrica
        vm.startPrank(TEST_USER);
        SimpleAccount acc = factory.createAccount(TEST_USER, 123456);
        
        // verificacion de la cuenta new
        assertEq(acc.owner(), TEST_USER);
        vm.stopPrank();
    }

    function test_ExecuteDirectMethod() public {
        // ejecucion 
        vm.startPrank(TEST_USER);
        SimpleAccount acc = factory.createAccount(TEST_USER, 123456);
        
        // nuevo contador
        Counter counter = new Counter();
        
        
        bytes memory incrementCall = abi.encodeWithSignature("increment()");
        
        // ejecucion a SimpleAccount
        acc.execute(address(counter), 0, incrementCall);
        
        // contador
        assertEq(counter.number(), 1);
        
        vm.stopPrank();
    }
    
    function test_ExecuteBatchMethod() public {
        // multiples llamadas
        vm.startPrank(TEST_USER);
        SimpleAccount acc = factory.createAccount(TEST_USER, 789012);
        
        
        Counter counter = new Counter();
        
        // Creamos arrays para los parámetros de executeBatch
        address[] memory destinations = new address[](2);
        destinations[0] = address(counter);
        destinations[1] = address(counter);
        
        bytes[] memory datas = new bytes[](2);
        datas[0] = abi.encodeWithSignature("increment()");
        datas[1] = abi.encodeWithSignature("setNumber(uint256)", 10);
        
        uint256[] memory values = new uint256[](2);
        values[0] = 0;
        values[1] = 0;
        
        // Ejecutar el lote de llamadas
        acc.executeBatch(destinations, values, datas);
        
        // Verificar que el número se estableció a 10 (la última operación)
        assertEq(counter.number(), 10);
        
        vm.stopPrank();
    }
}



contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number += 1;
    }
}
