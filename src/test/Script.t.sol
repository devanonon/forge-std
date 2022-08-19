// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "../Test.sol";

contract ScriptTest is Test
{
     function testGenerateCorrectAddress() external {
        address creation = computeCreateAddress(0x6C9FC64A53c1b71FB3f9Af64d1ae3A4931A5f4E9, 14);
        assertEq(creation, 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
    }

    function testRunScriptWithSetup() public {
        runScript("Script.t.sol:ScriptWithSetup");
        assertTrue(vm.envBool("SCRIPT_SETUP_CALLED"));
        assertTrue(vm.envBool("SCRIPT_RUN_CALLED"));
    }

    function testRunScriptWithoutSetup() public {
        runScript("Script.t.sol:ScriptWithoutSetup");
        assertTrue(vm.envBool("SCRIPT_RUN_CALLED"));
    }

    function testCustomRun() public {
        bytes memory run = abi.encodeWithSignature("runThis(uint256)", 2);
        bytes memory data = runScript("Script.t.sol:ScriptCustomRun", run);
        assertEq(abi.decode(data, (uint256)), 2);
    }
}

contract ScriptWithSetup is Script {
    function setUp() public {
        vm.setEnv("SCRIPT_SETUP_CALLED", "true");
    }

    function run() public {
        vm.setEnv("SCRIPT_RUN_CALLED", "true");
    }
}

contract ScriptWithoutSetup is Script {
    function run() public {
        vm.setEnv("SCRIPT_RUN_CALLED", "true");
    }
}

contract ScriptRunReturnsData is Script {
    function run() public returns (uint256) {
        return 1;
    }
}

contract ScriptCustomRun is Script {
    function runThis(uint256 test) public returns (uint256) {
        return test;
    }
}