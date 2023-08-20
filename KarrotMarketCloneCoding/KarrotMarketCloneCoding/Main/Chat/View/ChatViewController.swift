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
        
        NotificationCenter.default.addObserver(forName: .receiveMessage, object: nil, queue: .main) { [weak self] notification in
            guard let self else { return }
            guard let message = notification.object as? Message else { return }
            viewModel.receiveMessage(message: message)
            var snapshot = self.dataSource.snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(viewModel.chats, toSection: .main)
            dataSource.apply(snapshot)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureTableView()
        
        Task {
            await viewModel.fetchChatLog() {
                DispatchQueue.main.async { [self] in
                    snapshot.appendSections([Section.main])
                    snapshot.appendItems(viewModel.chats)
                    dataSource.apply(snapshot, animatingDifferences: false)
                }
            }
        }
        
        chatInputView.plusButtonTapAction = {
            print(#function)
        }
        
        chatInputView.sendButtonTapAction = { [weak self] text in
            guard let self else { return }
            self.viewModel.sendMessage(text: text) { message in
                var snapshot = self.dataSource.snapshot()
                snapshot.appendItems([message], toSection: .main)
                self.dataSource?.apply(snapshot)
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
        cellProvider = { [self] (tableView, indexPath, item) in
            
            if viewModel.chats[indexPath.row].senderNickname == viewModel.chatroom.chatMateNickname {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpponentChatCell", for: indexPath) as? OpponentChatCell else { fatalError() }
                cell.messageLabel.text = viewModel.chats[indexPath.row].message
                cell.dateLabel.text = viewModel.chats[indexPath.row].createDateTime
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell", for: indexPath) as? MyChatCell else { fatalError() }
                
                cell.messageLabel.text = viewModel.chats[indexPath.row].message
                cell.dateLabel.text = viewModel.chats[indexPath.row].createDateTime
                
                return cell
            }
        }
        
        dataSource = ChatViewDataSource(tableView: chatTableView, cellProvider: cellProvider)
        
        chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        chatTableView.scrollsToTop = true
    }
}
