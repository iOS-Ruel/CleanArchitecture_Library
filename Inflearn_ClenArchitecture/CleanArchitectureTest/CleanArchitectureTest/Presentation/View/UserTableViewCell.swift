//
//  UserTableViewCell.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/24/24.
//

import UIKit
import Kingfisher

final class UserTableViewCell: UITableViewCell {
    static let id = "UserTableViewCell"
    
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
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(userImageView)
        self.addSubview(nameLabel)
        userImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(80)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.top)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func apply(cellData: UserListCellData) {
        guard case let .user(user, userFavorite) = cellData else { return }
        nameLabel.text = user.login
        
        userImageView.kf.setImage(with: URL(string: user.imageURL))
    }
    
    
    
}
