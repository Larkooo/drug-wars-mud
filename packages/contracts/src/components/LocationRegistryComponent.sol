// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "std-contracts/components/BoolBareComponent.sol";

uint256 constant ID = uint256(keccak256("component.LocationPrototype"));

// Registry for in game locations
contract LocationRegistryComponent is BoolBareComponent {
  constructor(address world) BoolBareComponent(world, ID) {}
}