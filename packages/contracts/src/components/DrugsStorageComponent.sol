// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/BareComponent.sol";
import { Set } from "solecs/Set.sol";

uint256 constant ID = uint256(keccak256("component.StoredDrugs"));

struct StoredDrug {
  uint256 drug;
  uint32 amount;
}

// Represents a stash of drugs
contract DrugsStorageComponent is BareComponent {
  constructor(address world, uint256 id) BareComponent(world, id) {}

  function getSchema() public pure override returns (string[] memory keys, LibTypes.SchemaValue[] memory values) {
    keys = new string[](2);
    values = new LibTypes.SchemaValue[](2);

    keys[0] = "drugs";
    values[0] = LibTypes.SchemaValue.UINT256_ARRAY;

    keys[1] = "amount";
    values[1] = LibTypes.SchemaValue.UINT256_ARRAY;
  }

  function set(uint256 entity, StoredDrug[] memory storedDrugs) public virtual {
    set(entity, abi.encode(storedDrugs));
  }

  function addDrugAmount(uint256 entity, uint256 drug, uint32 amount) public virtual {
    uint32 currentAmount = getDrugAmount(entity, drug);

    setDrugAmount(entity, drug, currentAmount+amount);
  }

  function removeDrugAmount(uint256 entity, uint256 drug, uint32 amount) public virtual {
    uint32 currentAmount = getDrugAmount(entity, drug);
    require(currentAmount >= amount, "Not enough drugs to remove");

    setDrugAmount(entity, drug, currentAmount-amount);
  }

  function setDrugAmount(uint256 entity, uint256 drug, uint32 amount) public virtual {
    (StoredDrug[] memory storedDrugs) = getValue(entity);

    for (uint256 i = 0; i < storedDrugs.length; i++) {
      if (storedDrugs[i].drug == drug) {
        storedDrugs[i].amount = uint32(amount);
        set(entity, storedDrugs);
        return;
      }
    }

    StoredDrug[] memory newStoredDrugs = new StoredDrug[](storedDrugs.length + 1);
    for (uint256 i = 0; i < storedDrugs.length; i++) {
      newStoredDrugs[i] = storedDrugs[i];
    }
    newStoredDrugs[storedDrugs.length] = StoredDrug(drug, uint32(amount));

    set(entity, abi.encode(newStoredDrugs));
  }

  function getDrugAmount(uint256 entity, uint256 drug) public view virtual returns (uint32) {
    (StoredDrug[] memory storedDrugs) = getValue(entity);

    for (uint256 i = 0; i < storedDrugs.length; i++) {
      if (storedDrugs[i].drug == drug) {
        return storedDrugs[i].amount;
      }
    }

    return 0;
  }

  function getValue(uint256 entity) public view virtual returns (StoredDrug[] memory) {
    (StoredDrug[] memory storedDrugs) = abi.decode(getRawValue(entity), (StoredDrug[]));
    return storedDrugs;
  }

  // function getEntitiesWithValue(Set drugs) public view virtual returns (uint256[] memory) {
  //   return getEntitiesWithValue(abi.encode(drugs));
  // }
}
