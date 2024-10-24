//
//  TabButtonView.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/24/24.
//

import UIKit
import RxSwift
import RxCocoa


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
