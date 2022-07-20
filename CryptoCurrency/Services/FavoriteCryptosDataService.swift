//
//  FavoriteCryptoDataService.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 06.07.2022.
//

import Foundation
import CoreData

class FavoriteCryptosDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "FavoriteCryptosContainer"
    private let entityName: String = "FavoriteCryptosEntity"
    public var savedEntities: [FavoriteCryptosEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading CoreData \(error)")
            }
            self.getCryptos()
        }
    }
    
    public func update(coin: CryptoTableViewCellModel) {
        if let entity = savedEntities.first(where: { $0.name == coin.name }) {
            print("This entity alredy exists \(entity)")
            applyChanges()
        } else {
            add(coin: coin)
            print("Coin successfully added \(coin.name)")
            getCryptos()
        }
    }
    
    public func delete(coin: CryptoTableViewCellModel) {
        
        if let entity = savedEntities.first(where: { $0.name == coin.name }) {
            container.viewContext.delete(entity)
            applyChanges()
        } else {
            print("Nothing to delete")
        }
        
    }

    public func getCryptos() {
        let request = NSFetchRequest<FavoriteCryptosEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Favorite Cryptos. \(error)")
        }
    }
    
    private func add(coin: CryptoTableViewCellModel) {
        let entity = FavoriteCryptosEntity(context: container.viewContext)
        entity.name = coin.name
        entity.price = coin.price
        entity.iconUrl = coin.iconUrl
        entity.symbol = coin.symbol
        applyChanges()
    }
    
    private func save() {
        guard container.viewContext.hasChanges else { return }
        try? container.viewContext.save()
    }
    
    private func applyChanges() {
        save()
        getCryptos()
    }
    
}
