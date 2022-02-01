
const { ethers } = require("hardhat");

async function main() {

  const Caravel = await ethers.getContractFactory("Caravel");
  const caravel = await Caravel.deploy("https://ipfs.io/ipfs/QmZNPHv7NAuzE7T2z9q27M14iNg9gftBJRvWdaHwg1QXL1/");

  await caravel.deployed();
  console.log("Success! Contract was deployed to: ", caravel.address);


  // console.log("NFT successfully minted");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
