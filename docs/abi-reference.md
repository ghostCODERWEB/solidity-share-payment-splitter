# ABI reference

Generated from the successfully compiled primary contract. Includes inherited methods. Authorization and economic semantics are documented in the source.

| Signature | Type | Mutability | Returns |
|---|---|---|---|
| `constructor(address asset,address[] accounts,uint256[] weights,address admin)` | constructor | nonpayable |  |
| `EnforcedPause()` | error |  |  |
| `ExpectedPause()` | error |  |  |
| `OwnableInvalidOwner(address owner)` | error |  |  |
| `OwnableUnauthorizedAccount(address account)` | error |  |  |
| `ReentrancyGuardReentrantCall()` | error |  |  |
| `SafeERC20FailedOperation(address token)` | error |  |  |
| `Funded(address sender,uint256 amount)` | event |  |  |
| `OwnershipTransferStarted(address previousOwner,address newOwner)` | event |  |  |
| `OwnershipTransferred(address previousOwner,address newOwner)` | event |  |  |
| `Paused(address account)` | event |  |  |
| `Released(address payee,uint256 amount)` | event |  |  |
| `Unpaused(address account)` | event |  |  |
| `acceptOwnership()` | function | nonpayable |  |
| `claimable(address payee)` | function | view | uint256  |
| `fund(uint256 amount)` | function | nonpayable |  |
| `owner()` | function | view | address  |
| `paused()` | function | view | bool  |
| `payeeCount()` | function | view | uint256  |
| `payees(uint256 )` | function | view | address  |
| `pendingOwner()` | function | view | address  |
| `release(address payee)` | function | nonpayable |  |
| `released(address )` | function | view | uint256  |
| `renounceOwnership()` | function | nonpayable |  |
| `setPaused(bool value)` | function | nonpayable |  |
| `shares(address )` | function | view | uint256  |
| `token()` | function | view | address  |
| `totalReceived()` | function | view | uint256  |
| `totalReleased()` | function | view | uint256  |
| `totalShares()` | function | view | uint256  |
| `transferOwnership(address newOwner)` | function | nonpayable |  |
