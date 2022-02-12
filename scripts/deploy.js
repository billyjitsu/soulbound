
const hre = require("hardhat");

async function main() {
 
  const Soulbound = await hre.ethers.getContractFactory("ERC721Soulbound");
  const soulbound = await Soulbound.deploy(
    "0xE66a55EddDbEc1511Be72af68860b9Fa31854f65",
    "0x3168697665000000000000000000000000000000000000000000000000000000",
    "Soulbound",
    "Soul");

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
