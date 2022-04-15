// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title A decentralized Library for uploading, retrieving and sharing files
/// @author Team Buterin-BlockGames Zuri
/// @notice You can use this contract to upload, retrieve and share files to a decetralized Library
/// @dev All functions currently run without errors or unexpected outputs. The Library is a web3 version of the IPFS system
/// @custom: An experimental and Proof Of Concept contract deployed for testing purposes only.
contract DecentralizedLibrary {
    /// @notice Public Variable to track all the hashes(cids) that has been uploaded
    /// @dev Variable is an array of strings
    string[] public allUploads;
    /// @notice Public Variable to track the addresses that has uploaded
    /// @dev Variable is an array of addresses
    address[] public upLoaders;
    /// @notice Public Variable to track the uploaded hashes of the metadata of files uploaded by an address
    /// @dev Variable is an array of strings. Each upload generates a string and that string is stored in an array an passed into this variable
    mapping(address => string[]) public _uploadedCIDS;
    /// @notice Public Variable to track the uploaded hashes of the metadata of files uploaded by an address
    /// @dev Variable is an array of strings. Each upload generates a string and that string is stored in an array an passed into this variable
    mapping(address => string[]) public _sharedFiles;

    /// @notice Upload a file as a first-time user of the Library
    /// @dev Update the mapping based on the address calling the function with the array of uploaded hashes
    /// @param _cidsToUpload The Array list of hashes to upload to IPFS
    function _upload(string[] memory _cidsToUpload) public {
        _uploadedCIDS[msg.sender] = _cidsToUpload;
        upLoaders.push(msg.sender);
        for ( uint256 i = 0; i < _cidsToUpload.length; i +=1){
            
        }
    }

    /// @notice Upload a file as an existing user of the Library
    /// @dev Update the mapping based on the address calling the function with the array of uploaded hashes
    /// @dev Call the _addTwoArrays to add the new list of hashes to the existing list
    /// @param _newCidsToUpload The Array list of hashes to upload to IPFS 
    function _subsequentUpload(string[] memory _newCidsToUpload) public {
        string[] memory _updatedCIDS;
        _updatedCIDS = _addTwoArrays(msg.sender, _newCidsToUpload); //helper function 1
        _uploadedCIDS[msg.sender] = _updatedCIDS;
    }

    /// @notice Get a list of uploaded hashes from the Library
    /// @dev view function to return an array of strings representing the hashes of uploaded files
    /// @param _address The address to check it's uploaded files
    /// @return An array of strings, representing the uploaded hashes of metadata files to IPFS
    function _getListOfUploadedCIDS(address _address)
        public
        view
        returns (string[] memory)
    {
        return _uploadedCIDS[_address];
    }

    /// @notice Share files with an existing customer in the Library
    /// @dev Update the recipients mapping address with the list of shared files
    /// @param _cidsToShare An array of strings to hold the hashes of files to share
    /// @param _recipient The address to share the files with
    function _shareWithExisting(string[] memory _cidsToShare, address _recipient)
        public
    {
        string[] memory _updatedCIDS;
        _updatedCIDS = _addTwoArrays(_recipient, _cidsToShare); //calculate the new list of files for the recipient
        _uploadedCIDS[_recipient] = _updatedCIDS; //add the files to the recipient mapping address
        string[] memory _updatedSharedReceipientCIDS;
        _updatedSharedReceipientCIDS = _addTwoArraysShared(_recipient, _cidsToShare); // calc the new list of shared files for receiver
        _sharedFiles[_recipient] = _updatedSharedReceipientCIDS; //add the files to the recipient sharedFiles mapping
        string[] memory _updatedSharedSenderCIDS;
        _updatedSharedSenderCIDS = _addTwoArraysShared(msg.sender, _cidsToShare); // calc the new list of shared files for sharer
        _sharedFiles[msg.sender] = _updatedSharedSenderCIDS; //add the files to the sharers sharedFiles mapping
    }

    //// @notice Share files with a non existing customer in the Library
    /// @dev Update the recipients mapping address with the list of shared files
    /// @param _cidsToShare An array of strings to hold the hashes of files to share
    /// @param _recipient The address to share the files with
    function _shareWithNew(string[] memory _cidsToShare, address _recipient)
        public
    {
        upLoaders.push(_recipient); // add the recipient to the list of uploaders
        _uploadedCIDS[_recipient] = _cidsToShare; //add the files to the recipient mapping address
        _sharedFiles[_recipient] = _cidsToShare; //add the files to the recipient sharedFiles mapping
        string[] memory _updatedSharedSenderCIDS;
        _updatedSharedSenderCIDS = _addTwoArraysShared(msg.sender, _cidsToShare); // calc the new list of shared files for sharer
        _sharedFiles[msg.sender] = _updatedSharedSenderCIDS; //add the files to the sharers sharedFiles mapping
    }

    /// @notice Adds two arrays of strings together
    /// @dev Retrieve the array of existing hashes and add to it, the elements of another similar array
    /// @param _address The address to check it's existing hashes
    /// @param _newCidsToUpload The new set of hashes to add to the existing
    /// @return An array of strings, representing the total hashes of existing and new hashes
    function _addTwoArrays(address _address, string[] memory _newCidsToUpload)
        public
        returns (string[] memory)
    {
        string[] storage _updatedCIDS = _uploadedCIDS[_address]; //create an array that references the existing one in the mapping
        for (uint8 i = 0; i < _newCidsToUpload.length; i += 1) {
            _updatedCIDS.push(_newCidsToUpload[i]); //add the items from the new one to the old one
        }
        return _updatedCIDS; //final array is updated
    }

    function _addTwoArraysShared(address _address, string[] memory _cidsToShare)
        public
        returns (string[] memory)
    {
        string[] storage _updatedSharedCIDS = _sharedFiles[_address];
        for (uint8 i = 0; i < _cidsToShare.length; i += 1) {
            _updatedSharedCIDS.push(_cidsToShare[i]);
        }
        return _updatedSharedCIDS;
    }

    /// @notice Get balance of address calling function
    /// @return ether balance of the wallet calling the function
    function viewBalance() public view returns (uint256) {
        return address(msg.sender).balance;
    }

    /// @notice Check if an address is an existing user of the Library
    /// @dev confirm if address is in the User Array
    /// @param _address The address to check it's an existing user
    /// @return boolean, whether an address is existing in the Users Array
    function isAnUploader(address _address) public view returns (bool) {
        for (uint8 s = 0; s < upLoaders.length; s += 1) {
            if (_address == upLoaders[s]) return (true);
        }
        return (false);
    }

    //CHUKWUMA_DAVID'S CONTRIBUTIONS

    //FUNCTION 05
    //A function to get shared files
    function getSharedFiles() public view returns(string[] memory) {
        return _sharedFiles[msg.sender];
    }
}
