'''
Once Ganache is installed, run its GUI or execute the following command:
$ ganache-cli -p 8545 -h 0.0.0.0 -n
'''

from solc import compile_source
from web3.auto import w3



contract_source_code = None
contract_source_code_file = 'Auction3.sol'

with open(contract_source_code_file, 'r') as file:
    contract_source_code = file.read()

# Compile the contract
contract_compiled = compile_source(contract_source_code)
contract_interface = contract_compiled['<stdin>:AuctionHouse']

# Set the default account
w3.eth.defaultAccount = w3.eth.accounts[0]
w3.personal.unlockAccount(w3.eth.defaultAccount,"",1000)
w3.personal.unlockAccount(w3.eth.accounts[1],"",1000)
# Contract abstraction
Example = w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_interface['bin'])

# Create an instance, i.e., deploy on the blockchain
tx_hash = Example.constructor().transact()
tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)

# Contract Object
example = w3.eth.contract(address=tx_receipt.contractAddress, abi=contract_interface['abi'])

#print('Calling contracts functions')
print('Contract address: ', example.address)
#transaction_object = {"value":w3.toWei(1,'ether')}
tx_hashA = example.functions.create('hello').transact()
print(tx_hashA)


tx_hashB = example.functions.get(0).transact()
print(tx_hashB)
#tx_hashB = example.functions.withdraw().transact()
#print(w3.eth.getTransaction(tx_hashB))
#tx_hashC = example.functions.getHighestBidder().call()
#print(tx_hashC)
#tx_hashD = example.functions.getHighestBid().call()
#print(tx_hashD)
'''
transaction_object = {"from":w3.eth.accounts[1],"value":w3.toWei(2,'ether')}
tx_hashA = example.functions.bid().transact(transaction_object)
print(tx_hashA)
tx_hashC = example.functions.getHighestBidder().call()
print(tx_hashC)

transaction_object = {"from":w3.eth.accounts[1]}
tx_hashE = example.functions.withdraw().call()
print(tx_hashE)'''