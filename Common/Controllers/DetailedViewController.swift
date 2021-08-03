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
private extension DetailedViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Описание"
        setupAvatarImageView()
        setupNewsDescriptionLabel()
        setupShareButton()
        setupConteinerView()
        setupTitleLabel()
        setupNewsData()
        setupLinkButton()
    }
        
    func setupNewsDescriptionLabel() {
        view.addSubview(newsDescriptionLabel)
        
        view.addConstraints([
            newsDescriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            newsDescriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            newsDescriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
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
    
    func setupConteinerView() {
        avatarImageView.addSubview(conteinerView)
        
        NSLayoutConstraint.activate([
            conteinerView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -5),
            conteinerView.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor, constant: 5),
            conteinerView.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: -5),
            conteinerView.heightAnchor.constraint(equalToConstant: 110),
        ])
    }
    
    func setupAvatarImageView() {
        view.addSubview(avatarImageView)
        
        view.addConstraints([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            avatarImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            avatarImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            avatarImageView.heightAnchor.constraint(equalToConstant: 275)
        ])
    }
    
    func setupShareButton() {
        view.addSubview(shareDataButton)
        
        view.addConstraints([
            shareDataButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            shareDataButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            shareDataButton.heightAnchor.constraint(equalToConstant: 26),
            shareDataButton.widthAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    func setupLinkButton() {
        view.addSubview(openlinkButton)
        
        NSLayoutConstraint.activate([
            openlinkButton.topAnchor.constraint(equalTo: newsDescriptionLabel.bottomAnchor, constant: 30),
            openlinkButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70),
            openlinkButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70),
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
