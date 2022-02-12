
const hre = require("hardhat");

async function main() {
 
  const Soulbound = await hre.ethers.getContractFactory("ERC721Soulbound");
  const soulbound = await Soulbound.deploy("constructor");

  await soulbound.deployed();

  console.log("soulbound deployed to:", soulbound.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
