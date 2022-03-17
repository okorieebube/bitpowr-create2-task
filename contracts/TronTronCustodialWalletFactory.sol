// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TronCustodialWallet.sol";

contract TronTronCustodialWalletFactory {

    TronCustodialWallet private initialWallet;

    event Created(address addr);

    constructor () {
        initialWallet = new TronCustodialWallet();
    }

    function cloneNewWallet(address owner, uint256 count) public {
        for (uint256 i = 0; i < count; i++) {
            address payable clone = createClone(address(initialWallet));
            TronCustodialWallet(clone).init(owner);
            emit Created(clone);
        }
    }

    function createClone(address target) internal returns (address payable result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }

    function createClone2(address target, bytes32 salt) internal returns (address payable addr) {
        bytes20 targetBytes = bytes20(target);
        address addr;
        assembly{
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            addr := create2(callValue(),clone, 0x37,salt)
        }
    }
    /*
     function deploy(bytes32 salt) public {
    bytes memory bytecode = contractBytecode;
    address addr;
      
    assembly {
      addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
      addr := create2(
                callvalue(), // wei sent with current call
                // Actual code starts after skipping the first 32 bytes
                add(bytecode, 0x20),
                mload(bytecode), // Load the size of code contained in the first 32 bytes
                _salt // Salt from function arguments
            )
    }
  } 
     */
}