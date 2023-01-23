// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

import { LocationRegistryComponent } from "../components/LocationRegistryComponent.sol";

uint256 constant BronxID = uint256(keccak256("location.Bronx"));
uint256 constant GuettoID = uint256(keccak256("location.Guetto"));
uint256 constant CentralParkID = uint256(keccak256("location.CentralPark"));
uint256 constant ManhattanID = uint256(keccak256("location.Manhattan"));
uint256 constant ConeyIslandID = uint256(keccak256("location.ConeyIsland"));
uint256 constant BrooklynID = uint256(keccak256("location.Brooklyn"));

function defineLocations(LocationRegistryComponent locationRegistryComponent) {
    locationRegistryComponent.set(BronxID);
    locationRegistryComponent.set(GuettoID);
    locationRegistryComponent.set(CentralParkID);
    locationRegistryComponent.set(ManhattanID);
    locationRegistryComponent.set(ConeyIslandID);
    locationRegistryComponent.set(BrooklynID);
}