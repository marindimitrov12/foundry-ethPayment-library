//SPDX-License-Identifier:MIT
import {Script}from "forge-std/Script.sol";
import {EthPayment}from "../src/EthPayment.sol";
pragma solidity ^0.8.0;

contract DeployEthPayment is Script{

function run()external returns(EthPayment){
    vm.startBroadcast();
 EthPayment ethPayment=new EthPayment();
   vm.stopBroadcast();
   return ethPayment;
}
}

