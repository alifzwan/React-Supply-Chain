// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SupplyChain {

     address public Creator;  // msg.sender - whoever deploy this contract (creator)

     constructor(){
        Creator = msg.sender;
    }

    /* MODIFIER
      
      Notes: https://solidity-by-example.org/function-modifier/

      - Let's say that there's a lot of function that we want it to be only can be access by Owner

      - Normaly we add this line:
        require(msg.sender == owner, "Sender is not owner!");

      - However, we dont want this line to be in all function right?

      - That's where Modifier comes in.


      The " _; "
      - If you put it under, it will tell the function to do the modifier first
      - If you put it above, it will tell the function to do the function first 
       */
    modifier onlyCreator() {   // This modifier is to esatblish certain function that can only be run by Creator
        require(msg.sender == Creator , "Not owner");  
        _;
    }

    /* Supply Chain Flow

            Farmer ---> Manufacturer ---> Distributor --> Retailer


        Farmer       - This is where the Manufacturer get their raw material 

        Manufacturer - Several manufacture will process the raw material 

        Distributor  - This is where we distribute the processed item to numerous store

        Supermarket  - Jaya Grocer for example will receive the processed item from the distributor and will be sold
                       in the store 


        Objectives:

        - Develop decentralized food supply chain management that implementing blockchain technology, smart contract and consensus algorithm 
          which could monitor food quality and safety resulting in improvement on traceability, transparency of food products.       

        - Enable real-time surveillance and monitoring of food product, providing stakeholder with accurate information about quality, 
          safety and origin of the product.


        3 Functions:
        - Register each flow
        - Adding items to the chain
        - Track the items                   

     */

    
    // Establish count for each flow 
    uint256 public itemsCount = 0;
    uint256 public farmerCount = 0;
    uint256 public manufacturerCount = 0;
    uint256 public distributorCount = 0;
    uint256 public retailerCount = 0;


    

     /* ENUM
        
        Notes: https://solidity-by-example.org/enum/

        - Enum is user-defined data type that allows you to define a set of named values. 
        - Enums are often used when you have a fixed set of values that a variable can take.

        - Let's say you're making a game about different animals. 
        - You might want to keep track of what kind of animal a player has chosen. 
        - You could use an enum to do this. 

        Example: 

        contract AnimalGame {
            enum Animal { Dog, Cat, Bird, Fish }

            Animal public player1Choice;
            Animal public player2Choice;

            function player1ChooseDog() public {
                player1Choice = Animal.Dog;
            }

            function player1ChooseCat() public {
                player1Choice = Animal.Cat;
            }

            function player2ChooseBird() public {
                player2Choice = Animal.Bird;
            }

            function player2ChooseFish() public {
                player2Choice = Animal.Fish;
            }
        }

        - In this example, we have a game where two players can choose between four different animals: Dog, Cat, Bird, and Fish. We use an enum called Animal to define these options.

        - The AnimalGame contract has two variables, player1Choice and player2Choice, to keep track of the choices made by the players. 
        - We also have functions like player1ChooseDog, player1ChooseCat, player2ChooseBird, and player2ChooseFish to allow the players to make their choices.
      */

     /* PHASE
        The Phase is going to be like this:-

        Order ==> Farmer ==> Manufacturer ==> Distributor ==> Retailer ==> Sold

        - 1) Item Ordered                     (Plugin)
        - 2) Item are collected by Farmer     (Farmer)
        - 3) Item are being manufactured      (Manufacturer)
        - 4) Item are being Distribute        (Distribution)
        - 5) Item are safely arrived at store (Retail)
        - 6) Item sold                        (Sold)

        */


    
    
    enum PHASE {   
        Plugin,
        Farmer,
        Manufacturer,
        Distribution,
        Retail,
        Sold
    }

    
    /* STRUCT 

        Notes: https://www.tutorialspoint.com/solidity/solidity_structs.htm

        - Structs are used to group variables of different data types under a single name

        - Struct also are used to represent a record

        - Suppose you want to keep track of your books in a library. You might want to track the following attributes about each book

        -> Title
        -> Author
        -> Subject
        -> Book ID

        struct Book { 
            string title;
            string author;
            string subject;
            uint256 book_id;

        }
        mapping(uint256 => Book) public BookInfo;

     */

    struct items {

        // Items Attributes
        uint256 id;
        string name;
        string categories;
        string brand;
        string origin;
        string nutritionInfo;

        // Id of the Admin that going to process the items
        uint256 farmerId;  
        uint256 manufacturerId;
        uint256 distributorId;
        uint256 retailerId;

        
        PHASE chronology; // The item chronology
    }

    mapping(uint256 => items) public ItemsInfo;   //mapping is like you stuff everything into 1 variable.


    function Chronology(
        uint256 _itemID
    ) public view returns (string memory) {

        require(_itemID > 0);  // Ensure that the provided item ID is valid (greater than 0) well which is you have to order item first

        // Check the current phase of the item using its ID
        if (ItemsInfo[_itemID].chronology == PHASE.Plugin)
            return "Your item is already Ordered. Please wait for further processes.";
        else if (ItemsInfo[_itemID].chronology == PHASE.Farmer)
            return "Your item is being collected by the farmers. Please wait for further processes.";     
        else if (ItemsInfo[_itemID].chronology == PHASE.Manufacturer)
            return "Your item is being manufactured. Please wait for further processes.";  
        else if (ItemsInfo[_itemID].chronology == PHASE.Distribution)
            return "Your item is being distributed. Please wait for further processes.";  
        else if (ItemsInfo[_itemID].chronology == PHASE.Retail)
            return "Your item is safely at the store.";  
        else if (ItemsInfo[_itemID].chronology == PHASE.Sold)
            return "Your item is already sold.";  

        return "Unknown item chronology";
    }


    /* MAPPING

        Notes: https://www.tutorialspoint.com/solidity/solidity_mappings.htm

        - It's like storing a state variable
        - string items = "meat"

        However, in this case we store a struct:

            mapping(uint256 => farmer) public myFarmer

        We store struct "farmer" into the myFarmer that will be used in the future

     */


    struct farmer {
        address addr;
        uint256 id;
        string name; 
        string location; 
    }

    mapping(uint256 => farmer) public farmerInfo;  // You can call this variable and it'll show all the admin's attributes


    struct manufacturer {
        address addr;
        uint256 id;
        string name; 
        string location; 
    }

    mapping(uint256 => manufacturer) public manufacturerInfo;
   

    struct distributor {
        address addr;
        uint256 id;
        string name; 
        string location;
    }

    mapping(uint256 => distributor) public distributorInfo;


    struct retailer{
        address addr;
        uint256 id; 
        string name; 
        string location; 
    }

    mapping(uint256 => retailer) public retailerInfo;



    /*-----------------Register Each Flow----------------------
     Farmer ---> Manufacturer ---> Distributor --> Retailer


        Farmer       - This is where the Manufacturer get their raw material 

        Manufacturer - Several manufacture will process the raw material 

        Distributor  - This is where we distribute the processed item to numerous store

        Supermarket  - Jaya Grocer for example will receive the processed item from the distributor and will be sold
                       in the store 



        OnlyOwner:                       
        - So the onlyOwner is to make sure only Owner can register the flow
        - This ensure that the system is secure and being handled by authorize person

        The count will increase. The Owner will register 3 attributes occupied with the flow.





     */

    /* Data Location

        Notes: https://solidity-by-example.org/data-locations/

        Variables are declared as either storage, memory or calldata to explicitly specify the location of the data.

        storage  - variable is a state variable (store on blockchain)
        memory   - variable is in memory and it exists while a function is being called
        calldata - special data location that contains function arguments


     */
    /* Underscore in function's attributes

        - In Solidity, using an underscore before a parameter name, like "address _address", 
          is a common convention to distinguish between function parameters and state variables. 

        - This convention helps avoid naming conflicts and makes the code more readable.
     */


    function regFarmer(
        address _address,  // This is wallet address 
        string memory _name,  // Name of the farmer
        string memory _location  // Where's the farmer based in?
    ) public onlyCreator {  // Only creator/owner can register all the admin
        farmerCount++;
        farmerInfo[farmerCount] = farmer(_address, farmerCount, _name, _location);  // All this attributes will be stored in farmerInfo
    }


    function regManufacturer(
        address _address,
        string memory _name,
        string memory _location
    ) public onlyCreator {
        manufacturerCount++;
        manufacturerInfo[manufacturerCount] = manufacturer(_address, manufacturerCount, _name, _location);  // All this attributes will be stored in manufacturerInfo
    }
    


    function regDistributor(
        address _address,
        string memory _name,
        string memory _location
    ) public onlyCreator {
        distributorCount++;
        distributorInfo[distributorCount] = distributor(_address, distributorCount, _name, _location); // All this attributes will be stored in distributorInfo
    }

     //To add retailer. Only contract owner can add a new retailer
    function regRetailer(
        address _address,
        string memory _name,
        string memory _location
    ) public onlyCreator {
        retailerCount++;
        retailerInfo[retailerCount] = retailer(_address, retailerCount, _name, _location); // All this attributes will be stored in retailerInfo
    }



    /*-----------------Ordering----------------------
      
     So the function will going to consists with approximately 3 attributes (Well for now):
        => Origin - Where this items come from
        => Nutrition Information - net weight, how many carbs, fat, sodium , and etc
        => Name - Mister Potato
        => Brand - Mamee
        => Categories - Snacks 
        => As well as the id of each flow since we going to track the
           progress of food items through the supply chain.

     function orderItems{
        string name
        string categories
        string brand
        string origin 
        string nutritionInfo
    
        uint256 id
        uint256 farmerId
        uint256 manufacturerId
        uint256 distributorId
        uint256 retailerId

     }

     struct items{
         uint256 Id;
         string name;
         string categories;
         string brand;
         string origin;
         string nutritionInfo;
        
         uint256 farmerId;
         uint256 manufacturerId;
         uint256 distributorId;
         uint256 retailerId;
         PHASE chronology;
     } 
     */

    function orderItems(
        string memory _name,
        string memory _categories,
        string memory _brand,
        string memory _origin,
        string memory _nutritionInfo

    ) public onlyCreator {
        require((farmerCount > 0) && (manufacturerCount > 0) && (distributorCount > 0) && (retailerCount > 0));   // Before order, Creator have to register all the admin
        itemsCount++;
        ItemsInfo[itemsCount] = items(itemsCount, _name, _categories, _brand, _origin, _nutritionInfo, 0, 0, 0, 0, PHASE.Plugin); // All this attributes will be stored in ItemsInfo
    }  



    /*-----------------Administration------------------

     Admin is where each admin of the flow establish the status of item.

     Alright let's give an example:

     - Let's say we already ordered an item. It PHASE would be "Ordered"
     - So to change the PHASE from Ordered-to-Farmer, The farmer have to established the status of the item
     - So Farmer will establish the item as their responsibility

     The Flow is going to be like this:-

     Farmer ==> Manufacturer ==> Distributor ==> Retailer 

     - 1) Item Ordered                     (Plugin)
     - 2) Item are collected by Farmer     (Farmer)
     - 3) Item are being manufactured      (Manufacturer)
     - 4) Item are being Distribute        (Distribution)
     - 5) Item are safely arrived at store (Retail)
     - 6) Item sold                        (Sold)


     */

    


    /* ----------------Tracking------------------
      
     The Flow is going to be like this:-

     Farmer ==> Manufacturer ==> Distributor ==> Retailer 
    
     We going to track the items through Supply Chain

     uint256 public farmerCount = 0;
     uint256 public manufacturerCount = 0;
     uint256 public distributorCount = 0;
     uint256 public retailerCount = 0;
     uint256 public itemsCount = 0;

     struct items{
        uint256 Id;
        string name;
        string categories;
        string brand;
        string origin;
        string nutritionInfo;

        uint256 farmerId;
        uint256 manufacturerId;
        uint256 distributorId;
        uint256 retailerId;
        PHASE chronology;
     } 

     enum PHASE{
        Plugin,  
        Farmer,
        Manufacturer,
        Distribution,
        Retail,
        Sold
     }
     */

    // To change the flow from Ordered ==> Farmer
    function Farmering(uint256 _itemID) public {
        require(_itemID > 0 && _itemID <= itemsCount);          // Ensure that we already order an Item and  
        uint256 _id = trackFarmer(msg.sender);                  // Get the ID of the calling farmer
        require(_id > 0);                                       // Ensure the farmer ID is valid
        require(ItemsInfo[_itemID].chronology == PHASE.Plugin); // Ensure the item is in the Plugin phase
        ItemsInfo[_itemID].farmerId = _id;                      // Assign the farmer ID to the item
        ItemsInfo[_itemID].chronology = PHASE.Farmer;           // Update the item's chronology to Farmer
    }

    // To track 
    function trackFarmer(address _address) private view returns (uint256) {
        require(farmerCount > 0);                                       // Ensure that there is at least one registered farmer

        for (uint256 i = 1; i <= farmerCount; i++) {
            if (farmerInfo[i].addr == _address)   // Ensure that farmer's address same with the farmer's address that we registered 
            return farmerInfo[i].id;              // if all went well, it'll return ID
        }
        return 0;

    }

    // To change the flow from Farmer ==> Manufacturer
    function Manufacturing(uint256 _itemID) public {
        require(_itemID > 0 && _itemID <= itemsCount);
        uint256 _id = trackManufacture(msg.sender);
        require(_id > 0);
        require(ItemsInfo[_itemID].chronology == PHASE.Farmer);
        ItemsInfo[_itemID].manufacturerId = _id;
        ItemsInfo[_itemID].chronology = PHASE.Manufacturer;
    }

    // To track 
    function trackManufacture(address _address) private view returns (uint256) {
        require(manufacturerCount > 0);
        for (uint256 i = 1; i <= manufacturerCount; i++) {
            if (manufacturerInfo[i].addr == _address) 
            return manufacturerInfo[i].id;
        }
        return 0;
    }



    // To change the flow from Manufacturer ==> Distributor
    function Distributing(uint256 _itemID) public {
        require(_itemID > 0 && _itemID <= itemsCount);
        uint256 _id = trackDistribution(msg.sender);
        require(_id > 0);
        require(ItemsInfo[_itemID].chronology == PHASE.Manufacturer);
        ItemsInfo[_itemID].distributorId = _id;
        ItemsInfo[_itemID].chronology = PHASE.Distribution;
    }

    // To track 
    function trackDistribution(address _address) private view returns (uint256) {
        require(distributorCount > 0);
        for (uint256 i = 1; i <= distributorCount; i++) {
            if (distributorInfo[i].addr == _address) 
            return distributorInfo[i].id;
        }
        return 0;
    }


    // To change the flow from Distributor ==> Retail
    function Retailing(uint256 _itemID) public {
        require(_itemID > 0 && _itemID <= itemsCount);
        uint256 _id = trackRetailer(msg.sender);
        require(_id > 0);
        require(ItemsInfo[_itemID].chronology == PHASE.Distribution);
        ItemsInfo[_itemID].retailerId = _id;
        ItemsInfo[_itemID].chronology = PHASE.Retail;
    }

    // To track 
    function trackRetailer(address _address) private view returns (uint256) {
        require(retailerCount > 0);
        for (uint256 i = 1; i <= retailerCount; i++) {
            if (retailerInfo[i].addr == _address) 
            return retailerInfo[i].id;
        }
        return 0;
    }

    // To change the flow from Retail ==> Sold
    function sold(uint256 _itemID) public {
        require(_itemID > 0 && _itemID <= itemsCount);
        uint256 _id = trackRetailer(msg.sender);
        require(_id > 0);
        require(_id == ItemsInfo[_itemID].retailerId); //Only correct retailer can mark medicine as sold
        require(ItemsInfo[_itemID].chronology == PHASE.Retail);
        ItemsInfo[_itemID].chronology = PHASE.Sold;
    }

}