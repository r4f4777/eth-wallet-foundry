// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Wallet {

    // ----------------------------------------------------------------------
    // State Variables
    // ----------------------------------------------------------------------

    /// @notice Address that controls the wallet
    address public owner;

    /// @notice Amount of the most recent deposit
    uint256 public lastDepositAmount;

    /// @notice Timestamp of the most recent deposit
    uint256 public lastDepositTime;

    /// @notice Address that made the most recent deposit
    address public lastDepositFrom;


    // ----------------------------------------------------------------------
    // Events
    // ----------------------------------------------------------------------

    /// @notice Emitted whenever someone deposits ETH into the wallet
    event Deposit(address indexed from, uint256 amount, uint256 timestamp);

    /// @notice Emitted whenever the owner withdraws ETH from the wallet
    event Withdrawal(address indexed to, uint256 amount, uint256 timestamp);

    /// @notice Emitted whenever ownership of the wallet is transferred
    event OwnerChanged(address indexed oldOwner, address indexed newOwner, uint256 timestamp);


    // ----------------------------------------------------------------------
    // Constructor
    // ----------------------------------------------------------------------

    /// @notice Sets the deployer as the initial owner of the wallet
    constructor() {
        owner = msg.sender;
        lastDepositAmount = 0;
        lastDepositTime = 0;
        lastDepositFrom = address(0);
    }


    // ----------------------------------------------------------------------
    // Core Functions
    // ----------------------------------------------------------------------

    /// @notice Allows any user to deposit ETH into the wallet
    /// @dev Updates last deposit information and emits a Deposit event
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        lastDepositAmount = msg.value;
        lastDepositTime = block.timestamp;
        lastDepositFrom = msg.sender;

        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    /// @notice Allows the owner to withdraw ETH from the wallet
    /// @param amount The amount of ETH to withdraw
    /// @dev Uses onlyOwner modifier and checks for sufficient balance
    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");

        payable(owner).transfer(amount);

        emit Withdrawal(owner, amount, block.timestamp);
    }

    /// @notice Allows the owner to transfer ownership of the wallet
    /// @param newOwner The address that will become the new owner
    /// @dev Validates that the new owner is not the zero address
    function changeOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");

        address oldOwner = owner;
        owner = newOwner;

        emit OwnerChanged(oldOwner, newOwner, block.timestamp);
    }


    // ----------------------------------------------------------------------
    // View Functions
    // ----------------------------------------------------------------------

    /// @notice Returns information about the last deposit made
    /// @return from Address that sent the deposit
    /// @return amount Amount of ETH deposited
    /// @return timestamp Block timestamp of when the deposit occurred
    function getLastDeposit() external view returns (address from, uint256 amount, uint256 timestamp)
    {
        return (lastDepositFrom, lastDepositAmount, lastDepositTime);
    }

    /// @notice Returns the current ETH balance stored in the wallet
    function getTotalBalance() external view returns (uint256) {
        return address(this).balance;
    }


    // ----------------------------------------------------------------------
    // Access Control
    // ----------------------------------------------------------------------

    /// @notice Restricts a function so it can only be called by the owner
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    /// @dev Internal function that checks if msg.sender is the owner
    function _onlyOwner() internal view {
        require(msg.sender == owner, "Only owner can call this function");
    }


    // ----------------------------------------------------------------------
    // Fallback Functions
    // ----------------------------------------------------------------------

    /// @notice Allows contract to receive ETH without calling deposit()
    receive() external payable {}

    /// @notice Fallback function to accept ETH sent with unknown calldata
    fallback() external payable {}
}
