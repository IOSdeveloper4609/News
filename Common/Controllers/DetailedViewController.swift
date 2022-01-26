//
//  DetailedViewController.swift
//  News
//
//  Created by Азат Киракосян on 30.07.2021.
//

import UIKit
import SDWebImage
import SafariServices

final class DetailedViewController: UIViewController {
    
    var model: Article?
    
    private lazy var myScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var scrollConteinerView: UIView = {
        let conteinerView = UIView()
        conteinerView.backgroundColor = .white
        conteinerView.translatesAutoresizingMaskIntoConstraints = false
        
        return conteinerView
    }()
    
    private lazy var openlinkButton: UIButton = {
        let b = UIButton()
        b.setTitleColor(.systemBlue, for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 18)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .systemBlue
        b.layer.cornerRadius = 25
        b.clipsToBounds = true
        b.layer.masksToBounds = true
        b.setTitleColor(.white, for: .normal)
        b.setTitle("перейти", for: .normal)
        b.contentMode = .scaleToFill
        b.addTarget(self, action: #selector(openLink), for: .touchUpInside)
       
        return b
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 15
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    private lazy var conteinerView: UIView = {
        let ui = UIView()
        ui.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6572953345)
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.layer.cornerRadius = 10
        ui.clipsToBounds = true
        ui.layer.masksToBounds = true
        
        return ui
    }()
    
    private lazy var newsTitleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .systemBlue
        l.numberOfLines = 0
        l.font = UIFont(name: "Copperplate", size: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    private lazy var newsDescriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.numberOfLines = 0
        l.font = UIFont(name: "Copperplate", size: 17)
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    private lazy var shareDataButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "share"), for: .normal)
        b.contentMode = .scaleToFill
        b.addTarget(self, action: #selector(sharingData), for: .touchUpInside)
        
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

// MARK: - Private
extension DetailedViewController: UIScrollViewDelegate {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Описание"
        setupMyScrollView()
        setupConteinerScrollView()
        setupShareButton()
        setupAvatarImageView()
        setupConteinernView()
        setupNewsDescriptionLabel()
        setupTitleLabel()
        setupNewsData()
        setupLinkButton()
        
    }
        
    func setupMyScrollView() {
        view.addSubview(myScrollView)
        
        NSLayoutConstraint.activate([
            myScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            myScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            myScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            myScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupConteinerScrollView() {
        myScrollView.addSubview(scrollConteinerView)
    
        NSLayoutConstraint.activate([
            scrollConteinerView.leftAnchor.constraint(equalTo: myScrollView.leftAnchor),
            scrollConteinerView.topAnchor.constraint(equalTo: myScrollView.topAnchor),
            scrollConteinerView.rightAnchor.constraint(equalTo: myScrollView.rightAnchor),
            scrollConteinerView.bottomAnchor.constraint(equalTo: myScrollView.bottomAnchor),
            scrollConteinerView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor),
            scrollConteinerView.centerYAnchor.constraint(equalTo: myScrollView.centerYAnchor)
        ])
    }
    
    func setupAvatarImageView() {
        scrollConteinerView.addSubview(avatarImageView)
        
        view.addConstraints([
            avatarImageView.topAnchor.constraint(equalTo: shareDataButton.bottomAnchor, constant: 20),
            avatarImageView.leftAnchor.constraint(equalTo: scrollConteinerView.leftAnchor, constant: 20),
            avatarImageView.rightAnchor.constraint(equalTo: scrollConteinerView.rightAnchor, constant: -20),
            avatarImageView.heightAnchor.constraint(equalToConstant: 275)
        ])
    }
    
    func setupConteinernView() {
        avatarImageView.addSubview(conteinerView)
        
        NSLayoutConstraint.activate([
            conteinerView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -5),
            conteinerView.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor, constant: 5),
            conteinerView.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: -5),
            conteinerView.heightAnchor.constraint(equalToConstant: 110),
        ])
    }
    
    func setupNewsDescriptionLabel() {
        scrollConteinerView.addSubview(newsDescriptionLabel)
        
        view.addConstraints([
            newsDescriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            newsDescriptionLabel.leftAnchor.constraint(equalTo: scrollConteinerView.leftAnchor, constant: 25),
            newsDescriptionLabel.rightAnchor.constraint(equalTo: scrollConteinerView.rightAnchor, constant: -25),
        ])
    }
    
    func setupTitleLabel() {
        conteinerView.addSubview(newsTitleLabel)

        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 40),
            newsTitleLabel.leftAnchor.constraint(equalTo: conteinerView.leftAnchor, constant: 15),
            newsTitleLabel.rightAnchor.constraint(equalTo: conteinerView.rightAnchor, constant: -15)
        ])
    }
    
    func setupShareButton() {
        scrollConteinerView.addSubview(shareDataButton)
        
        view.addConstraints([
            shareDataButton.topAnchor.constraint(equalTo: scrollConteinerView.topAnchor, constant: 30),
            shareDataButton.rightAnchor.constraint(equalTo: scrollConteinerView.rightAnchor, constant: -15),
            shareDataButton.heightAnchor.constraint(equalToConstant: 26),
            shareDataButton.widthAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    func setupLinkButton() {
        scrollConteinerView.addSubview(openlinkButton)
        
        NSLayoutConstraint.activate([
            openlinkButton.topAnchor.constraint(equalTo: newsDescriptionLabel.bottomAnchor, constant: 30),
            openlinkButton.leftAnchor.constraint(equalTo: scrollConteinerView.leftAnchor, constant: 70),
            openlinkButton.rightAnchor.constraint(equalTo: scrollConteinerView.rightAnchor, constant: -70),
            openlinkButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupNewsData() {
        let avatarNews = model?.urlToImage
        newsTitleLabel.text = model?.title
        avatarImageView.heroID = model?.title
        avatarImageView.sd_setImage(with: avatarNews, completed: nil)
        newsDescriptionLabel.text = model?.description
    }
    
}

// MARK: - Actions
private extension DetailedViewController {
    
    @objc func sharingData() {
        
        guard let result = model?.url else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [result], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func openLink() {
        if let url = URL(string: model?.url ?? "" ) {
            let result = SFSafariViewController(url: url)
            present(result, animated: true, completion: nil)
            print(result)
        }
    }
    
}
