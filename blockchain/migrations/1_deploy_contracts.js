// migrations/1_deploy_contracts.js
const EvidenceTracker = artifacts.require("EvidenceTracker"); // Must match contract name

module.exports = function (deployer) {
  deployer.deploy(EvidenceTracker);
};