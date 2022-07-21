//
//  SearchBarBottomView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit

class SearchBarBottomView: UIView {
// MARK: - Properties
    
    let sortButton = UIButton()
    
// MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        addSubview(sortButton)
        
        sortButton.setTitle("정확도순", for: .normal)
        sortButton.setTitleColor(.black, for: .normal)
        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sortButton.backgroundColor = .systemGray5
        sortButton.layer.cornerRadius = 30 / 2
    }
    
// MARK: - Setup Constraints
    
    private func setUpConstraints() {
        sortButton.anchor(trailing: self.trailingAnchor, trailingConstant: 20,width: 80, height: 30)
        sortButton.centerY(inView: self)
    }
}
