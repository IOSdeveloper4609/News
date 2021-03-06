//
//  SearchViewController.swift
//  News
//
//  Created by Азат Киракосян on 01.08.2021.
//

import UIKit
import Hero

final class SearchViewController: UIViewController {
    
    private var networkManager = NetworkManager()
    private var networkMonitor = NetworkMonitor.shared
    private var searchResultsArray = [Article]()
    private var isLoading = false
    private let spinner = UIActivityIndicatorView()
        
    private lazy var mainTableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .singleLine
        tv.backgroundColor = .white
        tv.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.delegate = self
        sc.searchBar.returnKeyType = .search
        
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if !networkMonitor.isConnected {
            showAlert(Message: "Для поиска новостей включите интернет")
        }
    }
    
}

// MARK: - Private
private extension SearchViewController {
    
    func setupUI() {
        navigationItem.searchController = searchController
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Поиск новостей"
        setupMainTableView()
    }
        
    func setupMainTableView() {
        view.addSubview(mainTableView)
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 70),
            mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func openDetailedScreen(index: Int) {
        navigationController?.isHeroEnabled = true
        let detailViewController = DetailedViewController()
        detailViewController.model = searchResultsArray[safe: index]
        detailViewController.heroModalAnimationType = .selectBy(presenting: .zoom, dismissing: .fade)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func showAlert(Message: String){
        let alert = UIAlertController(title: "Ошибка", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    func getData() {
        if isLoading {
            return
        }
        
        isLoading = true
        
        let searchValue = searchController.searchBar.text?.lowercased() ?? ""
        
        let perPage = 10
        let page = searchResultsArray.count / perPage + 1
        
        networkManager.getObject(page: page, pageSize: perPage, value: searchValue) { [weak self] results in
            self?.searchResultsArray.append(contentsOf: results)
            DispatchQueue.main.async  {
                self?.mainTableView.reloadData()
                self?.mainTableView.tableFooterView = self?.hideSpinnerFooter()
                self?.isLoading = false
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension SearchViewController:  UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            assertionFailure("this cell is missing")
            return UITableViewCell()
        }
        
        guard let model = searchResultsArray[safe: indexPath.row] else {
            assertionFailure("missing index outside the range")
            return UITableViewCell()
        }
        
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

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultsArray.removeAll()
        getData()
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchCell {
            cell.setupAnimationAvatar(param: searchResultsArray[safe: indexPath.row]?.title ?? "")
            openDetailedScreen(index: indexPath.row)
        }
    }
    
}


// MARK: - UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !searchResultsArray.isEmpty else {
            return
        }
        
        let position = scrollView.contentOffset.y
        if position > self.mainTableView.contentSize.height - scrollView.frame.size.height {
            mainTableView.tableFooterView = setupSpinnerFooter()
            getData()
            
        }
    }
}
