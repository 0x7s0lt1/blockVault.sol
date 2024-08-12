
// File: Libs/Constants.sol



pragma solidity >=0.4.22 <0.9.0;


library Constants{

    enum ItemType{ LOYALITY_CARD, DEBIT_CARD, PASSWORD }


    function isValidItemType(uint8 _type) internal pure returns (bool) {
        return _type < uint8(ItemType.PASSWORD) + 1;
    }

    function findAddressIndex(address _addr, address[] memory _a) internal pure returns (int) {
        for (uint i = 0; i < _a.length; i++) {
            if (_a[i] == _addr) return int(i);
        }
        return -1; 
    } 

    function deleteAddressFrom(int idx, address[] storage _a) internal {
        require(idx >= 0 && uint(idx) < _a.length, "Out of range");
        for (uint i = uint(idx); i < _a.length - 1; i++) {
                    _a[i] = _a[i + 1];
        }

        _a.pop();
    }

}

// File: Interfaces/Item.sol



pragma solidity >=0.4.22 <0.9.0;


interface Item{

    event Created(address);
    event Updated(address);
    event AddedToOrganisation(address);
    event RemovedFromOrganisation(address);
    // event Deleted(address);

    function getItemType() external view returns (Constants.ItemType);

    function getParent() external view returns (address);

    function setParent( address _parent ) external;

    function setName( string memory _name ) external;

    // function addToOrganisation(address _org ) external;
    // function removeFromOrganisation(address _org) external;

    // function duplicate( address _to) external;

}
// File: Items/VaultItem.sol



pragma solidity >=0.4.22 <0.9.0;



abstract contract VaultItem is Item{

    string name;
    Constants.ItemType item_type;

    address owner;
    address parent;


    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only owner");
        _;
    }

    constructor(
        string memory _name,
        Constants.ItemType _item_type,
        address _owner,
        address _parent
    ){
        name = _name;
        item_type = _item_type;

        owner = _owner;
        parent = _parent;
    }

    function getItemType() external view ownerOnly returns (Constants.ItemType) {
        return item_type;
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




}

// File: Items/LoyalityCard.sol



pragma solidity >=0.4.22 <0.9.0;



