// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {HookMiner} from "v4-periphery/src/utils/HookMiner.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {PointsHook} from "../src/pointsHook.sol";

contract DeployPointsHook is Script{


    // Sepolia PoolManager address
    address constant POOL_MANAGER = 0x8C4BcBE6b9eF47855f97E675296FA3F6fafa5F1A;

    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        uint160 flags = uint160(Hooks.AFTER_SWAP_FLAG);

        (address hookAddress, bytes32 salt) = HookMiner.find(
            CREATE2_FACTORY,
            flags,
            type(PointsHook).creationCode,
            abi.encode(POOL_MANAGER)
        );

        PointsHook hook = new PointsHook{salt: salt}(
            IPoolManager(POOL_MANAGER)
        );

        require(
            address(hook) == hookAddress,
            "Hook address mismatch"
        );

        vm.stopBroadcast();
    }
}