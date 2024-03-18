//
//  TransactionCell.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 18.03.2024.
//

import Foundation
import UIKit

class TransactionCell: UITableViewCell {
    static let identifier = "TransactionCell"
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let transactionImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(amountLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(transactionImage)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setConstraints() {
        setImageConstraints()
        setAmountLabelConstraints()
        setCategoryLabelConstraints()
        setDateLabelConstraints()
    }
    
    func setImageConstraints() {
        NSLayoutConstraint.activate([
            transactionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transactionImage.widthAnchor.constraint(equalToConstant: 24),
            transactionImage.heightAnchor.constraint(equalToConstant: 24),
            transactionImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
    }
    
    func setAmountLabelConstraints() {
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: transactionImage.trailingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: transactionImage.topAnchor, constant: 0)
        ])
    }
    
    func setCategoryLabelConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
    }
    
    func setDateLabelConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: 0),
            dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    public func configure(with model: Transaction) {
        transactionImage.image = UIImage(systemName: model.transactionType ? "arrowshape.up.fill" : "arrowshape.down.fill")?.withRenderingMode(.alwaysTemplate)
        transactionImage.tintColor = model.transactionType ? .red : .green
        amountLabel.text = String(format: "%.2f", model.transactionAmount)
        dateLabel.text = model.transactionDate?.format("dd MMM yyyy HH:mm")
        categoryLabel.text = model.transactionCategory ?? ""
    }
}
