//
//  ChatViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2023/07/01.
//

import UIKit

typealias ChatViewDataSource = UITableViewDiffableDataSource<Section, ChatMessage>
typealias ChatViewSnapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>
typealias ChatViewCellProvider = (UITableView, IndexPath, ChatMessage) -> UITableViewCell

class ChatViewController: UIViewController {
    var viewModel = ChatViewModel()
    let myEmail = "aa"
    // MARK: - Private Properties
    private let chatTableView = UITableView()
    
    private var dataSource: ChatViewDataSource?
    private var snapshot = ChatViewSnapshot()
    private var cellProvider: ChatViewCellProvider!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        cellProvider = { [self] (tableView, indexPath, item) in
            
            if viewModel.chats[indexPath.row].email == myEmail {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell", for: indexPath) as? MyChatCell else { fatalError() }
                cell.messageLabel.text = viewModel.chats[indexPath.row].message
                cell.dateLabel.text = viewModel.chats[indexPath.row].date.formatToString()
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpponentChatCell", for: indexPath) as? OpponentChatCell else { fatalError() }
                
                cell.messageLabel.text = viewModel.chats[indexPath.row].message
                cell.dateLabel.text = viewModel.chats[indexPath.row].date.formatToString()
                
                return cell
            }
        }
        
        dataSource = ChatViewDataSource(tableView: chatTableView, cellProvider: cellProvider)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        snapshot.appendSections([Section.main])
        snapshot.appendItems(viewModel.chats)
        
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    //    @objc open dynamic func keyboardWillShow(_ notification: Notification) {
    //        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    //
    //        let keyboardHeight = keyboardFrame.cgRectValue.height
    //
    //        containerViewBottomLayout.isActive = false
    //        containerViewBottomLayout.constant = -keyboardHeight + view.safeAreaInsets.bottom
    //        containerViewBottomLayout.isActive = true
    //
    //        self.conversationTableView.scrollToBottom(animated: true)
    //    }
    //
    //    @objc open dynamic func keyboardWillHide(_ notification: Notification) {
    //
    //        containerViewBottomLayout.isActive = false
    //        containerViewBottomLayout.constant = 0
    //        containerViewBottomLayout.isActive = true
    //    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(chatTableView)
        
        chatTableView.dataSource = dataSource
        chatTableView.separatorStyle = .none
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = UITableView.automaticDimension
        chatTableView.register(MyChatCell.self, forCellReuseIdentifier: "MyChatCell")
        chatTableView.register(OpponentChatCell.self, forCellReuseIdentifier: "OpponentChatCell")
        
        chatTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


