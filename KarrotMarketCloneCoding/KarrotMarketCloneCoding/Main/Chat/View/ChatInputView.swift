//
//  ChatInputView.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 7/7/23.
//

import UIKit
import SnapKit


class ChatInputView: UIView {
    let plusButton = UIButton(type: .system)
    let sendButton = UIButton()
    let messageTextView = UITextView()
    
    var plusButtonTapAction: () -> Void = {}
    var sendButtonTapAction: (String) -> Void = { Text in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        // 플러스 버튼 설정
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.setTitleColor(.systemGray3, for: .normal)

        // Send 버튼 설정
        sendButton.setImage(UIImage(named: "send"), for: .normal)

        // 텍스트 뷰 설정
        messageTextView.layer.cornerRadius = 20
        messageTextView.backgroundColor = .systemGray3.withAlphaComponent(0.3)
        messageTextView.font = .systemFont(ofSize: 18)
        messageTextView.textContainerInset = UIEdgeInsets(top: 9, left: 8, bottom: 9, right: 8)
        messageTextView.delegate = self

        // 서브뷰 추가
        addSubview(plusButton)
        addSubview(sendButton)
        addSubview(messageTextView)
        
        plusButton.addTarget(self, action: #selector(plusButtonDidTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonDidTapped), for: .touchUpInside)
    }
    
    @objc
    func plusButtonDidTapped() {
        plusButtonTapAction()
    }
    
    @objc
    func sendButtonDidTapped() {
        sendButtonTapAction(messageTextView.text)
        messageTextView.text = nil
    }
    private func setupConstraints() {
        // 플러스 버튼 제약 조건 설정
        plusButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(25)
            make.centerY.equalToSuperview()
        }

        // Send 버튼 제약 조건 설정
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.height.width.equalTo(25)
            make.centerY.equalToSuperview()
        }

        // 텍스트 뷰 제약 조건 설정
        messageTextView.snp.makeConstraints { make in
            make.leading.equalTo(plusButton.snp.trailing).offset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-16)
            make.top.bottom.equalToSuperview().inset(10)
            make.height.equalTo(40).priority(.low)
        }
    }
}

extension ChatInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 110 {
            adjustBottomViewHeight()
        }
    }
    
    private func adjustBottomViewHeight() {
        let size = CGSize(width: messageTextView.frame.width, height: .infinity)
        let estimatedSize = messageTextView.sizeThatFits(size)
        messageTextView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
