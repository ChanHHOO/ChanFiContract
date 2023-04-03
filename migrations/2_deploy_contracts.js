var Defi=artifacts.require ("../contracts/Defi.sol");
module.exports = function(deployer) {
      deployer.deploy(Defi);
}