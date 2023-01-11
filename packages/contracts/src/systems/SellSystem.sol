// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { System, IWorld } from "solecs/System.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { LibMath } from "libraries/LibMath.sol";
import { LocationComponent, ID as LocationComponentID } from "../components/LocationComponent.sol";
import { OwnedDrugsComponent, ID as OwnedDrugsComponentID } from "../components/OwnedDrugsComponent.sol";
import { Drug, DrugRegistryComponent, ID as DrugRegistryComponentID } from "../components/DrugRegistryComponent.sol";
import { CirculatingDrugsComponent, ID as CirculatingDrugsComponentID } from "../components/CirculatingDrugsComponent.sol";
import { CashComponent, ID as CashComponentID } from "../components/CashComponent.sol";

uint256 constant ID = uint256(keccak256("system.Sell"));

contract SellSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    LocationComponent locationComponent = LocationComponent(getAddressById(components, LocationComponentID));
    OwnedDrugsComponent ownedDrugsComponent = OwnedDrugsComponent(getAddressById(components, OwnedDrugsComponentID));
    CirculatingDrugsComponent circulatingDrugsComponent = CirculatingDrugsComponent(getAddressById(components, CirculatingDrugsComponentID));
    DrugRegistryComponent drugRegistryComponent = DrugRegistryComponent(getAddressById(components, DrugRegistryComponentID));
    CashComponent cashComponent = CashComponent(getAddressById(components, CashComponentID));

    (uint256 drug, uint32 amountToSell) = abi.decode(arguments, (uint256, uint32));
    uint256 location = locationComponent.getValue(addressToEntity(msg.sender));

    Drug memory drugInfo = drugRegistryComponent.getValue(drug);

    // check if drug exists
    require(drugInfo.basePrice != 0, "Drug does not exist");

    uint32 ownedAmount = ownedDrugsComponent.getDrugAmount(addressToEntity(msg.sender), drug);
    require(ownedAmount >= amountToSell, "Not enough drugs to sell");

    // TODO: calculate prices depending on drug count 
    uint32 marketDrugAmount = ownedDrugsComponent.getDrugAmount(location, drug);
    uint32 locationDrugAmount = circulatingDrugsComponent.getDrugAmount(location, drug);
    
    uint32 price = ((locationDrugAmount/marketDrugAmount)+drugInfo.basePrice)*drugInfo.priceMultiplier;
    uint32 total = price*amountToSell;

    // remove drug from player inventory and remove drug count from circulation amount
    circulatingDrugsComponent.removeDrugAmount(location, drug, amountToSell);
    ownedDrugsComponent.removeDrugAmount(addressToEntity(msg.sender), drug, amountToSell);
    // add to market inventory
    ownedDrugsComponent.addDrugAmount(location, drug, amountToSell);
    cashComponent.set(addressToEntity(msg.sender), cashComponent.getValue(addressToEntity(msg.sender))+total);
  }

  function executeTyped(uint256 drug, uint32 amount) public returns (bytes memory) {
    return execute(abi.encode(drug, amount));
  }
}
