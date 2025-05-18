//SPDX-License-Identifier:MIT
pragma solidity ^0.8.26;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NKToken is ERC20 {
    address public owner;
    modifier ownerOnly() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() ERC20("NKToken", "NK") {
        owner = msg.sender;
        _mint(msg.sender, 10e18);
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        _mint(to, amount);
    }

    function burn(uint256 amount) public ownerOnly {
        _burn(msg.sender, amount);
    }
}
