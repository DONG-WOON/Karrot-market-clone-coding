//
//  ChatRoomListViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2023/07/01.
//

import UIKit

class ChatRoomListViewController: UIViewController {
    // MARK: - Properties
    
    let viewModel = ChatRoomListViewModel()
    let chatRoomListView = UITableView()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "채팅"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        return lbl
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        Task {
            let chat = await viewModel.fetchChatList()
        }
        //        fetchChatList()
    }

    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let notiBarButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notiButtonDidTapped))
        
        notiBarButton.tintColor = .label
        
        navigationItem.rightBarButtonItems = [notiBarButton]
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(chatRoomListView)
        
        chatRoomListView.delegate = self
        chatRoomListView.dataSource = self
        chatRoomListView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        chatRoomListView.rowHeight = 80
        chatRoomListView.backgroundColor = .white
        chatRoomListView.register(ChatRoomListViewCell.self, forCellReuseIdentifier: "ChatRoomListViewCell")
        
        chatRoomListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc
    func notiButtonDidTapped() {
        
    }
}

extension ChatRoomListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatRoomList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomListViewCell", for: indexPath) as? ChatRoomListViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤시 
    }
}
