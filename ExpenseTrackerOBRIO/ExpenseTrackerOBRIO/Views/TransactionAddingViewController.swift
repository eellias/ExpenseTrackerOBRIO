//
//  TransactionAddingVIewController.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation
import UIKit

protocol TransactionAddingViewProtocol: AnyObject {
    
}

class TransactionAddingViewController: UIViewController, TransactionAddingViewProtocol {
    var presenter: TransactionAddingPresenterProtocol!
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
    }
}
