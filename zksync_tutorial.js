
async function zksync_tut() {
  const zksync_1 = require("zksync");
  const ethers_1  = require("ethers");
  const syncProvider = await zksync_1.getDefaultProvider('rinkeby');
  const ethersProvider = new ethers_1.getDefaultProvider('rinkeby');

  const ethWallet = ethers_1.Wallet.fromMnemonic("ostrich pottery junk vacant stairs scrub guitar expose fade weather thing wagon").connect(ethersProvider);
  const syncWallet = await zksync_1.Wallet.fromEthSigner(ethWallet, syncProvider);

  console.log("Hello");
}

zksync_tut();
