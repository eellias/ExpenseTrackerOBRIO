//
//  ViewController.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 17.03.2024.
//

import UIKit

class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    
    private var hasMoreData = true
    
    private var currentPage = 1
    private let pageSize = 20
    
    private var currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 48)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var addBitcoinsButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .blue
        configuration.baseForegroundColor = .white
        configuration.image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return button
    }()
    
    private var addTransactionButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .blue
        configuration.baseForegroundColor = .white
        configuration.title = "New transaction"
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var transactionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func createLoaderView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        
        let loaderView = UIActivityIndicatorView()
        loaderView.center = footerView.center
        footerView.addSubview(loaderView)
        loaderView.startAnimating()
        
        return footerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidLoad()
    }
}

// MARK: - UI Setting Functions
extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(currencyLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(balanceLabel)
        view.addSubview(addBitcoinsButton)
        view.addSubview(addTransactionButton)
        view.addSubview(transactionsTableView)
        
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
        
        addBitcoinsButton.addTarget(self, action: #selector(presentAddBitcoinsPopup), for: .touchUpInside)
        addTransactionButton.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
        
        setConstraints()
    }
    
    private func setConstraints() {
        setCurrencyLabelConstraints()
        setLastUpdatedLabelConstraints()
        setBalanceLabelConstraints()
        setAddTransactionButtonConstraints()
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
    
    private func setAddTransactionButtonConstraints() {
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 16),
            addTransactionButton.centerXAnchor.constraint(equalTo: balanceLabel.centerXAnchor)
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
            transactionsTableView.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: 70),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - User Actions Functions
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
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let textField = alertController.textFields?.first {
                if let text = textField.text, let amount = Double(text.replacingOccurrences(of: ",", with: ".")), amount != 0.0 {
                    self.presenter.addBitcoinsToBalance(amount: amount)
                    self.currentPage = 1
                    self.hasMoreData = true
                }
            }
        }
        
        addAction.isEnabled = false
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let alertController = presentedViewController as? UIAlertController {
            let textFields = alertController.textFields
            let addAction = alertController.actions.last

            if let text = textFields?[0].text, let amount = Double(text.replacingOccurrences(of: ",", with: ".")), amount != 0.0 {
                addAction?.isEnabled = true
            } else {
                addAction?.isEnabled = false
            }
        }
    }
    
    func reloadTransactions() {
        transactionsTableView.reloadData()
    }
    
    private func loadMoreData() {
        currentPage += 1
        presenter.loadMoreTransactions(page: currentPage, pageSize: pageSize)
        transactionsTableView.tableFooterView = nil
    }
    
    func updateTransactions(newTransactions: [Transaction]) {
        if newTransactions.isEmpty {
            hasMoreData = false
        } else {
            self.reloadTransactions()
        }
    }
    
    @objc func addTransactionTapped() {
        presenter.addTransaction()
        self.currentPage = 1
        self.hasMoreData = true
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate Functions
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.groupedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = Array(presenter.groupedTransactions.keys).sorted(by: >)[section]
        return presenter.groupedTransactions[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Array(presenter.groupedTransactions.keys).sorted(by: >)[section]
        return date.format("dd MMM")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = transactionsTableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        let date = Array(presenter.groupedTransactions.keys).sorted(by: >)[indexPath.section]
        if let transactions = presenter.groupedTransactions[date] {
            let transaction = transactions[indexPath.row]
            cell.configure(with: transaction)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 && hasMoreData {
            transactionsTableView.tableFooterView = createLoaderView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadMoreData()
            }
        }
    }
}
