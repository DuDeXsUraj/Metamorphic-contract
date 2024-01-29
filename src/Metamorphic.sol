// SPDX-License-Identifier: WTFPL
pragma solidity 0.8.12;


contract A {
    function kill() public {
        selfdestruct(payable(address(0)));
    }
}

contract B {
    uint256 private x;

    constructor(uint256 x_) {
        x = x_;
    }
}

// The factory itself can be self destructed 
contract Factory {
   // Creates an instance of contract A and returns its address.
    function helloA() public returns (address) {
        return address(new A());
    }

   // Creates an instance of contract B with the parameter 1337 passed to its constructor and returns its address.
    function helloB() public returns (address) {
        return address(new B(1337));
    }

    function kill() public {
        selfdestruct(payable(address(0)));
    }
}