
// SPDX-License-Identifier: WTFPL
pragma solidity 0.8.12;

import {Test} from "forge-std/Test.sol";
import '../src/Metamorphic.sol';

contract MetamorphicContract is Test {
    A private a;
    B private b;
    Factory private factory;

    function setUp() public {
        // deplyed factory contract with salt using create2
        factory = new Factory{salt: keccak256(abi.encode("evil"))}();
        // deployed a contract
        a = A(factory.helloA());

        /// @dev Call `selfdestruct` during the `setUp` call (see https://github.com/foundry-rs/foundry/issues/1543).
        // kill the metamorphic contract implementation
        a.kill();
    
        // perpose of selfdestructing factory is that it will reset the accounts nonce cause we using create 
        factory.kill();
    }
    
    // In different transaction 
    // we make the new factory using create2
    // So the factory is going to be deployed to the same address one 
    // And then we create b from that factory since the account nonce has been reset    

    // And deploys b
    function testMorphingContract() public {
        /// @dev Verify that the code was destroyed during the `setUp` call.
        assertEq(address(a).code.length, 0);
        assertEq(address(factory).code.length, 0);

        /// @dev Redeploy the factory contract at the same address.
        factory = new Factory{salt: keccak256(abi.encode("evil"))}();
        /// @dev Deploy another logic contract at the same address as previously contract `a`.
        b = B(factory.helloB());
        assertEq(address(a), address(b));
    }
}

// NET EFFECT OF DOING THIS 

// we had a contract at address two 
// somebody saw it in the case of perhaps the tornado cash governance exploit 
// people voted on it and that code looks good to me and then what i did is i said ok 
// now we are going to take this contract here and toss it out and here's  a new one 