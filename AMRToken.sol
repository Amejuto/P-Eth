//SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/token/ERC20/ERC20.sol";

contract PrimerContrato is ERC20 {
    constructor() ERC20("Primera Crypto", "PCY") {
        _mint(0xe9d437bB74a596F8f2f99CA6029D40376ebFE6E1, 5000 * 10**uint(decimals()));
    }
}