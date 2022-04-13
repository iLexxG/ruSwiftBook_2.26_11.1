//
//  CurrencyNetworkManager.swift
//  CurrencyRates
//
//  Created by Alex Golyshkov on 08.04.2022.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class CurrencyNetworkManager {
    static let shared = CurrencyNetworkManager()
    
    private init() {}
    
    func fetchRates(completion: @escaping (Result<CurrencyData, NetworkError>) -> Void) {
        AF.request("https://www.cbr-xml-daily.ru/daily_json.js")
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let currencyData = value as? [String: Any] else { return }
                    let currentCurrencyData = CurrencyData(data: currencyData)
                    completion(.success(currentCurrencyData))
                case .failure(let error):
                    print(error)
                    completion(.failure(.decodingError))
                }
            }
    }
}
