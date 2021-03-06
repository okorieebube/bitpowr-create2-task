const { expect } = require("chai");
const { toUtf8Bytes, hexlify, hexZeroPad } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

describe("TronCustodialWalletFactory", function () {
  before(async () => {
    [deployer, alice, bob] = await ethers.getSigners();
    //
    TronCustodialWallet = await ethers.getContractFactory(
      "TronCustodialWallet"
    );
    tronCustodialWallet = await TronCustodialWallet.deploy();
    await tronCustodialWallet.deployed();

    TronCustodialWalletFactory = await ethers.getContractFactory(
      "TronCustodialWalletFactory"
    );
    tronCustodialWalletFactory = await TronCustodialWalletFactory.deploy();
    await tronCustodialWalletFactory.deployed();
  });
  it("should deploy with createClone2", async function () {
    console.log(hexZeroPad(hexlify(778), 32))
    let result = await tronCustodialWalletFactory.callStatic.cloneDeterministic(
        tronCustodialWallet.address,
      hexZeroPad(hexlify(777), 32)
    );
    console.log("cloneDeterministic:", result);
  });
  it("should call keccak hashing function", async function () {
    let result =
      await tronCustodialWalletFactory.callStatic.predictDeterministicAddress(
        tronCustodialWallet.address,
        hexZeroPad(hexlify(777), 32)
      );
    console.log("predictDeterministicAddress:", result);
  });
});
