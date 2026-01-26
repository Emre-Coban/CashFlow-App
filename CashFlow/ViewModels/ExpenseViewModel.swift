//
//  ExpenseViewModel.swift
//  CashFlow
//
//  Created by EMRE ÇOBAN on 26.01.2026.
//

import Foundation
import SwiftData

class ExpenseViewModel {
    // Veriler burada tutulacak
    var expenses: [Expense] = []
    
    // Veritabanı araçları
    private var container: ModelContainer?
    private var context: ModelContext?
    
    // Arayüzü güncellemek için kullanılacak Closure
    var didUpdate: (() -> Void)?
    
    // Başlatıcı
    init() {
        
        setupDatabase()
    }
    
    private func setupDatabase() {
        
    }
    
    func fetchExpenses() {
        
    }
    
    func addExpense(title: String, amount: Double) {
        
    }
    
    func deleteExpense(at index: Int) {
        
    }
    
}
