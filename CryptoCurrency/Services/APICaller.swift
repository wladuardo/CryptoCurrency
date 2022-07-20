//
//  APICaller.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 12.06.2022.
//

import Foundation

final class APICaller {
    let apiKey = "?apikey=FFCFCAB1-77FB-48C1-96E6-35F36D2652D2"
    let additionalApiKey = "?apikey=4F19118B-5F68-42CA-8B59-26E35798BC28"
    static let shared = APICaller()
    public var icons: [Icon] = []
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/" + additionalApiKey) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos))
            }
            catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    public func getAllIcons() {

        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/" + additionalApiKey) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self ] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.getAllCryptoData(completion: completion) 
                }
                
            }
            catch {
               print(error)
            }

        }
        task.resume()
    }
    
}
