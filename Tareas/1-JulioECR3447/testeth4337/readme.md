## Implementacion de la Linea ERC-3447 ETH

se trabajo con los archivos de base de OpenZepellin y Eth-Infinitism 
repositorios clave para las pruebas de rendimiento en el consumo de gas 


### archivos de base utilizados
```
	-> SimpleAccount.sol
	-> SimpleAccountFactory.sol 
```
### archivos de prueba
``` 
	-> SimpleAccount.t.sol
	-> CollectDelever.t.sol
```


## Funcionalidad de Execute en SimpleAccount

La función `execute()` es el núcleo de la funcionalidad de Account Abstraction, permitiendo:

1. Llamar a cualquier contrato desde la billetera.
2. Enviar ETH junto con las llamadas si es necesario.
3. Ejecutar múltiples transacciones en un lote a través de `executeBatch()`.
4. Interactuar con la misma cuenta para modificar su configuración.

Esta funcionalidad es esencial ya que permite que la cuenta funcione como un proxy programable, 
ejecutando cualquier operación en nombre del propietario una vez que se verifica la firma.

## Resultados de las Pruebas

```
Compiling 4 files with Solc 0.8.30
Solc 0.8.30 finished in 754.33ms                                        
Compiler run successful!                                                
                                                                        
Ran 3 tests for test/SimpleAccount.t.sol:SimpleAccountTest              
[PASS] test_CreateAccount() (gas: 171689)                               
[PASS] test_ExecuteBatchMethod() (gas: 332364)                          
[PASS] test_ExecuteDirectMethod() (gas: 325571)                         
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 1.33ms     
(1.26ms CPU time)                                                       
                                                                        
Ran 2 tests for test/CollectOnDeliverTest.t.sol:CollectOnDeliverTest    
[PASS] test_SetCollectOnDeliverByOwner() (gas: 180353)                  
[PASS] test_SetCollectOnDeliverDirectly() (gas: 176994)                 
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 1.37ms     
(667.58µs CPU time)                                                     
                                                                        
Ran 2 test suites in 11.92ms (2.70ms CPU time): 5 tests passed, 0       
failed, 0 skipped (5 total tests)
```
