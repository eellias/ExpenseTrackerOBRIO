//
//  TransactionAddingVIewController.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation
import UIKit

class TransactionAddingViewController: UIViewController, TransactionAddingViewProtocol {
    var presenter: TransactionAddingPresenterProtocol!
    private let transactionCategories = ["Groceries", "Taxi", "Electronics", "Restaurant", "Other"]
    var selectedCategory: String?
    
    var canSave: Bool {
        guard let text = amountTextField.text, let amount = Double(text.replacingOccurrences(of: ",", with: ".")), amount > 0.0, amount <= presenter.balance else {
            return false
        }
        return true
    }
    
    private var amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.overrideUserInterfaceStyle = .light
        return textField
    }()
    
    private var addTransactionButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .blue
        configuration.baseForegroundColor = .white
        configuration.title = "Add"
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.overrideUserInterfaceStyle = .light
        
        return button
    }()
    
    private var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.overrideUserInterfaceStyle = .light
        return picker
    }()
    
    private var limitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.updateTransactionLimits()
        setupUI()
    }
}

// MARK: - UI Setting Functions
extension TransactionAddingViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(amountTextField)
        view.addSubview(categoryPicker)
        view.addSubview(addTransactionButton)
        view.addSubview(limitsLabel)
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        amountTextField.delegate = self
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        self.selectedCategory = self.transactionCategories.first
        
        if let selectedCategory = selectedCategory {
            if let index = transactionCategories.firstIndex(of: selectedCategory) {
                categoryPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        addTransactionButton.isEnabled = canSave
        addTransactionButton.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        amountTextField.inputAccessoryView = toolbar
        
        setConstraints()
    }
    
    private func setConstraints() {
        setAmountTextFieldConstraints()
        setCategoryPickerConstraints()
        setAddTransactionButtonConstraints()
        setLimitsLabelConstraints()
    }
    
    private func setAmountTextFieldConstraints() {
        NSLayoutConstraint.activate([
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    private func setCategoryPickerConstraints() {
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: limitsLabel.bottomAnchor, constant: 24),
            categoryPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setAddTransactionButtonConstraints() {
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 24),
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setLimitsLabelConstraints() {
        NSLayoutConstraint.activate([
            limitsLabel.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            limitsLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 10)
        ])
    }
}

// MARK: - User actions functions
extension TransactionAddingViewController {
    @objc func addTransactionTapped() {
        if let text = amountTextField.text, let amount = Double(text.replacingOccurrences(of: ",", with: ".")), amount > 0.0, amount <= presenter.balance {
            presenter.addTransaction(amount: amount, category: self.selectedCategory ?? "Other")
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        addTransactionButton.isEnabled = canSave
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func didSelectTransactionCategory(_ category: String) {
        self.selectedCategory = category
    }
    
    func updateTransactionLimits(maxAmount: Double) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 1
        formatter.roundingMode = .down
        
        limitsLabel.text = "Transaction limit: 0.0 – \(formatter.string(from: NSNumber(value: maxAmount)) ?? "0.0")"
    }
}

// MARK: - UIPickerViewDelegate and UIPickerViewDataSource functions
extension TransactionAddingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.transactionCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.transactionCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = transactionCategories[row]
        presenter.didSelectTransactionCategory(selectedCategory)
    }
}

// MARK: - UITextFieldDelegate functions
extension TransactionAddingViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }

        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789,")
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)
        let isAllowed = replacementStringCharacterSet.isSubset(of: allowedCharacterSet)

        if !isAllowed {
            return false
        }

        if string == "," {
            if currentText.contains(",") {
                return false
            }
        }

        if currentText == "0" && string != "," {
            textField.text = string
            return false
        }

        if currentText == "0" && string == "," {
            textField.text = "0,"
            return false
        }

        if currentText.isEmpty && string == "," {
            textField.text = "0,"
            return false
        }
        
        if let dotIndex = currentText.firstIndex(of: ",") {
            let fractionPart = currentText[dotIndex...]
            if fractionPart.count > 6 {
                if string == "" {
                    return true
                } else {
                    return false
                }
            }
        }

        return true
    }
}
