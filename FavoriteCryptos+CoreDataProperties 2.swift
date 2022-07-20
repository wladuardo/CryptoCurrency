//
//  FavoriteCryptos+CoreDataProperties.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 05.07.2022.
//
//

import Foundation
import CoreData


extension FavoriteCryptos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCryptos> {
        return NSFetchRequest<FavoriteCryptos>(entityName: "FavoriteCryptos")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var price: String?
    @NSManaged public var name: String?

}

extension FavoriteCryptos : Identifiable {

}
