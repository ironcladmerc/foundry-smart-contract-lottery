// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract HelperConfigTest is Test {
    function testHelperConfigIsCreated() public {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinator,
            bytes32 gasLane,
            uint64 subscriptionId,
            uint32 callbackGasLimit,
            address link,
            uint256 deployerKey
        ) = helperConfig.activeNetworkConfig();

        assert(entranceFee == 0.01 ether);
    }

    function testSepoliaNetworkConfig() public {
        vm.chainId(11155111);
        HelperConfig helperConfig = new HelperConfig();
        (, , address vrfCoordinator, , , , , ) = helperConfig
            .activeNetworkConfig();

        assert(vrfCoordinator == 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625);
    }
}
