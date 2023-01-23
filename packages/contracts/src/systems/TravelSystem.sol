// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { System, IWorld } from "solecs/System.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { LibMath } from "libraries/LibMath.sol";
import { LocationComponent, ID as LocationComponentID } from "../components/LocationComponent.sol";
import { LocationRegistryComponent, ID as LocationRegistryComponentID } from "../components/LocationRegistryComponent.sol";
import { CirculatingDrugsComponent, ID as CirculatingDrugsComponentID } from "../components/CirculatingDrugsComponent.sol";
import { OwnedDrugsComponent, ID as OwnedDrugsComponentID } from "../components/OwnedDrugsComponent.sol";
import { CashComponent, ID as CashComponentID } from "../components/CashComponent.sol";
import { BankComponent, ID as BankComponentID } from "../components/BankComponent.sol";
import { CirculatingMoneyComponent, ID as CirculatingMoneyComponentID } from "../components/CirculatingMoneyComponent.sol";
import { StoredDrug } from "../components/DrugsStorageComponent.sol";
import { handleSpawn } from "../handlers/Spawn.sol";


uint256 constant ID = uint256(keccak256("system.Travel"));

contract TravelSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    LocationComponent locationComponent = LocationComponent(getAddressById(components, LocationComponentID));
    LocationRegistryComponent locationRegistryComponent = LocationRegistryComponent(getAddressById(components, LocationRegistryComponentID));
    CirculatingDrugsComponent circulatingDrugsComponent = CirculatingDrugsComponent(getAddressById(components, CirculatingDrugsComponentID));
    OwnedDrugsComponent ownedDrugsComponent = OwnedDrugsComponent(getAddressById(components, OwnedDrugsComponentID));
    CashComponent cashComponent = CashComponent(getAddressById(components, CashComponentID));
    BankComponent bankComponent = BankComponent(getAddressById(components, BankComponentID));
    CirculatingMoneyComponent circulatingMoneyComponent = CirculatingMoneyComponent(getAddressById(components, CirculatingMoneyComponentID));

    uint256 location = abi.decode(arguments, (uint256));
    uint256 currentLocation = locationComponent.getValue(addressToEntity(msg.sender));

    // cant travel to same location
    require(currentLocation != location, "Cannot travel to same location");
    // check if location exists
    require(locationRegistryComponent.getValue(location), "Location does not exist");

    // if current location is 0, then it is the first travel
    // give 1000$ cash to player and 5k in bank
    if (currentLocation == 0) {
      handleSpawn(cashComponent, bankComponent, circulatingMoneyComponent);
    }

    // update circulating drugs
    StoredDrug[] memory drugs = ownedDrugsComponent.getValue(addressToEntity(msg.sender));
    for (uint256 i = 0; i < drugs.length; i++) {
      circulatingDrugsComponent.removeDrugAmount(currentLocation, drugs[i].drug, drugs[i].amount);
      circulatingDrugsComponent.addDrugAmount(location, drugs[i].drug, drugs[i].amount);
    }


    locationComponent.set(addressToEntity(msg.sender), location);
  }

  function executeTyped(uint256 location) public returns (bytes memory) {
    return execute(abi.encode(location));
  }
}
