require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("./tasks/PrintAccounts");
require("dotenv").config();

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      gas: 2100000,
      gasPrice: 130000000000,
    },
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/4tbQ72Jsb1zLMcN2-19FN7TwcJee5wu4",
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    // apiKey: BSCSCAN_API_KEY,
  },
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
      {
        version: "0.8.1",
      },
      {
        version: "0.8.3",
      },
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  mocha: {
    timeout: 200000,
  },
};
