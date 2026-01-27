//
//  Expense.swift
//  CashFlow
//
//  Created by EMRE ÇOBAN on 26.01.2026.
//

import Foundation
import SwiftData


@Model
class Expense {
    
    @Attribute(.unique) var id: UUID
    
    var title: String
    var amount: Double
    var date: Date
    
    init(title: String, amount: Double, date: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
    }
}
