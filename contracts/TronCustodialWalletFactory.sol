// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TronCustodialWallet.sol";

contract TronCustodialWalletFactory {
    TronCustodialWallet private initialWallet;

    event Created(address addr);

    constructor() {
        initialWallet = new TronCustodialWallet();
    }

    function cloneNewWallet(address owner, uint256 count) public {
        for (uint256 i = 0; i < count; i++) {
            address payable clone = createClone(address(initialWallet));
            TronCustodialWallet(clone).init(owner);
            emit Created(clone);
        }
    }

    function cloneWalletTest(address owner) public returns (address addr) {
        // for (uint256 i = 0; i < count; i++) {
        address payable clone = createClone(address(initialWallet));
        TronCustodialWallet(clone).init(owner);
        emit Created(clone);
        return clone;
        // }
    }

    function cloneWalletTest2(address owner, bytes32 salt)
        public
        returns (address addr)
    {
        address payable clone = createClone2(address(initialWallet), salt);
        TronCustodialWallet(clone).init(owner);
        emit Created(clone);
        return clone;
        // }
    }

    function createClone(address target)
        internal
        returns (address payable result)
    {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            result := create(0, clone, 0x37)
        }
    }

    function createClone2(address target, bytes32 salt)
        internal
        returns (address payable addr)
    {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            addr := create2(0, clone, 0x37, salt)
        }
    }

    function predictCreate2Address(address target, bytes32 salt)
        public
        view
        returns (address)
    {
        bytes memory clone;
        bytes20 targetBytes = bytes20(target);
        assembly {
            clone := mload(0x40)
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
        }
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(clone)
            )
        );
        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint256(hash)));
    }

    // https://developers.tron.network/docs/differences-from-evm
    // This will not necessarily work because TRON uses a different for concating address,
    function predictDeterministicAddress(
        address implementation,
        bytes32 salt,
        address deployer
    ) public pure returns (address predicted) {
        assembly {
            let ptr := mload(0x40)
            mstore(
                ptr,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(ptr, 0x14), shl(0x60, implementation))
            mstore(
                add(ptr, 0x28),
                0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000
            )
            mstore(add(ptr, 0x38), shl(0x60, deployer))
            mstore(add(ptr, 0x4c), salt)
            mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
            predicted := keccak256(add(ptr, 0x37), 0x55)
        }
    }
}
