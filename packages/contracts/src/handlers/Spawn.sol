// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

import { CashComponent, ID as CashComponentID } from "../components/CashComponent.sol";
import { BankComponent, ID as BankComponentID } from "../components/BankComponent.sol";
import { CirculatingMoneyComponent, ID as CirculatingMoneyComponentID } from "../components/CirculatingMoneyComponent.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { GodID } from "../constants.sol";

function handleSpawn(CashComponent cashComponent, BankComponent bankComponent, CirculatingMoneyComponent circulatingMoneyComponent) {
    cashComponent.set(addressToEntity(msg.sender), 1000);
    bankComponent.set(addressToEntity(msg.sender), 5000);
    
    uint32 circulatingMoney = circulatingMoneyComponent.getValue(GodID);
    circulatingMoneyComponent.set(GodID, circulatingMoney + 6000);
}