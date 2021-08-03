//
//  NewCell.swift
//  News
//
//  Created by Азат Киракосян on 31.07.2021.
//

import UIKit
import SDWebImage

final class NewCell: BaseCell {
    
    private var model: NewsObject?
    
    private lazy var newsTitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 18)
        l.numberOfLines = 2
        l.textColor = .white
        
        return l
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
    
    private lazy var newsDescriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 16)
        l.numberOfLines = 2
        l.textColor = .systemBlue
        
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithModel(model: NewsObject) {
        self.model = model
        
        newsTitleLabel.text = model.title
        newsDescriptionLabel.text = model.detailed
        avatarNewsImageView.sd_setImage(with: model.urlToImage, placeholderImage: #imageLiteral(resourceName: "image"))
    }
    
}

// MARK: - Private
private extension NewCell {
    
    func setupUI() {
        setupTitleLabel()
        setupDescriptionLabel()
        setupAvatarImageView()
        setupConteinerView()
    }
    
    func setupAvatarImageView() {
        contentView.addSubview(avatarNewsImageView)

        contentView.addConstraints([
            avatarNewsImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            avatarNewsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            avatarNewsImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            avatarNewsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
        ])
    }
    
    func setupTitleLabel() {
        conteinerView.addSubview(newsTitleLabel)
        
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 10),
            newsTitleLabel.leftAnchor.constraint(equalTo: conteinerView.leftAnchor, constant: 20),
            newsTitleLabel.rightAnchor.constraint(equalTo: conteinerView.rightAnchor, constant: -50),
        ])
    }
    
    func setupDescriptionLabel() {
        conteinerView.addSubview(newsDescriptionLabel)
        
        NSLayoutConstraint.activate([
            newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 17),
            newsDescriptionLabel.leftAnchor.constraint(equalTo: conteinerView.leftAnchor, constant: 20),
            newsDescriptionLabel.rightAnchor.constraint(equalTo: conteinerView.rightAnchor, constant: -20),
            newsDescriptionLabel.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: -10)
        ])
    }
    
    func setupConteinerView() {
        avatarNewsImageView.addSubview(conteinerView)
        
        NSLayoutConstraint.activate([
            conteinerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            conteinerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            conteinerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            conteinerView.heightAnchor.constraint(equalToConstant: 135),
        ])
    }
    
}
