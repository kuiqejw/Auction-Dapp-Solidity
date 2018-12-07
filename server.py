import json

from flask import Flask, render_template

from web3.auto import w3
from solc import compile_source
from web3.contract import ConciseContract
from flask_httpauth import HTTPBasicAuth

class User:
	def __init__(self):
		self.contract_abi = []
		self.contract_address = []
		self.list_of_items = 0
		self.id = ""
	def new_contract(self, _contract_abi, _contract_address):
		self.contract_abi.append(_contract_abi)
		self.contract_address.append(_contract_address)
		self.list_of_items = len(self.contract_address)

#global mapping of user addresses to user classes
user_db = {'Anon': User()}



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
	global db
    return render_template('template.html', contractAddress = lottery.address.lower(), contractABI = json.dumps(contract_interface['abi']))

@app.route('/create')
def create():
	global db
	return render_template('create.html')


if __name__ == '__main__':
    app.run()
