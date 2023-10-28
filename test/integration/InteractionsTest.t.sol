// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "script/Interactions.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";

contract InteractionsTest is Test {
    function testCreateSubscriptionIsSuccess() public {
        CreateSubscription createSubscription = new CreateSubscription();
        uint64 subId = createSubscription.run();
        console.log("subId: ", subId);
        assert(subId != 0);
    }

    function testFundSubscriptionIsSuccess() public {
        HelperConfig helperConfig = new HelperConfig();
        (
            ,
            ,
            address vrfCoordinator,
            ,
            uint64 subscriptionId,
            ,
            address link,
            uint256 deployerKey
        ) = helperConfig.activeNetworkConfig();
        CreateSubscription createSubscription = new CreateSubscription();
        subscriptionId = createSubscription.createSubscription(
            vrfCoordinator,
            deployerKey
        );
        FundSubscription fundSubscription = new FundSubscription();
        fundSubscription.fundSubscription(
            vrfCoordinator,
            subscriptionId,
            link,
            deployerKey
        );
    }
}
