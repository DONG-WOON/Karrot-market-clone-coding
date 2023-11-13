//
//  ChatViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2023/07/01.
//

import UIKit
import StompClientLib

typealias ChatViewDataSource = UITableViewDiffableDataSource<Section, Message>
typealias ChatViewSnapshot = NSDiffableDataSourceSnapshot<Section, Message>
typealias ChatViewCellProvider = (UITableView, IndexPath, Message) -> UITableViewCell

class ChatViewController: UIViewController {

    var viewModel: ChatViewModel
    
    // MARK: - Private Properties
    
    private let chatTableView = UITableView()
    private let chatInputView = ChatInputView()
    private var dataSource: ChatViewDataSource!
    private var snapshot = ChatViewSnapshot()
    private var cellProvider: ChatViewCellProvider!
    private var scrollToIndexPath: IndexPath?
    
    // MARK: - Life Cycle
    
    init(chatroom: ChatRoom) {
        self.viewModel = ChatViewModel(chatRoom: chatroom)
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(reloadChatLog),
            name: .receiveMessage, object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureTableView()
        firstSnapshot()
        
        Task {
            await viewModel.fetchChatLog() {
                DispatchQueue.main.async { [weak self] in
                    self?.firstSnapshot()
                }
            }
        }
        
        chatInputView.sendButtonTapAction = { [weak self] text in
            guard let self else { return }
            self.viewModel.sendMessage(text: text) { [weak self] message in
                self?.takeSnapshot([message])
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        viewModel.webSocketManager.disconnect()
    }
    
    // MARK: - Actions
    
    @objc
    private func reloadChatLog() {
        takeSnapshot(viewModel.chats)
    }
    
    private func firstSnapshot() {
        var snapshot = ChatViewSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.chats, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func takeSnapshot(_ items: [Message]) {
        if viewModel.chats.first != nil {
            viewModel.chats.insert(contentsOf: items, at: 0)
        } else {
            viewModel.chats.append(contentsOf: items)
        }
        var snapshot = ChatViewSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.chats, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
        if !viewModel.chats.isEmpty {
            chatTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc
    private func pullKeyboard() {
        self.view.endEditing(true)
    }

    private func enableTapGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pullKeyboard))

        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false

        chatTableView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
}
    // MARK: - Configure
    
extension ChatViewController {
    
    private func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(chatTableView)
        view.addSubview(chatInputView)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pullKeyboard)))
        
        chatTableView.dataSource = dataSource
        chatTableView.separatorStyle = .none
        chatTableView.rowHeight = UITableView.automaticDimension
        
        chatTableView.register(MyChatCell.self, forCellReuseIdentifier: "MyChatCell")
        chatTableView.register(OpponentChatCell.self, forCellReuseIdentifier: "OpponentChatCell")
        
        
        chatTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        chatInputView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(chatTableView.snp.bottom)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    private func configureTableView() {
        cellProvider = { [weak self] (tableView, indexPath, item) in
            guard let self else { return UITableViewCell() }
            if item.senderNickname == viewModel.chatroom.chatMateNickname {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpponentChatCell", for: indexPath) as? OpponentChatCell else { fatalError() }
                cell.messageLabel.text = item.message
                cell.dateLabel.text = item.createDateTime
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell", for: indexPath) as? MyChatCell else { fatalError() }
                
                cell.messageLabel.text = item.message
                cell.dateLabel.text = item.createDateTime
                
                return cell
            }
        }
        
        dataSource = ChatViewDataSource(tableView: chatTableView, cellProvider: cellProvider)
        
        chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        chatTableView.scrollsToTop = true
    }
}
