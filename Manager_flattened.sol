
// File: Payable.sol



pragma solidity >=0.4.22 <0.9.0;


abstract contract Payable{

    address payable owner;
    address manager;

    constructor(address payable _owner, address _manager){
        owner = _owner;
        manager = _manager;
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == manager, "Only the owner or the manager can call this function");
        _;
    }

    receive() external payable { }

    fallback() external payable { }

    function deposit() external payable { }


    function getBalance() external view ownerOnly returns (uint) {
        return address(this).balance;
    }

    function withdraw( uint _amount) external payable ownerOnly {
        require(address(this).balance >= _amount, "Insufficient funds");

        (bool success, ) = owner.call{value: _amount}("");
        
        require(success, "Failed to send Ether");

    }

    function sendTo(address payable _to, uint _amount) external payable ownerOnly {
        require(_to != address(0), "Invalid address");
        require(address(this).balance >= _amount, "Insufficient funds");

        (bool success, ) = _to.call{value: _amount}("");
        
        require(success, "Failed to send Ether");
    }



}

// File: Utils.sol



pragma solidity >=0.4.22 <0.9.0;


library Utils{

    enum ItemType{ LOYALITY_CARD, DEBIT_CARD, PASSWORD }

    function isValidItemType(uint8 _type) internal pure returns (bool) {
        return _type < uint8(ItemType.PASSWORD) + 1;
    } 

    function findIndex(address _value, address[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _value) {
                return int(i);
            }
        }
        return -1; 
    }

    function getAllItems( mapping (ItemType => address[]) storage _items) public view returns (address[][3] memory) {

        return [
            _items[ItemType.LOYALITY_CARD],
            _items[ItemType.DEBIT_CARD],
            _items[ItemType.PASSWORD]
        ];
    }

    function getItems( ItemType _type, mapping (ItemType => address[]) storage _items ) public view returns (address[] memory) {

        return _items[_type];
    }

    function deleteItem( mapping (ItemType => address[]) storage _items, ItemType _type, address _item ) public {

        int index = Utils.findIndex(_item, _items[_type]);
        require(index > -1 && index < int(_items[_type].length), "Item not found in array");

        for (uint i = uint(index); i < _items[_type].length - 1; i++) {
            _items[_type][i] = _items[_type][i + 1];
        }

        _items[_type].pop();

    }

}

// File: VaultItem.sol



pragma solidity >=0.4.22 <0.9.0;


interface VaultItem{

    event Created(address);
    event Updated(address);
    // event Deleted(address);

    function getItemType() external view returns (Utils.ItemType);

    function getParent() external view returns (address);

    function setParent( address _parent ) external;

    function getAddress() external view returns (address); 

    function setName( string memory _name ) external;

    // function duplicate( address _to) external;

}
// File: LoyalityCard.sol



pragma solidity >=0.4.22 <0.9.0;



