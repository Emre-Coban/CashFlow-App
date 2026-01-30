//
//  ExpenseCell.swift
//  CashFlow
//
//  Created by EMRE ÇOBAN on 30.01.2026.
//

import UIKit
import SwiftUI

class ExpenseCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.text = "Breakfast"
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.text = "-$480"
        label.textColor = .systemRed
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.text = "30 Jan 2026"
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.image = UIImage(systemName: "cart.fill")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(iconImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -12),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        ])
        
    }
    
    func configure(with expense: Expense) {
        titleLabel.text = expense.title
        
        switch expense.type {
        case .income:
            amountLabel.text = "+\(expense.amount.asCurrency())"
            amountLabel.textColor = .systemGreen
            iconImageView.image = UIImage(systemName: "banknote.fill")
        case .expense:
            amountLabel.text = "-\(expense.amount.asCurrency())"
            amountLabel.textColor = .systemRed
            iconImageView.image = UIImage(systemName: "cart.fill")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        dateLabel.text = formatter.string(from: expense.date)
    }

}


// UITableViewCell için çağırma
#if DEBUG
@available(iOS 13.0, *)
struct ExpenseCell_Preview: PreviewProvider {

    static var previews: some View {
        UIViewPreview {
            let cell = ExpenseCell(style: .default, reuseIdentifier: "cell")
            return cell
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
