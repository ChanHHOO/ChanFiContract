// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Defi {

  uint256 public INVERSE_BASIS_POINT;

  uint256 constant INTEREST = 1;

  uint public rates;

  mapping (address => uint) public investors;

  mapping (address => uint) public borrowers;

  address public owner;		// 컨트랙트 소유자

  function hi() public pure returns (string memory) {
        return ("Hello World");
  }

  constructor(){
    INVERSE_BASIS_POINT = 100; // sol is not support float type yet.
    owner = msg.sender;
  }

  function makeDeposit() payable public {
    uint deposit = msg.value;
    if(!payable(owner).send(deposit)) {
			revert();
		}
    investors[msg.sender] += deposit;
  }

  function borrow(address receiverAddr) payable public {
    if(!payable(receiverAddr).send(msg.value)) {
			revert();
		}
    if(borrowers[receiverAddr] > 0){
      borrowers[receiverAddr] += msg.value;
    }
    else{
      borrowers[receiverAddr] = msg.value;
    }
    
  }

  function payBack() payable public {
    uint256 interestAmount = borrowers[msg.sender] * (INTEREST / 100);
    if(borrowers[msg.sender] > 0){ // 갚을 돈이 있는 상태
      if(borrowers[msg.sender] >= msg.value){ // 갚으려 하는 돈이 빌린 돈 보다 적은지 
        if(!payable(owner).send(msg.value + interestAmount)) {
			    revert();
		    }
        borrowers[msg.sender] -= (msg.value + interestAmount);
      }
    }
  }
  
}
