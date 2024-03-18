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
}

class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    weak var coordinator: AppCoordinator?
    
    var currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(currencyLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            currencyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            currencyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func updateCurrency(currency: BitcoinCurrency) {
        currencyLabel.text = String(format: "%.2f", currency.bpi.usd.rate_float) + "$"
    }
}

