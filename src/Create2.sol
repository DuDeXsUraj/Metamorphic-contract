// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

contract DeployWithCreate2 {
    address public owner;
    
    constructor (address _owner){   
        owner = _owner;
    }
}
contract Events{
    event Deploy(address adr);
}

contract Create2Factory is Events{

    function deploy(uint _salt) external returns(address){
        // we need salt here to deploy the contract 
        DeployWithCreate2 _contract = new DeployWithCreate2{
        salt: bytes32(_salt)
        }(msg.sender);
        emit Deploy(address(_contract));
        return address(_contract);
    }

    function getAddress(bytes memory bytecode, uint _salt) public view returns(address){
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff),address(this),_salt , keccak256(bytecode)));
        return address(uint160(uint(hash)));
    }

    function getBytecode (address _owner) public pure returns (bytes memory){
        bytes memory bytecode = type(DeployWithCreate2).creationCode;
        // here we are creating bytecode by the help of deployWithCreate2 
        return abi.encodePacked(bytecode,abi.encode(_owner)); 
    }
}
