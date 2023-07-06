//
//  ChatRoomListViewCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2023/07/01.
//

import UIKit

struct Chat {
    let nickname = "라일락허벤"
    let latestMessage = "맛있게 드세요~"
    let thumbnailImage = UIImage(named: "karrot-1")
    let profileImage = UIImage(named: "karrot-2")
}

class ChatRoomListViewCell: UITableViewCell {
    
    let defaultChat = Chat()
    
    ///프로필이미지
    let profileImageView = UIImageView(image: UIImage(named: "defaultProfileImage"))
    ///닉네임, 주소, 시간
    var nicknameLabel = UILabel()
    ///가장 최근 채팅문자
    var latestMessageLabel = UILabel()
    ///상품 썸네일이미지
    var itemThumbnailImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        self.selectionStyle = .none
        configureViews()
        
        nicknameLabel.text = defaultChat.nickname
        latestMessageLabel.text = defaultChat.latestMessage
        itemThumbnailImageView.image = defaultChat.thumbnailImage
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(latestMessageLabel)
        contentView.addSubview(itemThumbnailImageView)
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 0.1
        
        nicknameLabel.textColor = .black
        nicknameLabel.numberOfLines = 1
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        latestMessageLabel.textColor = .black
        latestMessageLabel.numberOfLines = 1
        latestMessageLabel.font = UIFont.systemFont(ofSize: 16)
        
        itemThumbnailImageView.contentMode = .scaleAspectFill
        itemThumbnailImageView.layer.cornerRadius = 5
        itemThumbnailImageView.clipsToBounds = true
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.snp.leading).inset(15)
            make.height.width.equalTo(50)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(contentView).inset(17)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        latestMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel)
            make.height.equalTo(20)
            make.bottom.equalTo(contentView).inset(17)
        }
        
        itemThumbnailImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(20)
            make.width.height.equalTo(40)
        }
    }
}

