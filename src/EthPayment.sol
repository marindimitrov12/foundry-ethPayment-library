// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EthPayment {
    error Payment_Amount_Must_Be_Greater_Than_0(uint256 amount);
    error Payment__TransferFailed();

   
    
    event PaymentReceived(address indexed _from, uint256 _amount,uint256 timestamp);

    mapping(address=>uint256)private totalPayments;

    constructor() {
        
    }
   

    function makePayment(address payable _recipient) external payable {
          uint256 timestamp = block.timestamp;
        if(msg.value<0){
          revert Payment_Amount_Must_Be_Greater_Than_0(msg.value);
        }
         (bool success,)=_recipient.call{value:msg.value}("");
        if(!success){
        revert Payment__TransferFailed();
        }
        totalPayments[msg.sender]+=msg.value;
        emit PaymentReceived(msg.sender, msg.value, timestamp);
    }
    
}
