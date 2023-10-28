// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract DeployRaffleTest is Test {
    function testDeployRaffleHasContractAddress() public {
        DeployRaffle deployer = new DeployRaffle();
        (Raffle raffle, ) = deployer.run();
        console.log("raffle address: %s", address(raffle));
        assert(address(raffle) != address(0));
    }

    function testDeployRaffleEntranceFeeIsCorrect() public {
        DeployRaffle deployer = new DeployRaffle();
        (Raffle raffle, HelperConfig helperConfig) = deployer.run();
        (uint256 entranceFee, , , , , , , ) = helperConfig
            .activeNetworkConfig();
        console.log("Entrance fee: ", entranceFee);
        assert(entranceFee == raffle.getEntranceFee());
    }

    function testDeployRaffleVrfCoordinatorExists() public {
        DeployRaffle deployer = new DeployRaffle();
        (, HelperConfig helperConfig) = deployer.run();
        (, , address vrfCoordinator, , , , , ) = helperConfig
            .activeNetworkConfig();
        console.log("VRF Coordinator: ", vrfCoordinator);
        assert(vrfCoordinator != address(0));
    }

    function testDeployRaffleVrfCoordinatorIsCorrect() public {
        DeployRaffle deployer = new DeployRaffle();
        (Raffle raffle, HelperConfig helperConfig) = deployer.run();
        (, , address vrfCoordinator, , , , , ) = helperConfig
            .activeNetworkConfig();
        console.log("VRF Coordinator: ", vrfCoordinator);
        assert(vrfCoordinator == raffle.getVrfCoordinator());
    }

    function testDeployRaffleSubIdIsCorrect() public {
        DeployRaffle deployer = new DeployRaffle();
        (Raffle raffle, ) = deployer.run();
        console.log("Subscription Id: ", raffle.getSubscriptionId());
        assert(raffle.getSubscriptionId() != 0);
    }

    function testSubscriptionIsFunded() public {
        DeployRaffle deployer = new DeployRaffle();
        (Raffle raffle, HelperConfig helperConfig) = deployer.run();
        (, , address vrfCoordinator, , , , , ) = helperConfig
            .activeNetworkConfig();
        uint64 subId = raffle.getSubscriptionId();
        (uint96 balance, , , ) = VRFCoordinatorV2Mock(vrfCoordinator)
            .getSubscription(subId);
        console.log("subscription balance: ", balance);
        assert(balance > 0);
    }
}
