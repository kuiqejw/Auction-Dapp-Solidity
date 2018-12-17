# Workfiles for Decentralized APP under 50.037:
## Instructions:
Download the components of the APP under Auctionv2.zip. 

## Once you have opened the APP
Open terminal and cd into it. 
Type ‘ganache-cli -p 8545 -h 0.0.0.0 q’ when inside the directory. This brings up the terminal screen with ganache running in the background. Import two of the accounts into Metamask for minimal testing.
Open a new tab in of terminal and type:
pip3 install py-solc
python3 -m solc.install v0.4.25
export PATH=$HOME/.py-solc/solc-v0.4.25/bin:$PATH
python3 server.py

## Grades for this Project: 
30/30: 
Based on:
DApp Project - final

Type 	Auction
On time 	X
Docs 	X
Code 	X
Web and UX 	X
Dynamic price 	X
Payments (tokens and/or metamask) 	X
Solidity features (modifiers, events,.. etc) 	X
Gas analysis and optimized 	X
Notes 	- confusing value in ETHs shown in the table(should be in fiat money as well)

...On second thought, maybe ETH was a better idea???

## About the Other Files?
Sorry, I haven't gotten around to deleting them that. Watch this space!
