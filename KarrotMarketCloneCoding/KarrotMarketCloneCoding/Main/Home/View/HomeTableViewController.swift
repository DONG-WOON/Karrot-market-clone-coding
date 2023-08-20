//
// HomeTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/21.
//

import UIKit
import Alamofire

typealias TableViewDataSource = UITableViewDiffableDataSource<Section, FetchedItem>
typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<Section, FetchedItem>
typealias TableViewCellProvider = (UITableView, IndexPath, FetchedItem) -> UITableViewCell

class HomeTableViewController: UIViewController {
    // MARK: - Properties
    
    var viewModel = HomeTableViewModel()
    var isViewBusy = false {
        didSet {
//            isViewBusy ? itemTableView.refreshControl?.beginRefreshing() :  itemTableView.refreshControl?.endRefreshing()
        }
    }
    
    private var dataSource: TableViewDataSource!
    private var snapshot = TableViewSnapshot()
    private var cellProvider: TableViewCellProvider!
    
    private let itemTableView = UITableView()
    private let addPostButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    private let refresh = UIRefreshControl()
    
    // MARK: - Actions
    
    @objc func searchButtonDidTapped() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func notiButtonDidTapped() {
        let notificationVC = NotificationViewController()
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func addButtonDidTapped() {
        let newPostVC = NewPostTableViewController()
        let nav = UINavigationController(rootViewController: newPostVC)
        
        nav.modalPresentationStyle  = .fullScreen
        
        newPostVC.doneButtonTapped = { [weak self] in
            Task {
                guard let self else { return }
                self.viewModel.latestPage = nil
                self.fetchItems()
            }
        }
        
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureViews()
        setupNavigationItems()
        setButton()
        setupTableView()
        
        fetchItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchItems), name: .updateItemList, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc
    private func fetchItems() {
//        isViewBusy = true
        let item = FetchedItem(imageURL: "", id: 123, title: "당근마켓", price: 0, createDateTime: "23.10.25", townName: "가산동", salesState: "판매중", favoriteUserCount: 2, chatCount: 2)
        
        var snapshot = TableViewSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems([item])
        dataSource.apply(snapshot)
        
        
//        Task {
//            let result = await viewModel.fetchItems()
//
//            switch result {
//            case .success(let fetchedItemListData):
//                guard let fetchedItemListData = fetchedItemListData else { return }
//                var snapshot = NSDiffableDataSourceSnapshot<Section, FetchedItem>()
//
//                snapshot.appendSections([Section.main])
//                snapshot.appendItems(fetchedItemListData.content)
//
//                await self.dataSource.apply(snapshot, animatingDifferences: false)
//
//                self.isViewBusy = false
//
//            case .failure(let error):
//                print(error)
//                SceneController.shared.logout()
//            }
//        }
    }
    
    // MARK: - Setup
    
    private func setupNavigationItems() {
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonDidTapped))
        let notiBarButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(notiButtonDidTapped))
        
        searchBarButton.tintColor = .label
        notiBarButton.tintColor = .label
        
        navigationItem.rightBarButtonItems = [ searchBarButton, notiBarButton ]
    }
    
    private func setupTableView() {
        itemTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        itemTableView.separatorColor = .systemGray5
        itemTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        itemTableView.backgroundColor = .white
        
        cellProvider = { (tableView, indexPath, item) in

           let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell

           cell.item = item

           return cell
       }
        
        dataSource = TableViewDataSource(tableView: itemTableView, cellProvider: cellProvider)
        
        itemTableView.delegate = self
        itemTableView.dataSource = dataSource
        itemTableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(fetchItems), for: .valueChanged)
    }
    
    private func setButton() {
        addPostButton.backgroundColor = .white
        addPostButton.layer.cornerRadius = 60 / 2
        addPostButton.clipsToBounds = true
        addPostButton.setImage(UIImage(named: "plusButton"), for: .normal)
        addPostButton.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - Configure UI
    
    private func configureViews() {
        view.backgroundColor = .white
        view.addSubview(itemTableView)
        view.addSubview(addPostButton)
        
        itemTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        addPostButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}

// MARK: - UITableViewDelegate

extension HomeTableViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !scrollView.frame.isEmpty && scrollView.contentOffset.y >= scrollView.frame.size.height {
            
            let contentHeight = scrollView.contentSize.height
            let yOffsetOfScrollView = scrollView.contentOffset.y
           
            let heightRemainFromBottom = contentHeight - yOffsetOfScrollView
            let frameHeight = scrollView.frame.size.height
            
            if heightRemainFromBottom < frameHeight, heightRemainFromBottom > 0, let fetchedItemCount = viewModel.fetchedItemCount, fetchedItemCount == 10 {
                Task {
                    await viewModel.fetchItems()
                }
            }
        }
        
//        if indexPaths.contains(where: { $0.item == videoList.count - 1 }) && page < 15 && !isEndPage {
//            page += 1
//            print("🔥 ",#function)
//            callRequest(searchText: searchBar.text!, page: page)
//        }
//        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productId = dataSource.itemIdentifier(for: indexPath)?.id else { return }
        let nextVC = ItemDetailViewController(productID: productId)
        navigationController?.pushViewController(nextVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
