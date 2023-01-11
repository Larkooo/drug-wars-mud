pragma solidity >=0.8.0;
import "std-contracts/components/Uint32Component.sol";

uint256 constant ID = uint256(keccak256("component.Cash"));

// Amount of debt player has
contract DebtComponent is Uint32Component {
  constructor(address world) Uint32Component(world, ID) {}
}