// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract RentalChain{
    // the person who will deploy this will be the owner
    address owner;

    constructor(){
        owner = msg.sender;
    }

    // adding yourself as a Renter
    struct Renter{
        address payable walletAddress;
        string firstName;
        string lastName;
        bool canRent;
        bool active;
        uint balance;
        uint due; // amount to pay
        uint start; // timing start time
        uint end;// timing end time
    }
    mapping (address => Renter) public renters;

    function addRenter(
        address payable walletAddress,
        string memory firstName,
        string memory lastName,
        bool canRent,
        bool active,
        uint balance,
        uint due,
        uint start,
        uint end
    )public{
         renters[walletAddress] = Renter(walletAddress, firstName, lastName, canRent, active, balance, due, start, end);
    }

    // checkout the room
    function checkOut(address walletAddress) public{
        renters[walletAddress].active = true;
        //The timestamp will in unix format
        renters[walletAddress].start = block.timestamp;
        // if a customer can rent only one room
        renters[walletAddress].canRent = false;
    }
    // checkin the room
    function checkIn(address walletAddress) public{
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;

        // TODO: set the amount due
        setDue(walletAddress);

    }
    // Get total duration of room use
    function renterTimespan(uint start, uint end) internal pure returns(uint){
        return end - start;
    }
    function getTotalDuration(address walletAddress) public view returns(uint){
        uint timespan = renterTimespan(renters[walletAddress].start,renters[walletAddress].end);
        uint timespanInMinutes = timespan / 60;
        return timespanInMinutes;

    }
    // Get Contract balance
    function balanceOf() view public returns(uint){
        return address(this).balance;
    }

    // Get Renter's balance
    function balanceOfRenter(address walletAddress) public view returns(uint){
        return renters[walletAddress].balance;
    }

    // set Due amount 
    // Here after 5 minutes you pay 2usd
    function setDue(address walletAddress) internal {
        uint timespanMinutes = getTotalDuration(walletAddress);
        uint fiveMinuteIncrements = timespanMinutes / 5;
        renters[walletAddress].due = fiveMinuteIncrements * 5000000000000000;
    }

    // can we rent it will return a boolean
    function canRentRoom(address walletAddress) public view returns(bool){
        return renters[walletAddress].canRent;
    }
     
    // Deposit 
    function deposit(address walletAddress) payable public  {
        
    }
    
    // Make payment


}