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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
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
    
    @objc private func didTapAdd() {
        print("Ekle butonuna basıldı")
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenses.count // ViewModel'deki sayı kadar satır olsun
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let expense = viewModel.expenses[indexPath.row]
        cell.textLabel?.text = "\(expense.title) - $\(expense.amount)"
        return cell
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
