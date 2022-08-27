//SPDX-License-Identifier: Unlicensed
pragma solidity >=0.5.0 <0.9.0;

contract EventContract {
    struct Event {
        address organizer;
        string name;
        uint256 date;
        uint256 price;
        uint256 ticketCount;
        uint256 ticketRemain;
    }

    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public nextId;

    function createEvent(
        string memory name,
        uint256 date,
        uint256 price,
        uint256 ticketCount
    ) public {
        require(
            date > block.timestamp,
            "You can oraganize event for future date"
        );
        require(
            ticketCount > 0,
            "You can oragnize event only when u create more than 100 events"
        );

        events[nextId] = Event(
            msg.sender,
            name,
            date,
            price,
            ticketCount,
            ticketCount
        ); //ticketcount twice cause initially ticketcount == ticketremain
        nextId++;
    }

    function buyTicket(uint256 id, uint256 quantity) public payable {
        require(events[id].date != 0, "This event does not exist");
        require(block.timestamp < events[id].date, "Event has already Occured");
        Event storage _event = events[id];
        require(msg.value == (_event.price * quantity), "Ether is not enough");
        require(_event.ticketRemain >= quantity, "Not Enough Tickets");
        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity; //this means the msg.sender has bought quantity of tickets of id event.
    }

    function transferTicket(
        uint256 id,
        uint256 quantity,
        address to
    ) public {
        require(events[id].date != 0, "This event does not exist");
        require(block.timestamp < events[id].date, "Event has already Occured");
        require(
            tickets[msg.sender][id] >= quantity,
            "You do not have enough tickets"
        );
        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }
}
