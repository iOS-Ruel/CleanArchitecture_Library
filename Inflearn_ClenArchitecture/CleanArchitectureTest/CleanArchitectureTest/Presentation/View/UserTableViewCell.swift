//
//  UserTableViewCell.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/24/24.
//

import UIKit
import Kingfisher
import RxSwift

final class UserTableViewCell: UITableViewCell, UserListCellProtocol {
    static let id = "UserTableViewCell"
    public var disposeBag = DisposeBag() 
    
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderColor = UIColor.systemGray.cgColor
        iv.layer.borderWidth = 0.5
        iv.layer.cornerRadius = 6
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    public let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(userImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(favoriteButton)
        
        
        userImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalTo(80).priority(.high)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.top)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-20)
        }
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    func apply(cellData: UserListCellData) {
        guard case let .user(user, isFavorite) = cellData else { return }
        nameLabel.text = "\(user.login)"
        
        userImageView.kf.setImage(with: URL(string: user.imageURL))
        favoriteButton.isSelected = isFavorite
    }
    
    
    
}
