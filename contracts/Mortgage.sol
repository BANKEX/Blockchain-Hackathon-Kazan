pragma solidity ^0.4.15;


  
contract Mortgage {

    uint constant public MAX_OWNER_COUNT = 50;

    event Confirmation(address indexed sender, uint indexed transactionId);
    event Revocation(address indexed sender, uint indexed transactionId);
    event Submission(uint indexed transactionId);
    event Finalization(uint indexed transactionId);
    event Acceptance(uint indexed transactionId);
    event OwnerAddition(address indexed owner);
    event OwnerRemoval(address indexed owner);
    event RequirementChange(uint required);

    mapping (uint => Edition) public editions;
    mapping (uint => mapping (address => bool)) public confirmations;
    mapping (address => bool) public isOwner;
    mapping (address => bool) public isKYCChecked;
    address[] public parties;
    address public rosreestr;
    address public depositary;
    address public KYCprovider;
    uint public UID;
    uint public required;
    uint editionsCount=1;
    bool public isCoveredDeposit = false;
    mapping (string => Field) allFields;
    mapping (uint => string) public allFieldNames;
    mapping (string => uint) fieldNameAlreadyPresent;
    uint public fieldNamesCount = 0;
    uint public lastAcceptedEdition = 0;


    struct Field {
        uint fieldTag;
        string fieldValue;
    }

    struct Edition {
        uint _id;
        bool accepted;
        bool finalized;
        uint fieldNamesCount;
        mapping (uint => string) fieldNames;
        mapping (string => Field) fields;
    }

    enum MortgageState {Initialized, Valid, PendingEdition}
    MortgageState state = MortgageState.Initialized;


    modifier requiresState(MortgageState _state) {
        require(state == _state);
        _;
    }

    modifier onlyWallet() {
        require(msg.sender == address(this));
        _;
    }

    modifier ownerDoesNotExist(address owner) {
        require(!isOwner[owner]);
        _;
    }

    modifier ownerExists(address owner) {
        require(isOwner[owner]);
        _;
    }

    modifier addressByKYCChecked(address owner) {
        require(isKYCChecked[owner]);
        _;
    }

    modifier transactionExists(uint editionID) {
        require(editions[editionID]._id != 0);
        _;
    }

    modifier confirmed(uint transactionId, address owner) {
        require(confirmations[transactionId][owner]);
        _;
    }

    modifier notConfirmed(uint transactionId, address owner) {
        require(!confirmations[transactionId][owner]);
        _;
    }

    modifier notAccepted(uint editionID) {
        require(!editions[editionID].accepted);
        _;
    }

    modifier notNull(address _address) {
        require(_address == 0);
        _;
    }

    modifier validForCreation(uint _partiesCount) {
        require(_partiesCount < MAX_OWNER_COUNT && _partiesCount != 0);
        _;
    }

    function()
    {
        assert(false);
    }

    /*
     * Public functions
     */

    function Mortgage(address[] _parties, address _rosreestr, address _depositary)
        public
        validForCreation(_parties.length)
    {
        require(_rosreestr != 0x0);
        parties = _parties;
        rosreestr = _rosreestr;
        depositary = _depositary;
        UID = uint(sha3(parties,rosreestr,depositary,now));
        required = _parties.length + 1;
        if (depositary != 0x0) {
            isOwner[depositary] = true;
            required++;
        }
        for (uint i=0; i < parties.length; i++){
            isOwner[parties[i]]=true;
        }
        isOwner[rosreestr]=true;
        
    }

    function createEdition()
        public
        ownerExists(msg.sender)
        returns (uint editionID) 
    {
        Edition memory newEdition = Edition({
            _id : editionsCount,
            accepted: false,
            finalized: false,
            fieldNamesCount: 0
            });
        editionID = editionsCount;
        editions[editionID] = newEdition;
        editionsCount += 1;
        Submission(editionsCount);
    }

    function finalizeEdition(uint _editionID)
        public
        ownerExists(msg.sender)
        returns (bool success)
    {
        require(_editionID < editionsCount);
        require(getConfirmationCount(_editionID) == 0);
        Edition storage edition = editions[_editionID];
        edition.finalized = true;
        Finalization(editionsCount);
        return true;
    }

    function appendToEdition(string _fieldName, uint _fieldTag, string _fieldValue, uint _editionID)
        public
        ownerExists(msg.sender)
        returns (bool success)
    {
        require(_editionID < editionsCount);
        require(getConfirmationCount(_editionID) == 0);
        Edition storage edition = editions[_editionID];
        uint fieldID = edition.fieldNamesCount;
        edition.fieldNames[fieldID] = _fieldName;
        Field memory newField = Field({
            fieldTag: _fieldTag,
            fieldValue: _fieldValue
        });
        edition.fields[_fieldName] = newField; 
        edition.fieldNamesCount += 1;
        return true;
    }

    function confirmEdition(uint editionID)
        public
        ownerExists(msg.sender)
        transactionExists(editionID)
        notConfirmed(editionID, msg.sender)
    {
        require(editions[editionID].finalized);
        confirmations[editionID][msg.sender] = true;
        Confirmation(msg.sender, editionID);
        acceptEdition(editionID);
    }

    function revokeConfirmation(uint editionID)
        public
        ownerExists(msg.sender)
        confirmed(editionID, msg.sender)
        notAccepted(editionID)
    {
        confirmations[editionID][msg.sender] = false;
        Revocation(msg.sender, editionID);
    }

    function acceptEdition(uint editionID)
        public
        notAccepted(editionID)
    {
        if (isAccepted(editionID)) {
            if (editionID <= lastAcceptedEdition) {
                editions[editionID].accepted = true;
                return;
            }
            Edition storage proposedEdition = editions[editionID];
            for (uint i = 0; i < proposedEdition.fieldNamesCount; i++) {
                if (fieldNameAlreadyPresent[proposedEdition.fieldNames[i]] == 0) {
                    fieldNameAlreadyPresent[proposedEdition.fieldNames[i]] = fieldNamesCount;
                    allFieldNames[fieldNamesCount] = proposedEdition.fieldNames[i];
                    fieldNamesCount += 1;
                }
                allFields[proposedEdition.fieldNames[i]] = proposedEdition.fields[proposedEdition.fieldNames[i]];
            }
            lastAcceptedEdition = editionID;
            Acceptance(editionID);
        }
    }

    function isAccepted(uint editionID)
        public
        constant
        returns (bool)
    {
        uint count = 0;
        for (uint i=0; i<parties.length; i++) {
            if (confirmations[editionID][parties[i]])
                count += 1;
        }
        if (confirmations[editionID][rosreestr]){
            count += 1;
        }
        if (isCoveredDeposit && confirmations[editionID][depositary]){
            count += 1;
        }
        if (count == required)
        return true;
    }

    // /*
    //  * Internal functions
    //  */


    /*
     * Web3 call functions
     */

    function getConfirmationCount(uint editionID)
        public
        constant
        returns (uint count)
    {
        for (uint i=0; i<parties.length; i++) {
            if (confirmations[editionID][parties[i]]) {
                count += 1;
            }
        }
        if (confirmations[editionID][rosreestr]) {
                count += 1;
            }
        if (isCoveredDeposit && confirmations[editionID][depositary]) {
            count += 1;
        }
    }

    function getNumberOfEditions() 
        public
        constant
        returns(uint number)
    {
        return editionsCount-1;
    }

    function getNumberOfFieldsInEdition(uint _editionID)
        public
        constant
        returns(uint number)
    {
        return editions[_editionID].fieldNamesCount;
    }

    function getEditionContent(uint _fieldNumber, uint _editionID) 
        public
        constant
        returns(string field, uint tag, string value)
    {
        require(_editionID < editionsCount);
        Edition storage edition = editions[_editionID];
        require(_fieldNumber < edition.fieldNamesCount);
        string storage fieldName = edition.fieldNames[_fieldNumber];
        return (fieldName, edition.fields[fieldName].fieldTag, edition.fields[fieldName].fieldValue);
    }

    function getEditionsCount(bool pending, bool accepted)
        public
        constant
        returns (uint count)
    {
        for (uint i=1; i<editionsCount; i++)
            if (   pending && !editions[i].accepted
                || accepted && editions[i].accepted)
                count += 1;
    }

    function getParties()
        public
        constant
        returns (address[])
    {
        return parties;
    }

    function getConfirmations(uint editionID)
        public
        constant
        returns (address[] _confirmations)
    {
        address[] memory confirmationsTemp = new address[](required);
        uint count = 0;
        uint i;
        for (i=0; i<parties.length; i++)
            if (confirmations[editionID][parties[i]]) {
                confirmationsTemp[count] = parties[i];
                count += 1;
            }
            if (confirmations[editionID][rosreestr]){
                confirmationsTemp[count] = rosreestr;
                count += 1;
            }
            if (isCoveredDeposit && confirmations[editionID][depositary]){
                confirmationsTemp[count] = depositary;
                count += 1;
            }
        _confirmations = new address[](count);
        for (i=0; i<count; i++)
            _confirmations[i] = confirmationsTemp[i];
    }

    function getEditionIds(uint from, uint to, bool pending, bool accepted)
        public
        constant
        returns (uint[] _transactionIds)
    {
        uint[] memory transactionIdsTemp = new uint[](editionsCount-1);
        uint count = 0;
        uint i;
        for (i=1; i<editionsCount; i++)
            if (   pending && !editions[i].accepted
                || accepted && editions[i].accepted)
            {
                transactionIdsTemp[count] = i;
                count += 1;
            }
        _transactionIds = new uint[](to - from);
        for (i=from; i<to; i++)
            _transactionIds[i - from] = transactionIdsTemp[i];
    }

    function getFieldContent(uint _fieldNumber) 
        public
        constant
        returns(string field, uint tag, string value)
    {
        require(_fieldNumber < fieldNamesCount);
        string storage fieldName = allFieldNames[_fieldNumber];
        return (fieldName, allFields[fieldName].fieldTag, allFields[fieldName].fieldValue);
    }
}