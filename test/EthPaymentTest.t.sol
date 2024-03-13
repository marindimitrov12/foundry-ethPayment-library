//SPDX-License-Identifier:MIT
import {Test,console}from "forge-std/Test.sol";
import {DeployEthPayment}from"../script/DeployEthPayment.s.sol";
import {EthPayment}from "../src/EthPayment.sol";

pragma solidity ^0.8.0;

contract EthPaymentTest is Test{
    DeployEthPayment deployer;
    EthPayment ethPayment;
    address  Recipient=makeAddr("user");
    address SENDER=makeAddr("sender");
    uint256 constant SEND_VALUE=0.1 ether;
    uint256 constant START_BALANCE=10 ether;

    function setUp()external {
        deployer=new DeployEthPayment();
        ethPayment=deployer.run();
         vm.deal(Recipient,START_BALANCE);
         vm.deal(SENDER,START_BALANCE);
    }
    function testMakePaymentsfunctionWorkCorrectly()public{
        
       vm.prank(SENDER);
       ethPayment.makePayment{value:SEND_VALUE}(Recipient);
      
       assert(SENDER.balance<Recipient.balance);
    }
    function testMakePaymentFunctionThrowErrorWhenValueIsZero()public{
       vm.prank(SENDER);
        vm.expectRevert();
       ethPayment.makePayment{value:0}(Recipient);
        
    }

}