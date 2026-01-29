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
        
        totalLabel.text = "Total Expense: $\(viewModel.totalExpense())"
    }
    
    private func setupHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        headerView.backgroundColor = .systemBlue
        tableView.tableHeaderView = headerView
        
        
        totalLabel.frame = CGRect(x: 20, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        headerView.addSubview(totalLabel)
    }
    
    private func setupBindings() {
        viewModel.didUpdate = { [weak self] in
            
            self?.updateUI()
        }
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Expense", message: "Enter the expense details", preferredStyle: .alert)
        
        alert.addTextField { title in
            title.placeholder = "e.g., Coffee"
            title.tag = 0
        }
        
        alert.addTextField { amount in
            amount.placeholder = "e.g., 5"
            amount.keyboardType = .numberPad
            amount.tag = 1
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let add = UIAlertAction(title: "Add", style: .default) { [weak alert, weak self] _ in
            
            guard let titleString = alert?.textFields?[0].text, !titleString.isEmpty, let amountString = alert?.textFields?[1].text, let amountValue = Double(amountString) else {
                print("Eksik veya hatalı giriş yapıldı")
                return
            }
            
            let capitalizedTitle = titleString.capitalized
            
            self?.viewModel.addExpense(title: capitalizedTitle, amount: amountValue)
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
