//
//  NewsViewController.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import UIKit
import RealmSwift

final class SourcesViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    private let databaseManager = DatabaseManager.shared
    private let networkMonitor = NetworkMonitor.shared
    private var sourcesArray = [SourceObject]()
    
    private lazy var mainTableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.separatorStyle = .singleLine
        tv.backgroundColor = .white
        tv.register(SourceCell.self, forCellReuseIdentifier: SourceCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .black
        
        return ai
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if networkMonitor.isConnected {
            fetchSources()
            startActivityIndicator()
            setupLayoutActivityIndicator()
        } else {
            getObjectsFromTheDatabase()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTableView.reloadData()
    }
    
}

// MARK: - Private
private extension SourcesViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Каналы новостей"
        setupMainTableView()
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
    
    func setupLayoutActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func fetchSources() {
        networkManager.getSources { [weak self] sources in
            DispatchQueue.main.async  {
                DatabaseManager.shared.saveSources(objects: sources)
                self?.sourcesArray = sources
                self?.mainTableView.reloadData()
                self?.stopActivityIndicator()
            }
        }
    }
    
    func getObjectsFromTheDatabase() {
        guard let objects = databaseManager.safeRealm?.objects(SourceObject.self) else {
            return
        }
        for object in objects {
            sourcesArray.append(object)
        }
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
}

// MARK: - UITableViewDataSource
extension SourcesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SourceCell.identifier, for: indexPath) as? SourceCell else {
            assertionFailure("this cell is missing")
            return UITableViewCell()
        }
        
        guard let model = sourcesArray[safe: indexPath.row] else {
            assertionFailure("missing index outside the range")
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.setupWithModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - AddToFavoritesDelegate
extension SourcesViewController: AddToFavoritesDelegate {
    
    func addToFavoritesButton(model: SourceObject) {
        DatabaseManager.shared.write {
            model.isFavourite.toggle()
        }
        mainTableView.reloadData()
    }
    
}


