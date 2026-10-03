// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {SuiteBase, AssetFlow} from "./SuiteBase.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title Weighted token payment splitter
/// @notice Immutable weighted ERC20 revenue allocation with cumulative entitlement accounting and pull-based releases.
/// @dev Reference implementation; independent audit required before production.

contract TokenSplitter is SuiteBase {
    using SafeERC20 for IERC20;
    IERC20 public immutable token;
    uint256 public totalShares;
    uint256 public totalReleased;
    address[] public payees;
    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    event Released(address indexed payee, uint256 amount);
    event Funded(address indexed sender, uint256 amount);
    constructor(
        address asset,
        address[] memory accounts,
        uint256[] memory weights,
        address admin
    ) SuiteBase(admin) {
        require(
            asset.code.length > 0 &&
                accounts.length > 0 &&
                accounts.length == weights.length &&
                accounts.length <= 100,
            "config"
        );
        token = IERC20(asset);
        for (uint256 i; i < accounts.length; i++) {
            require(
                accounts[i] != address(0) &&
                    weights[i] > 0 &&
                    shares[accounts[i]] == 0,
                "payee"
            );
            shares[accounts[i]] = weights[i];
            totalShares += weights[i];
            payees.push(accounts[i]);
        }
    }
    function fund(uint256 amount) external nonReentrant whenNotPaused {
        AssetFlow.pullExact(token, msg.sender, amount);
        emit Funded(msg.sender, amount);
    }
    function totalReceived() public view returns (uint256) {
        return token.balanceOf(address(this)) + totalReleased;
    }
    function claimable(address payee) public view returns (uint256) {
        return
            Math.mulDiv(totalReceived(), shares[payee], totalShares) -
            released[payee];
    }
    function release(address payee) external nonReentrant {
        require(shares[payee] > 0, "payee");
        uint256 amount = claimable(payee);
        require(amount > 0, "nothing due");
        released[payee] += amount;
        totalReleased += amount;
        token.safeTransfer(payee, amount);
        emit Released(payee, amount);
    }
    function payeeCount() external view returns (uint256) {
        return payees.length;
    }
}
