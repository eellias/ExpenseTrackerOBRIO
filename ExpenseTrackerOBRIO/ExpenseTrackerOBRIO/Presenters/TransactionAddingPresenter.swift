//
//  TransactionAddingPresenter.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation

protocol TransactionAddingPresenterProtocol {
    var view: TransactionAddingViewProtocol? { get set }
    
}

class TransactionAddingPresenter: TransactionAddingPresenterProtocol {
    weak var view: TransactionAddingViewProtocol?
}
