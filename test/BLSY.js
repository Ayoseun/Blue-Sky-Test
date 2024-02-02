// SPDX-License-Identifier: MIT
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC20 Token Contract", function () {
  let ERC20Token;
  let erc20Token;
  let owner;
  let addr1;
  let addr2;

  const initialSupply = ethers.utils.parseEther("1000000");
  const mintAmount = ethers.utils.parseEther("100");

  beforeEach(async function () {
    ERC20Token = await ethers.getContractFactory("ERC20");
    [owner, addr1, addr2] = await ethers.getSigners();

    erc20Token = await ERC20Token.deploy("MyToken", "MTK", 18, initialSupply);
  });

  it("Should deploy with the correct initial parameters", async function () {
    expect(await erc20Token.name()).to.equal("MyToken");
    expect(await erc20Token.symbol()).to.equal("MTK");
    expect(await erc20Token.decimals()).to.equal(18);
    expect(await erc20Token.totalSupply()).to.equal(initialSupply);
    expect(await erc20Token.balanceOf(owner.address)).to.equal(initialSupply);
  });

  it("Should mint new tokens and update total supply", async function () {
    await erc20Token.connect(owner).mint(addr1.address, mintAmount);

    const newTotalSupply = initialSupply.add(mintAmount);
    const balanceAddr1 = await erc20Token.balanceOf(addr1.address);

    expect(await erc20Token.totalSupply()).to.equal(newTotalSupply);
    expect(balanceAddr1).to.equal(mintAmount);
  });

  it("Should burn tokens and update total supply", async function () {
    await erc20Token.connect(owner).burn(mintAmount);

    const newTotalSupply = initialSupply.sub(mintAmount);
    const balanceOwner = await erc20Token.balanceOf(owner.address);

    expect(await erc20Token.totalSupply()).to.equal(newTotalSupply);
    expect(balanceOwner).to.equal(newTotalSupply);
  });

  it("Should transfer tokens between accounts", async function () {
    const transferAmount = ethers.utils.parseEther("10");

    await erc20Token.connect(owner).transfer(addr1.address, transferAmount);

    const balanceOwner = await erc20Token.balanceOf(owner.address);
    const balanceAddr1 = await erc20Token.balanceOf(addr1.address);

    expect(balanceOwner).to.equal(initialSupply.sub(transferAmount));
    expect(balanceAddr1).to.equal(transferAmount);
  });

  it("Should allow delegated transfer of tokens", async function () {
    const approveAmount = ethers.utils.parseEther("50");
    const transferAmount = ethers.utils.parseEther("10");

    await erc20Token.connect(owner).approve(addr1.address, approveAmount);
    await erc20Token.connect(addr1).transferFrom(owner.address, addr2.address, transferAmount);

    const balanceOwner = await erc20Token.balanceOf(owner.address);
    const balanceAddr2 = await erc20Token.balanceOf(addr2.address);

    expect(balanceOwner).to.equal(initialSupply.sub(transferAmount));
    expect(balanceAddr2).to.equal(transferAmount);
  });

  it("Should not allow transfer or approve when the contract is paused", async function () {
    await erc20Token.connect(owner).pause();

    await expect(erc20Token.connect(owner).transfer(addr1.address, mintAmount)).to.be.revertedWith(
      "Contract is paused"
    );

    await expect(erc20Token.connect(owner).approve(addr1.address, mintAmount)).to.be.revertedWith(
      "Contract is paused"
    );

    await expect(erc20Token.connect(addr1).transferFrom(owner.address, addr2.address, mintAmount)).to.be.revertedWith(
      "Contract is paused"
    );
  });

  it("Should unpause the contract", async function () {
    await erc20Token.connect(owner).pause();
    expect(await erc20Token.isPaused()).to.be.true;

    await erc20Token.connect(owner).unpause();
    expect(await erc20Token.isPaused()).to.be.false;
  });

  it("Should transfer ownership to a new owner", async function () {
    const newOwner = await ethers.getSigner();
    await erc20Token.connect(owner).transferOwnership(newOwner.address);

    expect(await erc20Token.owner()).to.equal(newOwner.address);
  });
});
