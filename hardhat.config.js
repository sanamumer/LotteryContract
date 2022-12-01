require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");
require("@appliedblockchain/chainlink-plugins-fund-link");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    goerli: {
      url: process.env.GOERLI_URL || "",
      chainId: 5,
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.17",
      }
    ],
  },
  mocha: {
    timeout: 10000000,
  },
};