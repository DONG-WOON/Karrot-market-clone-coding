//
//  ItemDetailViewDescriptionCell.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/18.
//

import UIKit

class ItemDetailViewDescriptionCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "ItemDetailViewDescriptionCell"
    
    private let itemTitleLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        
        return lbl
    }()
    private let itemCategoryButton: UIButton = {
        
        let btn = UIButton()
        let attributedString = NSMutableAttributedString(string: "", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 13)])
        
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.setTitleColor(UIColor.systemGray2, for: .normal)
        
        return btn
    }()
    private let itemDescriptionTextView: UITextView = {
        
        let tv = UITextView()
        
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        tv.textContainer.lineFragmentPadding = 0
        
        return tv
    }()
    private let extraInfoLabel: UILabel = {
        
        let lbl = UILabel()
        
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .systemGray2
        
        return lbl
    }()
    
    // MARK: - Actions
    
    func configure(with item: FetchedItemDetail?) {
        
        guard let item = item else { return }
        guard let category = item.category else { return }
        
        let attributeString = NSMutableAttributedString(string: "\(category.translatedKorean)", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 13)])
        
        itemTitleLabel.text = item.title
        itemCategoryButton.setAttributedTitle(attributeString, for: .normal)
        itemDescriptionTextView.text = item.content
        extraInfoLabel.text = "0 chats, \(item.favoriteUserCount) favorites, \(item.views) views"
    }
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        
        addSubview(itemTitleLabel)
        addSubview(itemCategoryButton)
        addSubview(itemDescriptionTextView)
        addSubview(extraInfoLabel)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        itemTitleLabel.anchor(top: self.topAnchor, topConstant: 20, leading: self.leadingAnchor, leadingConstant: 15)
        itemCategoryButton.anchor(top: itemTitleLabel.bottomAnchor, topConstant: 15, leading: itemTitleLabel.leadingAnchor)
        itemDescriptionTextView.anchor(top: itemCategoryButton.bottomAnchor, topConstant: 15, leading: itemCategoryButton.leadingAnchor, trailing: self.trailingAnchor, trailingConstant: 20)
        extraInfoLabel.anchor(top: itemDescriptionTextView.bottomAnchor, topConstant: 15, bottom: self.bottomAnchor, bottomConstant: 30, leading: itemCategoryButton.leadingAnchor)
    }
}
