//
//  UserListViewController.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let viewModel: UserListViewModelProtocol
    private let searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.systemGray.cgColor
        textfield.layer.cornerRadius = 6
        textfield.placeholder = "검색어를 입력해 주세요."
        let image = UIImageView(image: .init(systemName: "magnifyingglass"))
        image.frame = .init(x: 0, y: 0, width: 20, height: 20)
        textfield.leftView = image
        textfield.tintColor = .black
        textfield.leftViewMode = .always
        return textfield
    }()
    
    private let tabButtonView = TabButtonView(tabList: [.api, .favorite])
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        setupUI()
        bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(tabButtonView)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        tabButtonView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func bindView() {
        tabButtonView.selectedType
            .bind { type in
                print("button tap type:" , type)
            
        }
        .disposed(by: disposeBag)
    }


}

final class TabButtonView: UIStackView {
    
    private let tablist: [TabButtonType]
    private let disposeBag = DisposeBag()
    public let selectedType: BehaviorRelay<TabButtonType?>
    
    init(tabList: [TabButtonType]) {
        self.tablist = tabList
        self.selectedType = BehaviorRelay(value: tabList.first)
        super.init(frame: .zero)
        alignment = .fill
        distribution = .fillEqually
        
        addButton()
        (arrangedSubviews.first as? UIButton)?.isSelected = true
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButton() {
        tablist.forEach { tabType in
            let button = TabButton(type: tabType)
            button.rx.tap
                .bind { [weak self] in
                    self?.arrangedSubviews.forEach{ view in
                        (view as? UIButton)?.isSelected = false
                    }
                    button.isSelected = true
                    self?.selectedType.accept(tabType)
                }
                .disposed(by: disposeBag)
            addArrangedSubview(button)
        }
    }
}
final class TabButton: UIButton {
 
    private let type: TabButtonType
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .systemCyan
            } else {
                backgroundColor = .white
            }
        }
    }
    
    
    init(type: TabButtonType) {
        self.type = type
        super.init(frame: .zero)
        setTitle(type.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
