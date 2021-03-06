//
//  NewsViewController.swift
//  News
//
//  Created by Азат Киракосян on 31.07.2021.
//

import UIKit

final class NewsViewController: UIViewController, UITableViewDelegate {
    
    private var databaseManager = DatabaseManager.shared
    private var networkManager = NetworkManager()
    private var networkMonitor = NetworkMonitor.shared
    private var newsArray = [NewsObject]()
    private var isLoading = false
    private let spinner = UIActivityIndicatorView()
    
    private lazy var mainTableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = 300
        tv.separatorStyle = .singleLine
        tv.backgroundColor = .white
        tv.register(NewCell.self, forCellReuseIdentifier: NewCell.identifier)
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
            fetchNews()
            setupLayoutActivityIndicator()
            startActivityIndicator()
        } else {
            getObjectsFromTheDatabase()
        }
    }
    
}

// MARK: - Private
private extension NewsViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Новости"
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
    
    func fetchNews() {
        if isLoading {
            return
        }

        isLoading = true
        
        
        guard let objects = databaseManager.safeRealm?.objects(SourceObject.self).filter("isFavourite == true") else {
            return
        }
        
        let ids = objects.map { ($0.id ?? "") }.joined(separator: ",")
        
                let perPage = 10
                let page = newsArray.count / perPage + 1
       
        networkManager.getNews(page: page, pageSize: perPage, id: ids) { [weak self] result in
            DispatchQueue.main.async  {
                DatabaseManager.shared.saveNews(objects: result)
                self?.newsArray.append(contentsOf: result) 
                self?.stopActivityIndicator()
                self?.mainTableView.tableFooterView = self?.hideSpinnerFooter()
                self?.mainTableView.reloadData()
                self?.isLoading = false
            }
        }
    }
    
    func getObjectsFromTheDatabase() {
        guard let objects = databaseManager.safeRealm?.objects(NewsObject.self) else {
            return
        }
        for object in objects {
            newsArray.append(object)
        }
        
        mainTableView.reloadData()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func setupSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        spinner.backgroundColor = .black
        spinner.startAnimating()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        return footerView
    }
    
    func hideSpinnerFooter() -> UIView {
        spinner.stopAnimating()
        return spinner
    }
    
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewCell.identifier, for: indexPath) as? NewCell else {
            assertionFailure("this cell is missing")
            return UITableViewCell()
        }
        
        guard let model = newsArray[safe: indexPath.row] else {
            assertionFailure("missing index outside the range")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.setupWithModel(model: model)
        return cell
    }
    
}


// MARK: - UIScrollViewDelegate
extension NewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !newsArray.isEmpty else {
            return
        }
        
        let position = scrollView.contentOffset.y
        if position > self.mainTableView.contentSize.height - scrollView.frame.size.height {
            mainTableView.tableFooterView = setupSpinnerFooter()
            fetchNews()
        }
    }
}
