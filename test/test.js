const { expect } = require("chai");
const { ethers } = require("hardhat");
const { utils } = require("ethers");
const { zeroAddress } = require("ethereumjs-util");

describe("Token", function () {
  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();
    contract = await ethers.getContractFactory("ERC20");
    token = await contract.deploy();
  });

  it("Should deploy", async function () {
    expect(await token.address).to.exist;
  });

  it("Should have correct symbol", async function () {
    expect(await token.symbol()).to.equal("JERC");
  });

  it("Should have correct name", async function () {
    expect(await token.name()).to.equal("JEROMECOIN");
  });

  it("Should have a totalSupply of 444 million", async function () {
    const totalSupply = await token.totalSupply();
    const totalSupplyEther = Math.floor(utils.formatEther(totalSupply));
    expect(totalSupplyEther).to.equal(444444444);
  });

  it("Should have correct owners", async function () {
    expect(
      await token._owners("0x78185d52a0b64b58c88cCBf1550D96833D30e2ea")
    ).to.equal(true);
    expect(
      await token._owners("0xc81f6C4737dbDE50f34affD0b73A5b23E801418B")
    ).to.equal(true);

    expect(await token._owners(owner.address)).to.equal(true);
  });
});
