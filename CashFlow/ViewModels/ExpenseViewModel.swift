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
    
    func totalExpense() -> Double {
        let totalExpense = expenses.reduce(0.0) { $0 + $1.amount }
        return totalExpense
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
            self.expenses = data ?? []
            didUpdate?() // Arayüze haber ver
        } catch {
            print("Veri çekilemedi: \(error)")
        }
    }
    
    func addExpense(title: String, amount: Double) {
        let newExpense = Expense(title: title, amount: amount)
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
