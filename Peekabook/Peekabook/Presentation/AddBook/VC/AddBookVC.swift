//
//  AddBookVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class AddBookVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension AddBookVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        
    }
}

// MARK: - Methods