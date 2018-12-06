'''
Once Ganache is installed, run its GUI or execute the following command:
$ ganache-cli -p 8545 -h 0.0.0.0 -n
'''

from solc import compile_source
from web3.auto import w3

contract_source_code = None
contract_source_code_file = 'Auction.sol'

with open(contract_source_code_file, 'r') as file:
    contract_source_code = file.read()

# Compile the contract
contract_compiled = compile_source(contract_source_code)
contract_interface = contract_compiled['<stdin>:TimerAuction']

# Set the default account
w3.eth.defaultAccount = w3.eth.accounts[0]
w3.personal.unlockAccount(w3.eth.defaultAccount,"",1000)
# Contract abstraction
Example = w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_interface['bin'])

# Create an instance, i.e., deploy on the blockchain
tx_hash = Example.constructor("hello string").transact()
tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)

# Contract Object
example = w3.eth.contract(address=tx_receipt.contractAddress, abi=contract_interface['abi'])

#print('Calling contracts functions')
print('Contract address: ', example.address)
transaction_object = {"value":w3.toWei(1,'ether')}
tx_hashA = example.functions.bid().transact(transaction_object)
print(w3.eth.getTransaction(tx_hashA))
print(w3.eth.waitForTransactionReceipt(tx_hashA))
#print('obj.getTransaction,', w3.eth.getTransaction('0x175cd54220801379acf6adfc7e975f3da9a5ecdba22f74cfdb11483c2b5383e9'))
#print('obj. get default block', w3.eth.defaultBlock)
#print('obj. get conversion', w3.toWei)

#transaction_object = {"from":w3.eth.accounts[0],"to":w3.eth.accounts[1],
#"value":1}

#w3.eth.sendTransaction(transaction_object)