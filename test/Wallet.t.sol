// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import Test
import "forge-std/Test.sol";

// Import the contract
import "../src/Wallet.sol";

// Create a test contract that inherits from Test
contract WalletTest is Test {
    // Variable to hold the contract instance
    Wallet wallet;

    // Runs before each test — deploys a fresh Wallet contract
    function setUp() public {
        wallet = new Wallet();
    }

    /// @notice Test 1 — ensures the deployer becomes the owner
    /// Checks that `owner` is correctly initialized as `address(this)`
    function testOwnerIsDeployer() public view {
        address expectedOwner = address(this);
        address actualOwner = wallet.owner();
        assertEq(actualOwner, expectedOwner);
    }

    /// @notice Test 2 — verifies that the deposit function updates last deposit info
    /// Ensures that lastDepositAmount, lastDepositTime, lastDepositFrom are set correctly
    function testDepositUpdatesLastDeposit() public { 
        uint256 depositAmount = 1 ether;

        // Assign funds to the test account
        vm.deal(address(this), depositAmount); 

        // Make the deposit
        wallet.deposit{value: depositAmount}();

        // Get last deposit info
        (address from, uint256 amount, uint256 timestamp) = wallet.getLastDeposit();

        // Check if the info is correct
        assertEq(from, address(this));
        assertEq(amount, depositAmount);
        assertGt(timestamp, 0); // Timestamp must be greater than 0
    }

    /// @notice Test 3 — confirms that the owner can withdraw funds successfully
    /// Validates the contract balance and owner balance are updated correctly
    function testOwnerCanWithdraw() public {
        uint256 depositAmount = 1 ether;
        uint256 withdrawAmount = 0.5 ether;

        vm.deal(address(this), depositAmount); 
        wallet.deposit{value: depositAmount}();

        uint256 ownerBalanceBefore = address(this).balance;
        uint256 contractBalanceBefore = address(wallet).balance;  
        
        wallet.withdraw(withdrawAmount);

        uint256 ownerBalanceAfter = address(this).balance;
        uint256 contractBalanceAfter = address(wallet).balance;

        assertEq(contractBalanceAfter, contractBalanceBefore - withdrawAmount);
        assertEq(ownerBalanceAfter, ownerBalanceBefore + withdrawAmount);
    }

    /// @notice Test 4 — verifies that non-owners cannot withdraw funds
    /// Ensures the onlyOwner modifier prevents unauthorized withdrawals
    function testNonOwnerCannotWithdraw() public {
        uint256 depositAmount = 1 ether;
        uint256 withdrawAmount = 0.5 ether;

        vm.deal(address(this), depositAmount); 
        wallet.deposit{value: depositAmount}();
        
        address nonOwner = address(0x1234);
        vm.prank(nonOwner); // Fake msg.sender

        vm.expectRevert("Only owner can call this function");
        wallet.withdraw(withdrawAmount);
    }

    /// @notice Test 5 — validates withdraw reverts when trying to withdraw more than balance
    /// Ensures the "Insufficient balance" require statement works
    function testWithdrawRevertsIfInsufficientBalance() public {
        uint256 depositAmount = 1 ether;
        uint256 withdrawAmount = 2 ether;

        vm.deal(address(this), depositAmount); 
        wallet.deposit{value: depositAmount}();

        vm.expectRevert("Insufficient balance");
        wallet.withdraw(withdrawAmount);
    }

    /// @notice Test 6 — verifies that the owner can transfer ownership successfully
    /// Ensures owner state variable updates to the new owner address
    function testChangeOwnerWorks() public {
        address newOwner = address(0x4567);
        wallet.changeOwner(newOwner);
        assertEq(wallet.owner(), newOwner);
    }

    /// @notice Test 7 — ensures the new owner can withdraw after ownership transfer
    /// Validates that permissions correctly migrate to the new owner
    function testNewOwnerCanWithdraw() public {
        address newOwner = address(0x4567);
        wallet.changeOwner(newOwner);

        uint256 depositAmount = 1 ether;
        uint256 withdrawAmount = 0.5 ether;

        vm.deal(address(this), depositAmount);
        wallet.deposit{value: depositAmount}();

        uint256 ownerBalanceBefore = address(newOwner).balance;
        uint256 contractBalanceBefore = address(wallet).balance; 

        vm.prank(newOwner);
        wallet.withdraw(withdrawAmount);

        uint256 ownerBalanceAfter = address(newOwner).balance;
        uint256 contractBalanceAfter = address(wallet).balance;

        assertEq(contractBalanceAfter, contractBalanceBefore - withdrawAmount);
        assertEq(ownerBalanceAfter, ownerBalanceBefore + withdrawAmount);
    }

    /// @notice Test 8 — ensures non-owners cannot call changeOwner
    /// Confirms that onlyOwner modifier protects ownership transfer
    function testChangeOwnerRevertsIfCalledByNonOwner() public {
        address nonOwner = address(0x1234);
        address newOwner = address(0x4567);

        vm.prank(nonOwner);
        vm.expectRevert("Only owner can call this function");
        wallet.changeOwner(newOwner);
    }

    /// @notice Test 9 — ensures changeOwner cannot be called with zero address
    /// Checks validation of new owner address in changeOwner()
    function testChangeOwnerRevertsIfZeroAddress() public {
        address newOwner = address(0);

        vm.expectRevert("New owner cannot be the zero address");
        wallet.changeOwner(newOwner);
    }
    
    receive() external payable {}
}
