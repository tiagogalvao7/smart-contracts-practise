// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract Calculator {
    uint256 public result;
    address public owner;

    event Operation(
        string operation,
        uint256 num1,
        uint256 num2,
        uint256 result
    );

    constructor() {
        owner = msg.sender;
        result = 0;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can interact with this contract");
        _;
    }

    function add(uint256 _num1, uint256 _num2) public onlyOwner returns (uint256) {
        result = _num1 + _num2;
        emit Operation("addition", _num1, _num2, result);
        return result;
    }

    function sub(uint256 _num1, uint256 _num2) public onlyOwner returns (uint256) {
        result = _num1 - _num2;
        emit Operation("subtraction", _num1, _num2, result);
        return result;
    }

    function multi(uint256 _num1, uint256 _num2) public onlyOwner returns (uint256) {
        result = _num1 * _num2;
        emit Operation("multiplication", _num1, _num2, result);
        return result;
    }

    function div(uint256 _num1, uint256 _num2) public onlyOwner returns (uint256) {
        result = _num1 / _num2;
        emit Operation("division", _num1, _num2, result);
        return result;
    }
}
