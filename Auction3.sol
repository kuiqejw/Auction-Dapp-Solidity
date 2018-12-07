pragma solidity ^0.4.25;

contract AuctionHouse{
    //static owner of the contract
    address public owner;
    uint256 idGenerator;

    struct Item {
        address itemOwner;
        string  itemDesc;
        uint auctionEnd;
        address  maxBidder;
        uint maxBid;
        //state
        bool ended;
        bool ownerHasWithdrawn;
        mapping(address => uint) pendingWithdrawal;
        //Allowed withdrawals of previous bids
        //cancelled?
        bool cancelled;
    }
    
   
    //time implemented if  possible
    uint time;

    //treat this for reference for the user
    //mapping(address => Item[]) list;
    mapping(uint256 => Item) idList;
   
    constructor() public {
        time = now;
        owner = msg.sender;
    }
   // our setter in this case
    function create(string _n) public returns(uint) {
        Item memory i;
        i.itemDesc = _n;
        i.itemOwner = msg.sender;
        //Item[] storage _l = list[msg.sender];
        //_l.push(i);
        idGenerator += 1;
        idList[idGenerator] = i;
        return idGenerator;
    }
   //our getter in this case
    function getName(uint ix) public view returns(string) {
        //note that ix is the index of the variable
        return idList[ix].itemDesc;
    }
    function getmaxBid(uint ix) public view returns(uint){
        uint maxBid = idList[ix].maxBid;
        return maxBid;
    }
    function getmaxBidder(uint ix) public view returns(address){
        address maxBidder = idList[ix].maxBidder;
        return maxBidder;
    }
    function getOwner(uint ix) public view returns(address){
        return idList[ix].itemOwner;
    }
    function bid(uint uniq_id) public payable returns(uint){
        require(msg.value>= 0);
        require(msg.sender != idList[uniq_id].itemOwner);
        //if all the requirements above are satisfied then we invoke this
        Item storage i;
        //total bid = current amount that they've sent to the contract plus whatever has been sent with this transaction
        i = idList[uniq_id];
        uint newBid = msg.value;
        require(newBid > i.maxBid, "Sorry, your bid value is too little!");
        if(msg.sender != i.maxBidder){//why are you paying more?
            i.maxBidder = msg.sender;
            i.maxBid = newBid;
        }
        //get the new value of maxBid to be bid_value
        idList[uniq_id] = i;
        return newBid;
    }
    //returns cash upon successful bid; based off withdrawal design patterns in readthedocs
    function withdraw(uint uniq_id) public returns(string){
        Item storage i;
        i = idList[uniq_id];
        uint amount  = i.pendingWithdrawal[msg.sender];
        i.pendingWithdrawal[msg.sender] = 0;
        if (!msg.sender.send(amount)){
            i.pendingWithdrawal[msg.sender] = amount;
            return "false";
        }
        idList[uniq_id] = i;
        return "true";
        
    }
    function endAuction(uint uniq_id) public {
        Item memory i;
        i = idList[uniq_id];
        require(msg.sender == idList[uniq_id].itemOwner,"You cannot end the auction if you are not the owner");
        require(!i.cancelled, "This auction has been cancelled with penalty. You can't end it!");
        require(!i.ended, "this auction has already ended. ");
        i = idList[uniq_id];
        i.ended = true;
        msg.sender.transfer(i.maxBid);
    }
    function cancelAuction (uint uniq_id) public payable{
        //you need to pay a penalty if you want to cancel before the auction ends!
        Item memory i;
        i = idList[uniq_id];
        require(msg.sender == idList[uniq_id].itemOwner,"You cannot end the auction if you are not the owner");
        require(!i.cancelled, "This auction has been cancelled with penalty. You can't end it!");
        require(!i.ended, "this auction has already ended. ");
        i = idList[uniq_id];
        i.ended = true;
        i.maxBidder.transfer(i.maxBid);
        
        
    }

   
}
