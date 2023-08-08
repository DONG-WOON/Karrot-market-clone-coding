//
//  ChatViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2023/07/01.
//

import UIKit
import StompClientLib

typealias ChatViewDataSource = UITableViewDiffableDataSource<Section, ChatMessage>
typealias ChatViewSnapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>
typealias ChatViewCellProvider = (UITableView, IndexPath, ChatMessage) -> UITableViewCell

class ChatViewController: UIViewController {
    var viewModel = ChatViewModel()
    let opponent: String
    var shouldScrollToBottom = true
    var myEmail = "aa"
    private var socketClient = StompClientLib()
    
    // MARK: - Private Properties
    
    private let chatTableView = UITableView()
    private let chatInputView = ChatInputView()
    
    private var dataSource: ChatViewDataSource?
    private var snapshot = ChatViewSnapshot()
    private var cellProvider: ChatViewCellProvider!
    
    private var scrollToIndexPath: IndexPath?
    
    // MARK: - Life Cycle
    
    init(opponent: String) {
        self.opponent = opponent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = opponent
        configureViews()
        
        
//        WebSocketManager.shared.
//
        cellProvider = { [self] (tableView, indexPath, item) in

            if viewModel.chats[indexPath.row].email == myEmail {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell", for: indexPath) as? MyChatCell else { fatalError() }
                cell.messageLabel.text = viewModel.chats[indexPath.row].message
                cell.dateLabel.text = viewModel.chats[indexPath.row].createDateTime.formatToString()
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpponentChatCell", for: indexPath) as? OpponentChatCell else { fatalError() }

                cell.messageLabel.text = viewModel.chats[indexPath.row].message
                cell.dateLabel.text = viewModel.chats[indexPath.row].createDateTime.formatToString()
               
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
        
        enableTapGesture()
        
        self.dataSource?.apply(snapshot, animatingDifferences: true)
        
        chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    
        scrollToIndexPath = IndexPath(row: 13, section: 0)
        
        chatTableView.scrollsToTop = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
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
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(chatTableView)
        view.addSubview(chatInputView)
        
        chatInputView.plusButtonTapAction = {
            print(#function)
        }
        
        chatInputView.sendButtonTapAction = { text in
            let sendMessagePath = "app/chat/test@ruu.kr/domb@ruu.kr"
            
            self.socketClient.sendMessage(message: "sdsd", toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        }
        
        chatTableView.dataSource = dataSource
        chatTableView.separatorStyle = .none
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = UITableView.automaticDimension
        chatTableView.register(MyChatCell.self, forCellReuseIdentifier: "MyChatCell")
        chatTableView.register(OpponentChatCell.self, forCellReuseIdentifier: "OpponentChatCell")
        
        
        chatTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        chatInputView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(chatTableView.snp.bottom)
        }
    }
}

extension ChatViewController: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("🔥 ", #function)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("🔥 ", #function)
        let subscribePath = "queue/message/test@ruu.kr/domb@ruu.kr"
//        let sendMessagePath = "app/chat/domb@ruu.kr/test@ruu.kr"
        socketClient.subscribe(destination: subscribePath)
        
//        socketClient.sendMessage(message: "sdsd", toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("🔥 ", #function)
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("🔥 ", #function)
    }
    
    func serverDidSendPing() {
        print("🔥 ", #function)
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("🔥 ", #function)
    }
}

//extension ChatViewController: URLSessionWebSocketDelegate {
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
//        let senderEmail = myEmail
//        let receiverEmail = opponent
//
//        webSocketTask.send(.string("SUBSCRIBE\nid:sub-0\ndestination:/queue/messages\nemail:\(senderEmail)\n\n")) { error in
//            print(error?.localizedDescription)
//        }
//    }
//
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        print(closeCode, "\n", reason)
//    }
//}
//
//
