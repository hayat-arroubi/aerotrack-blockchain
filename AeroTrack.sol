// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AeroTrack {

    enum PartStatus { Manufactured, InTransit, Installed, Retired }

    struct Part {
        uint256 serialNumber;
        string partName;
        address manufacturer;
        address currentOwner;
        PartStatus status;
        bool exists;
    }

    address public regulatoryAuthority;
    mapping(uint256 => Part) public parts;

    // --- EVENTS ---
    event PartManufactured(uint256 indexed serialNumber, string partName, address manufacturer);
    event OwnershipTransferred(uint256 indexed serialNumber, address oldOwner, address newOwner);
    event MaintenanceLogged(uint256 indexed serialNumber, address mechanic, string report);

    constructor() {
        regulatoryAuthority = msg.sender;
    }

    // --- MODIFIERS ---

    // 1. Verifie que l'appelant est l'autorite de regulation
    modifier onlyAuthority() {
        require(msg.sender == regulatoryAuthority, "Error: You are not the Authority.");
        _;
    }

    // 2. Verifie que la piece existe avant d'interagir avec elle
    modifier partExists(uint256 _serialNumber) {
        require(parts[_serialNumber].exists == true, "Error: Part does not exist in registry.");
        _;
    }

    // 3. Verifie que seul le proprietaire actuel peut modifier la piece
    modifier onlyPartOwner(uint256 _serialNumber) {
        require(parts[_serialNumber].currentOwner == msg.sender, "Error: You do not own this part.");
        _;
    }

    // --- CORE FUNCTIONS ---

    // Enregistrer une piece nouvellement fabriquee
    function manufacturePart(uint256 _serialNumber, string memory _partName) public {
        require(parts[_serialNumber].exists == false, "Error: Serial Number already registered!");

        parts[_serialNumber] = Part({
            serialNumber: _serialNumber,
            partName: _partName,
            manufacturer: msg.sender,
            currentOwner: msg.sender,
            status: PartStatus.Manufactured,
            exists: true
        });

        emit PartManufactured(_serialNumber, _partName, msg.sender);
    }

    // Transferer la piece a un nouveau proprietaire (ex: une compagnie aerienne)
    function transferPart(uint256 _serialNumber, address _newOwner)
        public
        partExists(_serialNumber)
        onlyPartOwner(_serialNumber)
    {
        require(_newOwner != address(0), "Error: Cannot transfer to zero address.");

        address oldOwner = parts[_serialNumber].currentOwner;
        parts[_serialNumber].currentOwner = _newOwner;
        parts[_serialNumber].status = PartStatus.InTransit;

        emit OwnershipTransferred(_serialNumber, oldOwner, _newOwner);
    }

    // --- MAINTENANCE FUNCTION ---
    function logMaintenance(uint256 _serialNumber, string memory _report)
        public
        partExists(_serialNumber)
        onlyPartOwner(_serialNumber)
    {
        emit MaintenanceLogged(_serialNumber, msg.sender, _report);
        parts[_serialNumber].status = PartStatus.Installed;
    }
}