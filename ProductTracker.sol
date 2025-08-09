// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;

pragma solidity >=0.6.0 <0.9.0;

contract ProductTracker {
    struct Product {
        uint256 dataHash;
        uint256 timeStamp;
        address companyAddress;
    }

    // principal mapping: ID of the product->product information
    mapping(uint256 => Product) private products;

    // mapping: Company address -> id product list
    mapping(address => uint256[]) private companyProducts;

    function registerProduct(uint256 _productId, uint256 _dataHash) public {
        // check if product already exists
        require(
            products[_productId].companyAddress == address(0),
            "Product already exists"
        );
        // store dataHash, timestamp, and the address of who call function msg.sender
        products[_productId] = Product(_dataHash, block.timestamp, msg.sender);
        // add ID to company products list
        companyProducts[msg.sender].push(_productId);
    }

    function getProductInfo(
        uint256 _productId
    ) public view returns (Product memory) {
        // return product info
        return products[_productId];
    }

    // get all products from a specific company
    function getCompanyProducts(
        address _companyAddress
    ) public view returns (uint256[] memory) {
        return companyProducts[_companyAddress];
    }
}
