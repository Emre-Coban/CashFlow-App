//
//  ViewController.swift
//  CashFlow
//
//  Created by EMRE ÇOBAN on 26.01.2026.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    private let viewModel = ExpenseViewModel()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    var segmentedControl: UISegmentedControl = {
        // Öğeleri belirle
        let items = ["All", "Income", "Expense"]
        // Oluştur
        let segment = UISegmentedControl(items: items)
        // Varsayılan seçimi yap
        segment.selectedSegmentIndex = 0
        // Renkleri belirle
        segment.backgroundColor = .systemGray6
        segment.selectedSegmentTintColor = .systemBlue
        // Yazı renklerini ayarla (Seçili: Beyaz, Normal: Siyah)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return segment
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExpenseCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupHeader()
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Expenses"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func updateUI() {
        tableView.reloadData()
        
        totalLabel.text = "Total Expense: \(viewModel.totalExpense().asCurrency())"
    }
    
    private func setupHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 130))
        headerView.backgroundColor = .systemBlue
        tableView.tableHeaderView = headerView
        
        totalLabel.frame = CGRect(x: 20, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        headerView.addSubview(totalLabel)
        
        segmentedControl.frame = CGRect(x: 10, y: 90, width: totalLabel.frame.width - 20, height: 30)
        headerView.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        viewModel.filterTransactions(by: sender.selectedSegmentIndex)
    }
    
    private func setupBindings() {
        viewModel.didUpdate = { [weak self] in
            
            self?.updateUI()
        }
    }
    
    @objc private func didTapAdd() {
        let showAlert = UIAlertController(title: "Select Transaction Type", message: "Is this an income or an expense?", preferredStyle: .actionSheet)
        
        let incomeButton = UIAlertAction(title: "Income", style: .default) { _ in
            self.showAddAlert(type: .income)
        }
        // Income Butonunu yeşile çevirdik "Gelir" butonu bu sayede daha anlaşılır oldu 
        incomeButton.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        
        let expenseButton = UIAlertAction(title: "Expense", style: .destructive) { _ in
            self.showAddAlert(type: .expense)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        showAlert.addAction(incomeButton)
        showAlert.addAction(expenseButton)
        showAlert.addAction(cancelButton)
        
        present(showAlert, animated: true)
    }
    
    private func showAddAlert(type: TransactionType) {
        let alert = UIAlertController(title: "New \(type.rawValue)", message: "Please enter the details", preferredStyle: .alert)
        
        alert.addTextField { title in
            title.placeholder = "e.g., Coffee"
            title.tag = 0
        }
        
        alert.addTextField { amount in
            amount.placeholder = "e.g., 5"
            amount.keyboardType = .decimalPad
            amount.tag = 1
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let add = UIAlertAction(title: "Add", style: .default) { [weak alert, weak self] _ in
            
            guard let amountString = alert?.textFields?[1].text else { return }
            
            // Kullanıcı fiyatı yazınca "15,60" -> "15.60" olur
            let cleanAmountString = amountString.replacingOccurrences(of: ",", with: ".")
            
            guard let titleString = alert?.textFields?[0].text, !titleString.isEmpty,
                  let amountValue = Double(cleanAmountString) else {
                print("Eksik veya hatalı giriş yapıldı")
                return
            }
            
            let capitalizedTitle = titleString.capitalized
            
            self?.viewModel.addExpense(title: capitalizedTitle, amount: amountValue, type: type)
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenses.count // ViewModel'deki sayı kadar satır olsun
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExpenseCell else {
            return UITableViewCell()
        }
        let expense = viewModel.expenses[indexPath.row]
        cell.configure(with: expense)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteExpense(at: indexPath.row)
        }
    }
    
}


// UITableViewCell için çağırma
#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            UINavigationController(rootViewController: ViewController())
        }
        .ignoresSafeArea()
    }
}
#endif