contract LoyalityCard is VaultItem{

    string name;
    string card_id;

    address owner;
    address parent;

    Utils.ItemType item_type = Utils.ItemType.LOYALITY_CARD;

    constructor(string memory _name, string memory _card_id, address _owner, address _parent){

        name = _name;
        card_id = _card_id;
    
        owner = _owner;
        parent = _parent;

        emit Created(msg.sender);
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getItemType() external view ownerOnly returns (Utils.ItemType) {
        return item_type;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setParent( address _parnet) external  ownerOnly {
        parent = _parnet;

        emit Updated(msg.sender);
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;

        emit Updated(msg.sender);
    }

    function setCardId(string memory _card_id) external ownerOnly {
        card_id = _card_id;

        emit Updated(msg.sender);
    }

    function setItem(string memory _name, string memory _card_id) external ownerOnly {
        name = _name;
        card_id = _card_id;

        emit Updated(msg.sender);
    }


    function expose() external view ownerOnly returns ( string memory, string memory) {
        return ( name, card_id );
    }


}

// File: DebitCard.sol



pragma solidity >=0.4.22 <0.9.0;



contract DebitCard is VaultItem{

    string name;
    string card_id;
    string name_on_card;
    uint16 expire_at;
    uint16 cvv;

    address owner;
    address parent;

    Utils.ItemType item_type = Utils.ItemType.DEBIT_CARD;

    constructor(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint16 _expire_at,
        uint16 _cvv,
        address _owner,
        address _parent
        )
    {

        name = _name;
        card_id = _card_id;
        name_on_card = _name_on_card;
        expire_at = _expire_at;
        cvv = _cvv;

        owner = _owner;
        parent = _parent;

        emit Created(msg.sender);
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getItemType() external view ownerOnly returns (Utils.ItemType) {
        return item_type;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setParent( address _parent) external  ownerOnly {
        parent = _parent;

        emit Updated(msg.sender);
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;

        emit Updated(msg.sender);
    }

    function setCardId(string memory _card_id) external ownerOnly {
        card_id = _card_id;

        emit Updated(msg.sender);
    }

    function setNameOnCard(string memory _name_on_card) external ownerOnly {
        name_on_card = _name_on_card;

        emit Updated(msg.sender);
    }

    function setExpireAt(uint16 _expire_at) external ownerOnly {
        expire_at = _expire_at;

        emit Updated(msg.sender);
    }

    function setCvv(uint16 _cvv) external ownerOnly {
        cvv = _cvv;

        emit Updated(msg.sender);
    }

    function setItem(string memory _name, string memory _card_id, string memory _name_on_card, uint16 _expire_at, uint16 _cvv) external ownerOnly {

        name = _name;
        card_id = _card_id;
        name_on_card = _name_on_card;
        expire_at = _expire_at;
        cvv = _cvv;

        emit Updated(msg.sender);
    }

    function expose() external view ownerOnly returns (string memory, string memory, string memory, uint16, uint16) {
        return ( name, card_id, name_on_card, expire_at, cvv );
    }


}

// File: Password.sol



pragma solidity >=0.4.22 <0.9.0;



contract Password is VaultItem{

    string name;
    string url;
    string user_name;
    string password;

    address owner;
    address parent;

    Utils.ItemType item_type = Utils.ItemType.PASSWORD;

    constructor(string memory _name, string memory _url, string memory _user_name, string memory _password, address _owner, address _parent){

        name = _name;
        url = _url;
        user_name = _user_name;
        password = _password;
    
        owner = _owner;
        parent = _parent;

        emit Created(msg.sender);
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getItemType() external view ownerOnly returns (Utils.ItemType) {
        return item_type;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setParent( address _parnet) external  ownerOnly {
        parent = _parnet;

        emit Updated(msg.sender);
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;

        emit Updated(msg.sender);
    }

    function setUrl(string memory _url) external ownerOnly {
        url = _url;

        emit Updated(msg.sender);
    }

    function setUserName(string memory _user_name) external ownerOnly {
        user_name = _user_name;

        emit Updated(msg.sender);
    }

    function setPassword(string memory _password) external ownerOnly {
        password = _password;

        emit Updated(msg.sender);
    }

    function setItem(string memory _name, string memory _url, string memory _user_name, string memory _password) external ownerOnly {
        name = _name;
        url = _url;
        user_name = _user_name;
        password = _password;

        emit Updated(msg.sender);
    }
    

    function expose() external view ownerOnly returns ( string memory, string memory, string memory, string memory) {
        return ( name, url, user_name, password );
    }


}

// File: UserVault.sol



pragma solidity >=0.4.22 <0.9.0;






contract UserVault is Payable{


    mapping (Utils.ItemType => address[]) Items;

    constructor(address payable _owner, address _manager) Payable( _owner, _manager) {}

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getAllItems() external view ownerOnly returns (address[][3] memory) {
        return Utils.getAllItems(Items);
    }

     function getItem(Utils.ItemType _type) external view ownerOnly returns (address[] memory) {

        require(Utils.isValidItemType(uint8(_type)), "Invalid Item type");

        return Utils.getItems(_type, Items);
    }

    function createLoyalityCard(string memory _name, string memory _card_id) external ownerOnly {

        LoyalityCard card = new LoyalityCard( _name, _card_id, owner, address(this) );

        Items[Utils.ItemType.LOYALITY_CARD].push( card.getAddress() );
        
    }

    function createDebitCard(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint16 _expire_at,
        uint16 _cvv
    ) external ownerOnly {

        DebitCard card = new DebitCard( _name, _card_id, _name_on_card, _expire_at, _cvv, owner, address(this));

        Items[Utils.ItemType.DEBIT_CARD].push( card.getAddress() );
        
    }

    function createPassword(
        string memory _name,
        string memory _url,
        string memory _user_name,
        string memory _password
    ) external ownerOnly {

        Password psw = new Password( _name, _url, _user_name, _password, owner, address(this));

        Items[Utils.ItemType.PASSWORD].push( psw.getAddress() );
        
    }

    function deleteItem(Utils.ItemType _type, address _addr) external ownerOnly {

        require(Utils.isValidItemType(uint8(_type)), "Invalid Item type");
        require(_addr != address(0), "Invalid address");

        Utils.deleteItem( Items, _type, _addr );
    }


}

// File: Manager.sol



pragma solidity >=0.4.22 <0.9.0;


contract Manager{

    address owner;
    mapping (address => address) ownerToVaultMap;

    constructor(){
        owner = msg.sender;
    }

    function getVaultByOwner() external view returns (address) {

        return ownerToVaultMap[msg.sender];
    }

    function createVault() external returns (address) {

        if( ownerToVaultMap[msg.sender] == address(0) ){

            UserVault vault = new UserVault( payable(msg.sender), address(this) );
            ownerToVaultMap[msg.sender] = vault.getAddress();

        }

        return ownerToVaultMap[msg.sender];

    }


}
