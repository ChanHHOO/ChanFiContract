// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Defi {
  // 1 ETH : 1000000000000000000
  uint256 public INVERSE_BASIS_POINT;

  uint256 constant INTEREST = 1;

  uint public gasPrice;

  mapping (address => uint) public investors;

  mapping (address => uint) public borrowers;

  address public owner;		// 컨트랙트 소유자

  constructor(){
    INVERSE_BASIS_POINT = 100; // sol is not support float type yet.
    owner = msg.sender;
    gasPrice = 110000000000;
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
  // gas price 를 관리자가 내야하는 상황이기 때문에, 가스비를 추가로 받아야 함
  function payBack() payable public {
    uint256 interestAmount = borrowers[msg.sender] * (INTEREST / 10000);
    if(borrowers[msg.sender] > 0){ // 갚을 돈이 있는 상태
      if(borrowers[msg.sender] >= msg.value){ // 갚으려 하는 돈이 빌린 돈 보다 적은지 
        if(!payable(owner).send(msg.value + interestAmount)) {
			    revert();
		    }
        borrowers[msg.sender] -= (msg.value + interestAmount);
      }
    }
  }

  // gas price 를 관리자가 내야하는 상황이기 때문에, 가스비만큼 적게 환급해야 함.
  function recoup(address receiverAddr) payable public{
    uint256 interestAmount = investors[receiverAddr] * (INTEREST / 10000);
    if(investors[receiverAddr] > 0){ // 환급받을 돈이 있는 상태
      if(investors[receiverAddr] >= msg.value){ // 환급 받을 돈이 투자한 돈 보다 적은지
        if(!payable(receiverAddr).send(msg.value + interestAmount - gasPrice)) {
			    revert();
		    }
        investors[receiverAddr] -= (msg.value + interestAmount);
      }
    }
  }

  function getMyDebt() view public returns(uint){
    return borrowers[msg.sender];
  }

  function getMyDeposit() view public returns(uint){
    return investors[msg.sender];
  }
  
}
