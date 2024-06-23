// SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd =5e18;

    address[] public funders;
    mapping(address funders => uint256 amountFunded) public addressToAmountFunded;

   address public owner;
    constructor() {
    owner = msg.sender;
    }
    
    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd,"didn't send enough ETH"); // 1e18= 1 ETH
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }
    
    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex]; 
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Call failed");
    } 

    modifier onlyOwner() {
    require(msg.sender == owner, " Senders is not owner!");
   _;
  }


}

