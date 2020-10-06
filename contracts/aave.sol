pragma solidity ^0.5.0;

import "https://github.com/aave/aave-protocol/blob/master/contracts/configuration/LendingPoolAddressesProvider.sol";

import "https://github.com/aave/aave-protocol/blob/master/contracts/lendingpool/LendingPool.sol";

import "https://github.com/aave/aave-protocol/blob/master/contracts/flashloan/base/FlashLoanReceiverBase.sol";

//contract to borrow some tokens as loans, here it is dai

contract Aave is FlashLoanReceiverBase{
    LendingPoolAddressesProvider provider;
    
    constructor(address _provider, address _dai) FlashLoanReceiverBase(_provider) public {
        provider=LendingPoolAddressesProvider(_provider);
        dai=_dai;
    }
    
    function startLoan(uint _amount, bytes calldata _params) external {
        address lendingPool = LendingPool(provider.getLendingPool());
        //initiate flashLoan
        //args--
        //1. address of the receiving smart contract, here just for simplicity given same contract
        //2. token to borrow
        lendingPool.flashLoan(address(this),dai,_amount,_params);
    }
    
    function receiveLoan(address _reserve, uint _amount, uint _fee, bytes memory _params) external{
        //arbitrage, refinance loan, change collateral of loan
        
        transferFundsBackToPoolInternal(_reserver, _amount+_fee);
    }
}