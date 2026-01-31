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
    private var allExpenses: [Expense] = []
    
    // Veritabanı araçları
    private var container: ModelContainer?
    private var context: ModelContext?
    
    // Arayüzü güncellemek için kullanılacak Closure
    var didUpdate: (() -> Void)?

    
    // Başlatıcı
    init() {
        
        setupDatabase()
    }
    
    // Dışarıdan bir seçim gelecek (0: All, 1: Income, 2: Expense)
    func filterTransactions(by segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            expenses = allExpenses
            
        case 1:
            expenses = allExpenses.filter { $0.type == .income }
            
        case 2:
            expenses = allExpenses.filter { $0.type == .expense }
            
        default:
            break
        }
        
        didUpdate?()
    }
    
    func totalExpense() -> Double {
        return expenses.reduce(0.0) { result, expense in
            switch expense.type {
            case .income:
                return result + expense.amount
            case .expense:
                return result - expense.amount
            }
        }
    }
    
    private func setupDatabase() {
        do {
            let schema = Schema([Expense.self])
            container = try ModelContainer(for: schema)
            context = container?.mainContext
            fetchExpenses() // Açılır açılmaz verileri çek
        } catch {
            print("Veritabanı kurulamadı: \(error)")
        }
    }
    
    func fetchExpenses() {
        // Tarihe göre Sıralama (En yeni en üstte)
        let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        
        do {
            let data = try context?.fetch(descriptor)
            self.allExpenses = data ?? []
            self.expenses = data ?? []
            didUpdate?() // Arayüze haber ver
        } catch {
            print("Veri çekilemedi: \(error)")
        }
    }
    
    func addExpense(title: String, amount: Double, type: TransactionType) {
        let newExpense = Expense(title: title, amount: amount, type: type)
        context?.insert(newExpense)
        
        // Verileri hemen kaydetmesi için
        // Böylece elektrik kesilse bile veri kurtulur
        try? context?.save()
        
        fetchExpenses() // Listeyi güncelle
    }
    
    func deleteExpense(at index: Int) {
        let expenseToDelete = expenses[index]
        context?.delete(expenseToDelete)
        
        // Silme işlemini onayla
        try? context?.save()
        
        // Ve listeyi güncelle
        fetchExpenses()
    }
    
}
