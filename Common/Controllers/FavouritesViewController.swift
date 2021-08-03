//
//  FavouritesViewController.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import UIKit
import RealmSwift
import SafariServices

final class FavouritesViewController: UIViewController {
    
    private let databaseManager = DatabaseManager.shared
    private let networkManager = NetworkManager()
    private var favouritesArray = [SourceObject]()
    private var token: NotificationToken?
    
    private lazy var mainTableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.separatorStyle = .singleLine
        tv.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getObjectsFromTheDatabase()
    }
    
}

// MARK: - Private
private extension FavouritesViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Избраннoе"
        setupMainTableView()
        addBarButtonItem()
    }
    
    func setupMainTableView() {
        view.addSubview(mainTableView)
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor),
            mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func getObjectsFromTheDatabase() {
        guard let objects = databaseManager.safeRealm?.objects(SourceObject.self) else {
            return
        }
        
        token = objects.observe { [weak self] change in
            switch change {
            case .update(let collectionType, _, _, _):
                self?.favouritesArray = collectionType.compactMap { $0.isFavourite ? $0 : nil }

                DispatchQueue.main.async {
                    self?.mainTableView.reloadData()
                }
            default: ()
            }
        }

        favouritesArray = objects.compactMap {
            $0.isFavourite ? $0 : nil
        }

        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    func addBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "news"), style: .done, target: self, action: #selector(openAllNewsScreen))
    }
    
}

// MARK: - Actions
private extension FavouritesViewController {
    
    @objc func openAllNewsScreen() {
        let detailViewController = NewsViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.identifier, for: indexPath) as? FavouriteCell else {
            assertionFailure("this cell is missing")
            return UITableViewCell()
        }
        
        guard let model = favouritesArray[safe: indexPath.row] else {
            assertionFailure("missing index outside the range")
            return UITableViewCell()
        }
        
        cell.setupWithModel(model: model)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = favouritesArray[safe: indexPath.row]
            DatabaseManager.shared.write {
                object?.isFavourite.toggle()
            }
            self.favouritesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - OpenLinkDelegate
extension FavouritesViewController: OpenLinkDelegate {
    
    func openLinkButtonTapped(model: SourceObject) {
        if let url = URL(string: model.url ?? "") {
            let result = SFSafariViewController(url: url)
            present(result, animated: true, completion: nil)
            print(result)
        }
    }
    
}
