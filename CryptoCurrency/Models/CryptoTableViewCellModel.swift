//
//  CryptoTableViewCellModel.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 12.06.2022.
//

import Foundation

public class CryptoTableViewCellModel {
    
    let name: String
    let symbol: String
    var price: String
    let iconUrl: URL?
    var iconData: Data?
    
    init(name: String, symbol: String, price: String, iconUrl: URL?) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
    
}
