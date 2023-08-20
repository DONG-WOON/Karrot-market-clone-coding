//
//  NewPostTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit
import PhotosUI
import Alamofire

final class NewPostTableViewController: UIViewController {
    
    private let newPostViewModel = NewPostViewModel()
    
    private var selectedImages: [UIImage] = [UIImage]() {
        didSet {
            maxChoosableImages = 10 - selectedImages.count
            newPostTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }
    private var item = Item() {
        didSet {
            if item.preferPlace?.alias != nil {
                newPostTableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
            }
        }
    }
    
    var maxChoosableImages = 10
    var doneButtonTapped: () -> () = { }
    
    private let newPostTableView = NewPostTableView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        newPostTableView.delegate = self
        newPostTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeImage), name: .imageRemoved, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupNaviBar()
    }
    
    private func setupNaviBar() {
        title = "중고거래 글쓰기"
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(post))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.appColor(.carrot)
    }
    
    private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = maxChoosableImages
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension NewPostTableViewController {
    
    @objc func removeImage(_ notification: NSNotification) {
        
        if let indexPath = notification.userInfo?[UserInfo.indexPath] as? IndexPath {
            selectedImages.remove(at: indexPath.item - 1)
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        view.endEditing(true)
        
        if item.title == nil || item.title == "" {
            let alert = SimpleAlertController(message: "제목을 입력해주세요.")
            present(alert, animated: true)
            return
        }
        
        if item.category == nil {
            let alert = SimpleAlertController(message: "카테고리를 선택해주세요.")
            present(alert, animated: true)
            return
        }
        
        if item.content == nil || item.content == "" {
            let alert = SimpleAlertController(message: "내용을 입력해주세요.")
            present(alert, animated: true)
            return
        }
        
        if item.preferPlace == nil {
            let alert = SimpleAlertController(message: "거래장소를 입력해주세요.")
            present(alert, animated: true)
            return
        }
        
        Task {
            activityIndicator.startAnimating()
            let result = await newPostViewModel.registerItem(item: item, images: selectedImages)
            switch result {
            case .success:
                activityIndicator.stopAnimating()
                NotificationCenter.default.post(name: .updateItemList, object: nil)
                self.dismiss(animated: true)
            case .failure(let error):
                self.presentError(error: error)
            }
        }
    }
}

extension NewPostTableViewController {
    private func configureViews() {
        
        view.addSubview(newPostTableView)
        view.addSubview(activityIndicator)
        view.backgroundColor = .white
        
        newPostTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.equalTo(50)
        }
    }
}

extension NewPostTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return 90
        case 1...3: return 55
        case 4: return 200
        case 5: return 55
        default: return  UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosSelectingTableViewCell.identifier, for: indexPath) as! PhotosSelectingTableViewCell
            
            cell.collectionView.photoPickerCellTapped = { [weak self] sender in
                self?.setupImagePicker()
            }
            cell.collectionView.images = selectedImages
            cell.selectionStyle = .none
            cell.clipsToBounds = false
            
            return cell
            
        } else if indexPath.row == 1  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
            
            cell.selectionStyle = .none
            cell.textChanged = { self.item.title = $0 }
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath)
            
            cell.textLabel?.text = "카테고리 선택"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.identifier, for: indexPath) as! PriceTableViewCell
            
            cell.selectionStyle = .none
            cell.textChanged = { self.item.price = Int($0 ?? "0") ?? 0 }
            
            return cell
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
            
            cell.selectionStyle = .none
            cell.textChanged = { self.item.content = $0 }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationSelectTableViewCell.identifier, for: indexPath) as!
            LocationSelectTableViewCell
            
            cell.textLabel?.text = "거래 희망 장소"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.location = item.preferPlace?.alias
            
            return cell
        }
    }
}

extension NewPostTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            
            if let cell = tableView.cellForRow(at: indexPath) as? BasicTableViewCell {
                
                let vc = CategoryTableViewController()
                
                vc.cellTapped = { indexPathRow in
                    
                    cell.textLabel?.text = "\(vc.categories[indexPathRow].translatedKorean)"
                    self.item.category = Category.allCases[indexPathRow]
                    vc.tableView.reloadRows(at: [indexPath], with: .fade)
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if indexPath.row == 5 {
            let mapvVC = MapViewController()
            mapvVC.locationIsSelctedAction = { locationInfo in
                self.item.preferPlace = locationInfo
            }
            mapvVC.modalPresentationStyle = .fullScreen
            present(mapvVC, animated: true)
        }
    }
}

extension NewPostTableViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        results.forEach { result in
            
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    DispatchQueue.main.async { self.selectedImages.append((image as? UIImage)!) }
                }
            } else {
                print("이미지 못 불러왔음!!!!")
            }
        }
    }
}
