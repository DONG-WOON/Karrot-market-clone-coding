//
//  ChatCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2023/07/01.
//

import UIKit

class ChatCell: UITableViewCell {
    // MARK: - Properties
    
    var isFirstMessage: Bool = true
    
    let profileImageView = UIImageView(image: UIImage(named: "defaultProfileImage"))
    let messageLabel = PaddingLabel()
    let dateLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    // MARK: - ConfigureViews
    
    private func configureViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        messageLabel.layer.cornerRadius = 20
        messageLabel.clipsToBounds = true
        messageLabel.numberOfLines = 0
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
}

class MyChatCell: ChatCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.isHidden = true
        messageLabel.backgroundColor = .appColor(.carrot)
        messageLabel.textColor = .white
        
        messageLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(10)
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.lessThanOrEqualTo(profileImageView.snp.trailing).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OpponentChatCell: ChatCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.backgroundColor = .systemGray4.withAlphaComponent(0.2)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(15)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.bottom.equalTo(contentView).inset(10)
            make.trailing.lessThanOrEqualTo(contentView).inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


