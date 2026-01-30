//
//  Expense.swift
//  CashFlow
//
//  Created by EMRE ÇOBAN on 26.01.2026.
//

import Foundation
import SwiftData

enum TransactionType: String, Codable {
    case income
    case expense
}


@Model
class Expense {
    
    @Attribute(.unique) var id: UUID
    
    var title: String
    var amount: Double
    var date: Date
    var type: TransactionType
    
    init(title: String, amount: Double, date: Date = Date(), type: TransactionType) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
        self.type = type
    }
}
