//
//  Model.swift
//  CurrencyRates
//
//  Created by Alex Golyshkov on 08.04.2022.
//

struct CurrencyData: Codable {
    let date: String?
    let previousDate: String?
    let previousURL: String?
    let timestamp: String?
    var valute: [String: Valute]?

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case previousDate = "PreviousDate"
        case previousURL = "PreviousURL"
        case timestamp = "Timestamp"
        case valute = "Valute"
    }
    
    init(data: [String: Any]) {
        date = data["Date"] as? String
        previousDate = data["PreviousDate"] as? String
        previousURL = data["PreviousURL"] as? String
        timestamp = data["Timestamp"] as? String
        valute = [:]
        
        for item in Currency.allCases {
            let allValutes = data["Valute"] as? [String: Any] ?? [:]
            let singleValute = allValutes[item.rawValue] as? [String: Any]
            let singleValuteData = Valute(valuteData: singleValute ?? [:])
            valute?[item.rawValue] = singleValuteData
        }
    }
}

struct Valute: Codable {
    let id: String?
    let numCode: String?
    let charCode: String?
    let nominal: Int?
    let name: String?
    let value: Double?
    let previous: Double?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case numCode = "NumCode"
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case previous = "Previous"
    }
    
    init(valuteData: [String: Any]) {
        id = valuteData["ID"] as? String
        numCode = valuteData["NumCode"] as? String
        charCode = valuteData["CharCode"] as? String
        nominal = valuteData["Nominal"] as? Int
        name = valuteData["Name"] as? String
        value = valuteData["Value"] as? Double
        previous = valuteData["Previous"] as? Double
    }
    
    var change: String {
        var change:Change = .down
        if ((previous ?? 0.0) - (value ?? 0.0)) < 0 {
            change = .up
        }
        return change.rawValue
    }
    
    var description:String {
       """
            ID: \(id ?? "")
            Код: \(numCode ?? "")
            Обозначение: \(charCode ?? "")
            Номинал: \(nominal ?? 0)
            Текущий курс: \(value ?? 0.0) \(change)
            Предыдущий курс: \(previous ?? 0.0)
        """
    }
}
