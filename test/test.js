const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Lottery unit tests",()=>{
it("lottery contract works properly",async()=>{
    const Lottery = await ethers.getContractFactory("LotteryGame");
    const lottery = await Lottery.deploy();

    await lottery.deployed();
});
});

