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
    it("should deploy with createClone", async function () {
      console.log(hexZeroPad(hexlify(777), 32))
    let result = await tronCustodialWalletFactory.callStatic.getByteCode(
      tronCustodialWallet.address,
      hexZeroPad(hexlify(777), 32),
    );
    console.log("cloneDeterministic:", result);
  });
  /* it("should deploy with createClone2", async function () {
    let result = await tronCustodialWalletFactory.callStatic.cloneWalletTest2(
      alice.address,
      hexZeroPad(hexlify(777), 32)
    );
    console.log("cloneWalletTest2:", result);
  });
  it("should call keccak hashing function", async function () {
    let result =
      await tronCustodialWalletFactory.callStatic.predictDeterministicAddress(
        tronCustodialWallet.address,
        hexZeroPad(hexlify(777), 32),
        alice.address
      );
    console.log("predictDeterministicAddress:", result);
  });
  it("should call keccak hashing function", async function () {
    let result =
      await tronCustodialWalletFactory.callStatic.predictCreate2Address(
        tronCustodialWallet.address,
        hexZeroPad(hexlify(777), 32),
      );
    console.log("predictCreate2Address:",result);
  }); */
});
