pragma solidity ^0.4.25;

contract AuctionHouse{
    //static owner of the contract
    address public owner;

    struct Item {
        address itemOwner;
        string  itemDesc;
        uint auctionEnd;
        address  maxBidder;
        uint maxBid;
        //state
        bool ended;
        bool ownerHasWithdrawn;
        //Allowed withdrawals of previous bids
        //cancelled?
        //bool public cancelled;
    }
    
   
    //time implemented if  possible
    uint time;


    mapping(address => Item[]) list;
   
    constructor() public {
        time = now;
    }
   // our setter in this case
    function create(string _n) public {
        Item i;
        i.itemDesc = _n;
        Item[] storage _l = list[msg.sender];
        _l.push(i);
    }
   //our getter in this case
    function get(uint ix) public view returns(string) {
        //note that ix is the index of the variable
        string name = list[msg.sender][ix].itemDesc;
        return name;
    }

   
}