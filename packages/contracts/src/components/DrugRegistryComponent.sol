// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/Component.sol";

uint256 constant ID = uint256(keccak256("component.DrugRegistry"));

struct Drug {
  string name;
  uint32 basePrice;
  uint32 priceMultiplier;
  uint32 totalSupply;
}

// Registry for in game drugs
contract DrugRegistryComponent is Component {
  constructor(address world) Component(world, ID) {}

  function getSchema() public pure override returns (string[] memory keys, LibTypes.SchemaValue[] memory values) {
    keys = new string[](2);
    values = new LibTypes.SchemaValue[](2);

    keys[0] = "name";
    values[0] = LibTypes.SchemaValue.STRING;

    keys[1] = "basePrice";
    values[1] = LibTypes.SchemaValue.UINT32;

    keys[1] = "priceMultiplier";
    values[1] = LibTypes.SchemaValue.UINT32;

    keys[1] = "totalSupply";
    values[1] = LibTypes.SchemaValue.UINT32;
  }

  function set(uint256 entity, Drug memory drug) public virtual {
    set(entity, abi.encode(drug));
  }

  function getValue(uint256 entity) public view virtual returns (Drug memory) {
    (string memory name, uint32 basePrice, uint32 priceMultiplier, uint32 totalSupply) = abi.decode(
      getRawValue(entity),
      (string, uint32, uint32, uint32)
    );
    return Drug(name, basePrice, priceMultiplier, totalSupply);
  }
}
