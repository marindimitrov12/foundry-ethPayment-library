// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EthPayment {
    error Payment_Amount_Must_Be_Greater_Than_0(uint256 amount);
    error Payment__TransferFailed();
    error Cant_Access_Other_PeaplePayments();
   
    
    event PaymentReceived(address  _from,address indexed _to, uint256 _amount,string timestamp);

    mapping(address=>mapping(address=>uint256))private totalPayments;
    mapping(address=>address)private addressToAddress;
     string[] public blockTimestamps;
    uint256 counter;
    constructor() {
        
    }
   

    function makePayment(address  _recipient) external payable {
          uint256 timestamp = block.timestamp;
        if(msg.value<=0){
          revert Payment_Amount_Must_Be_Greater_Than_0(msg.value);
        }
         (bool success,)=_recipient.call{value:msg.value}("");
        if(!success){
        revert Payment__TransferFailed();
        }
        totalPayments[_recipient][msg.sender]+=msg.value;
        addressToAddress[_recipient]=msg.sender;
        counter++;
        blockTimestamps.push(timestampToDateTime(block.timestamp));
        emit PaymentReceived(msg.sender,_recipient, msg.value, timestampToDateTime(timestamp));
    }
    function getTotalPayments(address user)external view returns(uint256[] memory, address[] memory,string[] memory){
        if(msg.sender!=user){
          revert Cant_Access_Other_PeaplePayments();
        }
         
        address[] memory recipients = new address[](counter);
        uint256[] memory amounts = new uint256[](counter);
        string[] memory timestamps = new string[](counter);
        for(uint256 i=0;i<counter;i++){
          address recipient = addressToAddress[user];
            recipients[i]=recipient;
            amounts[i] = totalPayments[user][recipient];
            timestamps[i]=blockTimestamps[i];
        }
         return (amounts, recipients,timestamps);
      
    }
      function timestampToDateTime(uint256 timestamp) private pure returns (string memory) {
        uint256 day = timestamp / 86400 % 30 + 1;
        uint256 month = timestamp / 2629743 % 12 + 1;
        uint256 year = 1970 + timestamp / 31556926;
        uint256 hour = timestamp / 3600 % 24;
        uint256 minute = timestamp / 60 % 60;
        uint256 second = timestamp % 60;

        string memory dateString = uint2str(day);
        dateString = string(abi.encodePacked(dateString, "-"));
        dateString = string(abi.encodePacked(dateString, uint2str(month)));
        dateString = string(abi.encodePacked(dateString, "-"));
        dateString = string(abi.encodePacked(dateString, uint2str(year)));
        dateString = string(abi.encodePacked(dateString, " "));
        dateString = string(abi.encodePacked(dateString, uint2str(hour)));
        dateString = string(abi.encodePacked(dateString, ":"));
        dateString = string(abi.encodePacked(dateString, uint2str(minute)));
        dateString = string(abi.encodePacked(dateString, ":"));
        dateString = string(abi.encodePacked(dateString, uint2str(second)));

        return dateString;
    }
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
    
}