const config = {
    // Hardhat local network
    // Mock Data (it won't work)
    31337: {
      name: "hardhat",
      keyHash:
        "0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4",
      fee: "0.1",
      fundAmount: "10000000000000000000",
    },
    // Goerli
    4: {
      name: "goerli",
      linkToken: "0x326C977E6efc84E512bB9C30f76E30c160eD06FB",
      vrfCoordinator: "	0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D",
      keyHash:
        "	0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15",
      fee: "0.25",
      fundAmount: "2000000000000000000",
    },
  };
  
  module.exports = {
    config
  };