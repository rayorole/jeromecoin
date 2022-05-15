const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token", function () {
  it("Should deploy", async function () {
    const Token = await ethers.getContractFactory("ERC20");
    const token = await Token.deploy();
    await token.deployed();

    expect(await token.symbol()).to.equal("JERC");
  });
});