contract LoyalityCard is VaultItem{

    string card_id;

    constructor(
        string memory _name,
        string memory _card_id,
        address _owner,
        address _parent
    ) VaultItem( 
        _name,
        Constants.ItemType.LOYALITY_CARD,
        _owner,
        _parent
    ){

        card_id = _card_id;
    
        owner = _owner;
        parent = _parent;

        emit Created(msg.sender);
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

// File: Items/DebitCard.sol



pragma solidity >=0.4.22 <0.9.0;



contract DebitCard is VaultItem{

    string card_id;
    string name_on_card;
    uint16 expire_at;
    uint16 cvv;

    constructor(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint16 _expire_at,
        uint16 _cvv,
        address _owner,
        address _parent
    ) VaultItem(
        _name,
        Constants.ItemType.DEBIT_CARD,
        _owner,
        _parent
    ){

        card_id = _card_id;
        name_on_card = _name_on_card;
        expire_at = _expire_at;
        cvv = _cvv;

        emit Created(msg.sender);
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

    function setItem(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint16 _expire_at, uint16 _cvv
    ) external ownerOnly {

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

// File: Items/Password.sol



pragma solidity >=0.4.22 <0.9.0;



contract Password is VaultItem{

    string url;
    string user_name;
    string password;

    constructor(
        string memory _name,
        string memory _url,
        string memory _user_name,
        string memory _password,
        address _owner,
        address _parent
    ) VaultItem(
        _name,
        Constants.ItemType.PASSWORD,
        _owner,
        _parent
    ){

        url = _url;
        user_name = _user_name;
        password = _password;

        emit Created(msg.sender);
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

    function setItem(
        string memory _name,
        string memory _url,
        string memory _user_name,
        string memory _password
    ) external ownerOnly {
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

// File: Libs/VaultUtils.sol



pragma solidity >=0.4.22 <0.9.0;


library VaultUtils{


    function getItems( Constants.ItemType _type, mapping (Constants.ItemType => address[]) storage _items ) public view returns (address[] memory) {

        return _items[_type];
    }

    function deleteItem( mapping (Constants.ItemType => address[]) storage _items, Constants.ItemType _type, address _item ) public {

        int idx = Constants.findAddressIndex(_item, _items[_type]);
        require(idx > -1 && idx < int(_items[_type].length), "No index");

        Constants.deleteAddressFrom(idx, _items[_type]);

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
        require(msg.sender == owner || msg.sender == manager, "Only owner");
        _;
    }

    receive() external payable { }

    fallback() external payable { }

    function deposit() external payable { }


    function getBalance() external view ownerOnly returns (uint) {
        return address(this).balance;
    }

    function withdraw( uint _amount) external payable ownerOnly {
        require(address(this).balance >= _amount, "Insufficient");

        (bool success, ) = owner.call{value: _amount}("");
        
        require(success, "Failed");

    }

    function sendTo(address payable _to, uint _amount) external payable ownerOnly {
        require(_to != address(0), "Invalid address");
        require(address(this).balance >= _amount, "Insufficient");

        (bool success, ) = _to.call{value: _amount}("");
        
        require(success, "Failed");
    }



}

// File: Libs/OrgUtils.sol



pragma solidity >=0.4.22 <0.9.0;


library OrgUtils{

    struct Member {
        string name;
        address addr;
    }

    struct Item {
        address addr;
        address creator;
    }

    function isValidItemType(uint8 _type) internal pure returns (bool) {
        return _type < uint8(Constants.ItemType.PASSWORD) + 1;
    } 

    function findIndex(address _value, address[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _value) return int(i);
        }
        return -1; 
    }

    function findOrgMember(address _value, Member[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i].addr == _value) return int(i);
        }
        return -1; 
    }

    function findOrgItem(address _value, Item[] memory _array) internal pure returns (int) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i].addr == _value) return int(i);
        }
        return -1; 
    }
    

}

// File: Organisation.sol



pragma solidity >=0.4.22 <0.9.0;



contract Organisation{

    string name;
    OrgUtils.Member[] members;

    mapping (Constants.ItemType => OrgUtils.Item[]) Items;

    address owner;
    address parent;

    event Created(address, address);

    constructor(string memory _name, address _owner, address _parent){

        name = _name;
    
        owner = _owner;
        parent = _parent;
        members.push( OrgUtils.Member("*", owner) );

        emit Created(msg.sender, address(this));
    }

    modifier ownerOnly{
        require(msg.sender == owner || msg.sender == parent, "Only owner");
        _;
    }

    modifier memberOnly{
        require( OrgUtils.findOrgMember(msg.sender, members) > -1, "Only member");
        _;
    }

    modifier ownerOrSelfOnly(address self){
        require( msg.sender == owner || (OrgUtils.findOrgMember(msg.sender, members) > -1 && msg.sender == self ), "Only owner|self");
        _;
    }

    function isOwn() external view memberOnly returns (bool) {

        return owner == msg.sender;
    }

    function getName() external view memberOnly returns (string memory) {

        return name;
    }

    function getMembers() external view ownerOnly returns (OrgUtils.Member[] memory) {

        return members;
    }

    function addMember(string memory _name, address _addr) external ownerOnly {
        int index = OrgUtils.findOrgMember( _addr, members );

        if( index != -1 ) revert("Exists");

        members.push( OrgUtils.Member(_name, _addr) );
    
    }
    
    function removeMember(address _addr) external ownerOrSelfOnly(_addr) {
        int index = OrgUtils.findOrgMember( _addr, members );

        if( index != -1 ) revert("No index");

        members[uint(index)] = members[members.length - 1];
        members.pop();
    }

    function getItems(Constants.ItemType _type) external view memberOnly returns (address[] memory) {

        //TODO: visible creator?
        address[] memory _items;

        for (uint i = 0; i < Items[_type].length; i++){
            _items[i] = Items[_type][i].addr;
        }

        return _items;

    }

    function addItem(Constants.ItemType _type, address _addr) external memberOnly {

        int _index = OrgUtils.findOrgItem( _addr, Items[_type] );

        if( _index > -1 ) revert("Exists");

        Items[_type].push( OrgUtils.Item( _addr, msg.sender ) );

    }

    function deleteItem(Constants.ItemType _type, address _addr) external memberOnly {

        int _index = OrgUtils.findOrgItem( _addr, Items[_type] );

        if( _index < 0 ) revert("No index");
        if( Items[_type][uint(_index)].creator != msg.sender ) revert("Only creator");

        Items[_type][uint(_index)] = Items[_type][Items[_type].length - 1];
        Items[_type].pop();

    }

}

// File: Vault.sol



pragma solidity >=0.4.22 <0.9.0;








contract Vault is Payable{


    mapping (Constants.ItemType => address[]) Items;
    address[] Organisations;
    
    constructor(address payable _owner, address _manager) Payable( _owner, _manager) {}
    

     function getItem(Constants.ItemType _type) external view ownerOnly returns (address[] memory) {
        return VaultUtils.getItems(_type, Items);
    }

    function createLoyalityCard(string memory _name, string memory _card_id) external ownerOnly {

        Items[Constants.ItemType.LOYALITY_CARD].push( address(
            (new LoyalityCard( _name, _card_id, owner, address(this) ))
        ));
        
    }

    function createDebitCard(
        string memory _name,
        string memory _card_id,
        string memory _name_on_card,
        uint16 _expire_at,
        uint16 _cvv
    ) external ownerOnly {

        Items[Constants.ItemType.DEBIT_CARD].push( address(
            (new DebitCard( _name, _card_id, _name_on_card, _expire_at, _cvv, owner, address(this)))
        ));
        
    }

    function createPassword(
        string memory _name,
        string memory _url,
        string memory _user_name,
        string memory _password
    ) external ownerOnly {

        Items[Constants.ItemType.PASSWORD].push( address(
            (new Password( _name, _url, _user_name, _password, owner, address(this)))
        ));
        
    }

    function deleteItem(Constants.ItemType _type, address _addr) external ownerOnly {

        VaultUtils.deleteItem( Items, _type, _addr );
    }

    function getOrganisations() external view ownerOnly returns (address[] memory) {

        return Organisations;
    }

    function createOrganisation(string memory _name) external ownerOnly {

        Organisations.push( address(
            (new Organisation( _name, owner, address(this)))
        ));

    }


}

// File: Manager.sol



pragma solidity >=0.4.22 <0.9.0;


contract Manager{

    address owner;
    address parent;

    mapping (address => address) ownerToVaultMap;

    constructor(address _parent){
        owner = msg.sender;
        parent = _parent;
    }


    function getVaultByOwner() external view returns (address) {

        return ownerToVaultMap[msg.sender];
    }

    function createVault() external returns (address) {

        if( ownerToVaultMap[msg.sender] == address(0) ){

            ownerToVaultMap[msg.sender] = address(
                (new Vault( payable(msg.sender), address(this) ))
            );

        }

        return ownerToVaultMap[msg.sender];

    }


}
