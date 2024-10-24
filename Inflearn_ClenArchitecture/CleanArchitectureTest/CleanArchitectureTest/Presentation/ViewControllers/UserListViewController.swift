//
//  UserListViewController.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/14/24.
//

import UIKit

class UserListViewController: UIViewController {
    private let viewModel: UserListViewModelProtocol
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

