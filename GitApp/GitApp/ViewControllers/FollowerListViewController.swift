//
//  FollowerListViewController.swift
//  GitApp
//
//  Created by Adrian Gutierrez on 15/01/26.
//

import UIKit

class FollowerListViewController: UIViewController {

    var username: String!
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<GFSection, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        // 1. IMPORTANTE: Configurar el DataSource ANTES de pedir datos
        configureDataSource()
        // 2. Pedir datos
        getFollowers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func getFollowers(username: String, page: Int) {
        isLoadingMoreFollowers = true
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingMoreFollowers = false
            
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = "Este usuario no tiene seguidores."
                    self.presentAlertOnMainThread(title: "Sin seguidores", message: message)
                    return
                }
                
                self.updateData(on: self.followers)
                
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<GFSection, Follower>()
        snapshot.appendSections([GFSection.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func configureDataSource() {
        // CORRECCIÓN CRÍTICA PARA SWIFT 6:
        // Debes especificar explícitamente los tipos (UICollectionView, IndexPath, Follower)
        // en el closure. Si no lo haces, el compilador falla al inferir el aislamiento de memoria.
        dataSource = UICollectionViewDiffableDataSource<GFSection, Follower>(
            collectionView: collectionView,
            cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, follower: Follower) -> UICollectionViewCell? in
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
                cell.set(follower: follower)
                return cell
            }
        )
    }
    
    @objc func addButtonTapped() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                PersistenceManager.updateWith(favorite: user, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    
                    guard let error = error else {
                        self.presentAlertOnMainThread(title: "¡Éxito!", message: "Has guardado a este usuario en favoritos")
                        return
                    }
                    
                    self.presentAlertOnMainThread(title: "Algo salió mal", message: error.localizedDescription)
                }
                
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Algo salió mal", message: error.localizedDescription)
            }
        }
    }
}

extension FollowerListViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}

struct UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
