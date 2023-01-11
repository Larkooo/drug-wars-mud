pragma solidity >=0.8.0;

import { DrugsStorageComponent } from "../components/DrugsStorageComponent.sol";
uint256 constant ID = uint256(keccak256("component.CirculatingDrugs"));

// Circulating drugs in different locations. 
// To be used by Location entities.
contract CirculatingDrugsComponent is DrugsStorageComponent {
    constructor(address world) DrugsStorageComponent(world, ID) {}
}