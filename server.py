import json

from flask import Flask, render_template

from web3.auto import w3
from solc import compile_source
from web3.contract import ConciseContract

app = Flask(__name__)


contract_source_code = None
contract_source_code_file = 'Auction.sol'

with open(contract_source_code_file, 'r') as file:
    contract_source_code = file.read()


contract_compiled = compile_source(contract_source_code)
contract_interface = contract_compiled['<stdin>:Auction']
Auction = w3.eth.contract(abi=contract_interface['abi'], 
                          bytecode=contract_interface['bin'])

w3.personal.unlockAccount(w3.eth.accounts[0], '')
tx_hash = Auction.constructor(w3.eth.accounts[0]).transact({'from':w3.eth.accounts[0],})
tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)

# Contract Object
lottery = w3.eth.contract(address=tx_receipt.contractAddress, abi=contract_interface['abi'])

# Web service initialization
@app.route('/')
@app.route('/index')
def hello():
    return render_template('template.html', contractAddress = lottery.address.lower(), contractABI = json.dumps(contract_interface['abi']))

if __name__ == '__main__':
    app.run()
