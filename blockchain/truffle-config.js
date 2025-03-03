
  module.exports = {
    networks: {
      development: {
        host: "127.0.0.1", // Localhost (default for Ganache GUI)
        port: 7545,         // Port Ganache GUI is running on
        network_id: "*",    // Match any network ID
      },
    },
  
    compilers: {
      solc: {
        version: "0.5.0",  // Use the same version as in your contracts
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    },
  };