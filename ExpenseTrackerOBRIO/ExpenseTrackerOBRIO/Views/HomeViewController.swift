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
    func presentAlert()
}

class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    weak var coordinator: AppCoordinator?
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(currencyLabel)
        view.addSubview(lastUpdatedLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        setCurrencyLabelConstraints()
        setLastUpdatedLabelConstraints()
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
        
        self.present(alertController, animated: false, completion: nil)
    }
}

