//
//  ViewController.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 17.03.2024.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func setupUI()
    func updateCurrency(currency: BitcoinCurrency)
    func updateLastUpdated(date: Date)
    func updateBalance(balance: Double)
    func presentAlert()
    func reloadTransactions()
    func updateTransactions(newTransactions: [Transaction])
}

class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    weak var coordinator: AppCoordinator?
    
    private var hasMoreData = true
    
    private var currentPage = 1
    private let pageSize = 20
    
    var currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 48)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var addBitcoinsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    var transactionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(currencyLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(balanceLabel)
        view.addSubview(addBitcoinsButton)
        
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
        
        view.addSubview(transactionsTableView)
        
        addBitcoinsButton.addTarget(self, action: #selector(presentAddBitcoinsPopup), for: .touchUpInside)
        setConstraints()
    }
    
    private func setConstraints() {
        setCurrencyLabelConstraints()
        setLastUpdatedLabelConstraints()
        setBalanceLabelConstraints()
        setAddBitcoinsButtonConstraints()
        setTransactionsTableViewConstraints()
    }
    
    private func setCurrencyLabelConstraints() {
        NSLayoutConstraint.activate([
            currencyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            currencyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setLastUpdatedLabelConstraints() {
        NSLayoutConstraint.activate([
            lastUpdatedLabel.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 4),
            lastUpdatedLabel.trailingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 0)
        ])
    }
    
    private func setBalanceLabelConstraints() {
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: lastUpdatedLabel.bottomAnchor, constant: 50),
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setAddBitcoinsButtonConstraints() {
        NSLayoutConstraint.activate([
            addBitcoinsButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor),
            addBitcoinsButton.leadingAnchor.constraint(equalTo: balanceLabel.trailingAnchor, constant: 16)
        ])
    }
    
    private func setTransactionsTableViewConstraints() {
        NSLayoutConstraint.activate([
            transactionsTableView.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 70),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController {
    func updateCurrency(currency: BitcoinCurrency) {
        currencyLabel.text = String(format: "%.2f", currency.bpi.usd.rate_float) + "$"
    }
    
    func updateLastUpdated(date: Date) {
        lastUpdatedLabel.text = "Last updated: " + date.format("dd MMM HH:mm")
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Cannot update bitcoin currency", message: "Check your internet connection", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: false, completion: nil)
    }
    
    func updateBalance(balance: Double) {
        balanceLabel.text = String(format: "%.2f", balance)
    }
    
    @objc func presentAddBitcoinsPopup() {
        let alertController = UIAlertController(title: "How many bitcoins do you want to add?", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let textField = alertController.textFields?.first {
                if let text = textField.text, let amount = Double(text.replacingOccurrences(of: ",", with: ".")), text.first != "0" {
                    self.presenter.addBitcoinsToBalance(amount: amount)
                    self.currentPage = 1
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadTransactions() {
        transactionsTableView.reloadData()
    }
    
    private func loadMoreData() {
        currentPage += 1
        presenter.loadMoreTransactions(page: currentPage, pageSize: pageSize)
    }
    
    func updateTransactions(newTransactions: [Transaction]) {
        if newTransactions.isEmpty {
            hasMoreData = false
        } else {
            self.reloadTransactions()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = transactionsTableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        let transaction = presenter.transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(presenter.transactions.count - 1)
        print(hasMoreData)
        if indexPath.row == presenter.transactions.count - 1 && hasMoreData {
            print("Last row")
            loadMoreData()
        }
    }
}
