// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

import { Drug, DrugRegistryComponent } from "../components/DrugRegistryComponent.sol";

uint256 constant CocaineID = uint256(keccak256("drug.Cocaine"));
uint256 constant HeroinID = uint256(keccak256("drug.Heroin"));
uint256 constant AcidID = uint256(keccak256("drug.Acid"));
uint256 constant WeedID = uint256(keccak256("drug.Weed"));
uint256 constant SpeedID = uint256(keccak256("drug.Speed"));
uint256 constant LudesID = uint256(keccak256("drug.Ludes"));

function defineDrugs(DrugRegistryComponent drugRegistryComponent) {
    drugRegistryComponent.set(CocaineID, Drug("Cocaine", 10, 2, 1000));
    drugRegistryComponent.set(HeroinID, Drug("Heroin", 30, 3, 1000));
    drugRegistryComponent.set(AcidID, Drug("Acid", 35, 2, 1000));
    drugRegistryComponent.set(WeedID, Drug("Weed", 5, 1, 1000));
    drugRegistryComponent.set(SpeedID, Drug("Speed", 15, 2, 1000));
    drugRegistryComponent.set(LudesID, Drug("Ludes", 20, 1, 1000));
}