
// File: VaultItem.sol



pragma solidity >=0.4.22 <0.9.0;

interface VaultItem{

    function getParent() external view returns (address);

    // function copyTo( address _to) external;

}
// File: LoyalityCard.sol



pragma solidity >=0.4.22 <0.9.0;


contract LoyalityCard is VaultItem{

    string name;
    string card_id;

    address owner;
    address parent;

    constructor(string memory _name, string memory _card_id, address _owner, address _parent){

        name = _name;
        card_id = _card_id;
    
        owner = _owner;
        parent = _parent;
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setParent( address _parnet) external  ownerOnly {
        parent = _parnet;
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;
    }

    function setCardId(string memory _card_id) external ownerOnly {
        card_id = _card_id;
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
    string expire_at;
    uint cvv;

    address owner;
    address parent;

    constructor(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        string memory _expire_at,
        uint _cvv,
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
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setParent( address _parent) external  ownerOnly {
        parent = _parent;
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;
    }

    function setCardId(string memory _card_id) external ownerOnly {
        card_id = _card_id;
    }


    function expose() external view ownerOnly returns (string memory, string memory, string memory, string memory, uint) {
        return ( name, card_id, name_on_card, expire_at, cvv);
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

    constructor(string memory _name, string memory _url, string memory _user_name, string memory _password, address _owner, address _parent){

        name = _name;
        url = _url;
        user_name = _user_name;
        password = _password;
    
        owner = _owner;
        parent = _parent;
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only the owner can call this function");
        _;
    }

    function getAddress() external view ownerOnly returns (address) {

        return address(this);
    }

    function getParent() external view ownerOnly returns (address) {

        return parent;
    }

    function setParent( address _parnet) external  ownerOnly {
        parent = _parnet;
    }

    function setName(string memory _name) external ownerOnly {
        name = _name;
    }

    function setUrl(string memory _url) external ownerOnly {
        url = _url;
    }

    function setUserName(string memory _user_name) external ownerOnly {
        user_name = _user_name;
    }

    function setPassworde(string memory _password) external ownerOnly {
        password = _password;
    }
    

    function expose() external view ownerOnly returns ( string memory, string memory, string memory, string memory) {
        return ( name, url, user_name, password );
    }


}

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

    function findIndex(address _value, address[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _value) {
                return int(i);
            }
        }
        return -1; 
    }

    function getItems( mapping (ItemType => address[]) storage _items) public view returns (address[][3] memory) {

        return [
            _items[ItemType.LOYALITY_CARD],
            _items[ItemType.DEBIT_CARD],
            _items[ItemType.PASSWORD]
        ];
    }

    function deleteItem( mapping (ItemType => address[]) storage _items, address _item, ItemType _type) public {

        int index = Utils.findIndex(_item, _items[_type]);
        require(index > -1 && index < int(_items[_type].length), "Item not found in array");

        for (uint i = uint(index); i < _items[_type].length - 1; i++) {
            _items[_type][i] = _items[_type][i + 1];
        }

        _items[_type].pop(); 

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

    function createLoyalityCard(string memory _name, string memory _card_id) external ownerOnly {

        LoyalityCard card = new LoyalityCard( _name, _card_id, owner, address(this) );

        Items[Utils.ItemType.LOYALITY_CARD].push( card.getAddress() );
        
    }

    function createDebitCard(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        string memory _expire_at,
        uint _cvv
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


}
