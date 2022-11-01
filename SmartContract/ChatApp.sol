// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ChatApp{

    struct user{
        string name;
        friend[] friendList;
    }

    struct friend{
        address pubkey;
        string name;
    }

    struct message{
        address sender;
        uint256 timestamp;
        string msg;
    }

    struct allUserStruct{
        string name;
        address accountAddress;
    }

    allUserStruct[] getAllUsers;

    mapping(address=>user) userList;
    mapping(bytes32=>message[]) allMessages;


    //Check User Exist
    function checkUserExists(address pubkey) public view returns(bool){
        return bytes(userList[pubkey].name).length > 0;
    }

    //Check Already Friend
    function checkAlreadyFriend(address pubkey1, address pubkey2) internal view returns(bool){
        if(userList[pubkey1].friendList.length > userList[pubkey2].friendList.length){
            address temp = pubkey1;
            pubkey1 = pubkey2;
            pubkey2 = temp;
        }
        for(uint256 i = 0; i<userList[pubkey1].friendList.length; i++){
            if(userList[pubkey1].friendList[i].pubkey == pubkey2)return true;
        }
        return false;
    }


    //Create Account
    function createAccount(string calldata name) external{
        require(checkUserExists(msg.sender) == false, "User already exists");
        require(bytes(name).length>0, "Username cannot be empty");
        userList[msg.sender].name = name;
        getAllUsers.push(allUserStruct(name,msg.sender));
    }

    //Get User name
    function getUserName(address pubkey) external view returns(string memory){
        require(checkUserExists(pubkey),"User is not registerd");
        return userList[pubkey].name;
    }

    //Add Friend
    function addFriend(address friend_key, string calldata name) external{
        require(checkUserExists(msg.sender),"Create a account to continue");
        require(checkUserExists(friend_key),"User is not available");
        require(msg.sender != friend_key, "You can't be your own friend");
        require(checkAlreadyFriend(msg.sender, friend_key) == false, "You are already friend");

        _addFriend(msg.sender, friend_key, name);
        _addFriend(friend_key, msg.sender, userList[msg.sender].name);
    }

    //_addFriend
    function _addFriend(address me, address friend_key, string memory name)internal{
        friend memory newFriend = friend(friend_key, name);
        userList[me].friendList.push(newFriend);
    }

    //GetMy Friends
    function getMyFriends() external view returns(friend[] memory){
        return userList[msg.sender].friendList;
    }

    //Get Chat Code
    function _getChatCode(address pubkey1, address pubkey2) internal pure returns(bytes32){
        if(pubkey1<pubkey2){
            return keccak256(abi.encodePacked(pubkey1, pubkey2));
        }else return keccak256(abi.encodePacked(pubkey2,pubkey1));
    }

    //Send Message
    function sendMessage(address friend_key, string calldata _msg) external{
        require(checkUserExists(msg.sender), "Create account");
        require(checkUserExists(friend_key), "This person not exist");
        require(checkAlreadyFriend(msg.sender, friend_key), "You are not friend");

        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        message memory newMsg = message(msg.sender, block.timestamp, _msg);
        allMessages[chatCode].push(newMsg);
    }

    //Read Message
    function readMessage(address friend_key)external view returns(message[] memory){
        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        return allMessages[chatCode];
    }

    //Fetch all Users
    function getAllAppUser() public view returns(allUserStruct[] memory){
        return getAllUsers;
    }
}