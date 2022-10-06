//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Store {
  
  // Events
  event itemAddedEvent(uint _id, string _name, uint256 _price, address _buyer);
  event itemRemovedEvent(uint _id, string _name, uint256 _price, address _buyer);
  event itemBoughtEvent(uint _id, string _name, uint256 _price, address _buyer);
  
    address payable owner;

    constructor(){                 
        owner = payable(msg.sender);      
    } 

  modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    } 
  
  struct Item { 
    uint id; 
    string name;
    uint256 price;
    address buyer;
    bool issold;
    bool isremoved;
    //be accesible by the getItem endpoint.
   }
  uint256 _id =1;
  Item[] items;


  
  
  // Endpoints
  function addItem(string memory _name, uint256 _price)  public  onlyOwner {

    require(_price>0,"Item price must be greate than zero");
    
    items.push(Item(_id,_name,_price,address(0),false,false));
    emit itemAddedEvent(_id,_name,_price, address(0));

    _id++;
  }
  
  function removeItem(uint __id) public onlyOwner {
      require(!items[__id-1].issold,"item has been already sold! ");
      items[__id-1].isremoved = true;
      items[__id-1].price = 0;
      emit itemRemovedEvent(__id, items[__id-1].name,items[__id-1].price, items[__id-1].buyer);


  }
  
  function buyItem(uint __id) payable public {
      require(items[__id-1].id<=__id,"id is not valid");
      require(msg.sender != owner,"you are already owner of this item");
      require(items[__id-1].issold ==false,"aiready sold!");
      require(items[__id-1].price == msg.value,"you must use exact price");
      
      items[__id-1].buyer = msg.sender;
      owner.transfer(items[__id-1].price);

    emit itemBoughtEvent(__id, items[__id-1].name, items[__id-1].price, items[__id-1].buyer);

  }
  
  function getItem(uint __id)  public view returns(uint id, string memory name, uint256 price, address buyer){

    return (items[__id-1].id,items[__id-1].name,items[__id-1].price,items[__id-1].buyer);
  }
}