pragma solidity >=0.8.0;

import { System, IWorld } from "solecs/System.sol";
import { getAddressById } from "solecs/utils.sol";
import { DrugRegistryComponent, ID as DrugRegistryComponentID } from "../components/DrugRegistryComponent.sol";
import { LocationRegistryComponent, ID as LocationRegistryComponentID } from "../components/LocationRegistryComponent.sol";
import { defineLocations } from "../registeries/Locations.sol";
import { defineDrugs } from "../registeries/Drugs.sol";


uint256 constant ID = uint256(keccak256("system.Init"));

contract InitSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory) public returns (bytes memory) {
    DrugPrototypeComponent drugRegistryComponent = DrugRegistryComponent(getAddressById(components, DrugRegistryComponentID));
    LocationPrototypeComponent locationRegistryComponent = LocationRegistryComponent(getAddressById(components, LocationRegistryComponentID));

    defineLocations(drugRegistryComponent);
    defineDrugs(locationRegistryComponent);
  }
}
