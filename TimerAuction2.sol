pragma solidity ^0.4.25;

contract TimerAuction{
    //static 
    address public owner;
    string public itemDesc;
    uint public auctionEnd;
    
    //state
    address public maxBidder;
    address public prevMaxBidder;
    uint public maxBid;
    bool public ended;
    bool public ownerHasWithdrawn;
    //Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;
    
    //cancelled?
    bool public cancelled;
    
    
    constructor( string _itemDesc) public{
        owner = msg.sender;
        itemDesc = _itemDesc;
        //auctionEnd = now + (_durationMinutes * 1 minutes);
    }
    
    function getHighestBid() constant public returns(uint) {
        return pendingReturns[maxBidder];
    }
    
    function getHighestBidder() view public returns(address){
        return maxBidder;
    }
    function bid() public payable returns(uint){
        //require(now > auctionEnd, "Auction is closed");
        require(msg.value >= 0, 'Your bid has to be higher than 0');
        //if all the requirements above are satisfied then we invoke this

        //total bid = current amount that they've sent to the contract plus whatever has been sent with this transaction
        uint newBid = pendingReturns[msg.sender] + msg.value;
        require(newBid > maxBid, "Sorry, your bid value is too little!");
        if(msg.sender != maxBidder){ 
            prevMaxBidder = maxBidder;
            pendingReturns[msg.sender] = newBid;
            maxBidder = msg.sender;
            maxBid = newBid;
        }
        //get the new value of maxBid to be bid_value
        return newBid;
    }
    
    function withdraw() public returns (bool, uint) {
        uint amount = pendingReturns[msg.sender];
        uint maxBid1;
        address maxBidder1;
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            
            pendingReturns[msg.sender] = 0;
            if(amount == maxBid){
                maxBidder1 = prevMaxBidder;
                maxBid1 = pendingReturns[maxBidder1];
            }
            if (!msg.sender.send(amount)) {
                // No need to call throw here, just reset the amount owing
                pendingReturns[msg.sender] = amount;
                return (false,maxBid);
            }
        }
        maxBidder = maxBidder1;
        maxBid = maxBid1;
        return (true, maxBid);
    
    }
    function cancelAuction() public returns (bool) {
        require(msg.sender == owner);
        require(!ended);
        require(!cancelled);
        //require(now >= auctionEnd);
        cancelled = true;
        return true;
        
    }
    
    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }
    function end() ownerOnly external {
        require(!ended);
        require(!cancelled);
        //require(now >= auctionEnd);
        
        ended = true;
        
        owner.transfer(maxBid);
    }
}
