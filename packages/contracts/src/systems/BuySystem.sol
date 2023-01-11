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

contract BuySystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    DrugRegistryComponent drugRegistryComponent = DrugRegistryComponent(getAddressById(components, DrugRegistryComponentID));
    LocationComponent locationComponent = LocationComponent(getAddressById(components, LocationComponentID));
    OwnedDrugsComponent ownedDrugsComponent = OwnedDrugsComponent(getAddressById(components, OwnedDrugsComponentID));
    CirculatingDrugsComponent circulatingDrugsComponent = CirculatingDrugsComponent(getAddressById(components, CirculatingDrugsComponentID));
    CashComponent cashComponent = CashComponent(getAddressById(components, CashComponentID));

    (uint256 drug, uint32 amountToBuy) = abi.decode(arguments, (uint256, uint32));
    uint256 location = locationComponent.getValue(addressToEntity(msg.sender));

    Drug memory drugInfo = drugRegistryComponent.getValue(drug);
    uint32 marketDrugAmount = ownedDrugsComponent.getDrugAmount(location, drug);
    // check if drug on market
    require(amountToBuy <= marketDrugAmount, "Not enough drugs on market");

    uint32 locationDrugAmount = circulatingDrugsComponent.getDrugAmount(location, drug);
    
    uint32 price = ((locationDrugAmount/marketDrugAmount)+drugInfo.basePrice)*drugInfo.priceMultiplier;
    uint32 total = price*amountToBuy;

    uint32 buyerBalance = cashComponent.getValue(addressToEntity(msg.sender));
    require(buyerBalance >= total, "Not enough cash to buy");

    // add to player inventory and keep track of circulating drugs 
    ownedDrugsComponent.addDrugAmount(addressToEntity(msg.sender), drug, amountToBuy);
    circulatingDrugsComponent.addDrugAmount(location, drug, amountToBuy);
    // remove drug from market inventory
    ownedDrugsComponent.removeDrugAmount(location, drug, amountToBuy);
    cashComponent.set(addressToEntity(msg.sender), cashComponent.getValue(addressToEntity(msg.sender))-total);
  }

  function executeTyped(uint256 drug, uint256 amount) public returns (bytes memory) {
    return execute(abi.encode(drug, amount));
  }
}
