// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;
import {Events,Create2Factory} from "../src/Create2.sol";
import "forge-std/console.sol";
import "forge-std/Test.sol";


contract Create2 is Test ,Events{
    // event Deploy(address addr);
    Create2Factory public create2;

    function setUp() public {
        create2 = new Create2Factory();
    }

    // 1) First of all we will call the getBytecode by providing the address of owner
    // 2) After getting bytecode we will pass that bytecode and salt for getAddress
    // 3) And lastly we will deploy the contract with the help of that salt which emit the address
    // 4) Address by getAddress and the lastly emited address will same
    // 5) So we have solved the challenge of getting adress before the deploy

    function testCreate2() public {
        address owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        // lets put owner this address
        uint256 salt = 1;
        // pass any salt value
        bytes memory bytecode = create2.getBytecode(owner);
        // we should have pass owner address for getting bytecode
        console.logBytes(bytecode);
        // for getting address pass bytecode producted by the that getBytecode function
        // and salt which in this case is 1
        address initialAddr = create2.getAddress(bytecode, salt);
        //By creating several contracts from the same address,
        //using the same salt and the same bytecode, we will get the same address.
        console.logAddress(initialAddr);
        vm.startPrank(owner);
        // caller would be owner
        address finalAddr = create2.deploy(salt);
        emit Deploy(finalAddr);
        console.logAddress(finalAddr);
        assert(initialAddr == finalAddr);
        // this assert ensures that we could know the address of contract before the deploy
        // cause we are saying that (initial addr) and (final addr) would be same
        // that mean we can predict the address initially
        // and that emit is the prof of that
    }
}
