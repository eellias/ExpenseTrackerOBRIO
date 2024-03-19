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
        guard let text = amountTextField.text, let amount = Double(text.replacingOccurrences(of: ",", with: ".")), amount != 0.0 else {
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
        return textField
    }()
    
    private var addTransactionButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .blue
        configuration.baseForegroundColor = .white
        configuration.title = "Add transaction"
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            categoryPicker.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 24),
            categoryPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setAddTransactionButtonConstraints() {
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 24),
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - User actions functions
extension TransactionAddingViewController {
    @objc func addTransactionTapped() {
        if let text = amountTextField.text, let amount = Double(text.replacingOccurrences(of: ",", with: ".")) {
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
}
