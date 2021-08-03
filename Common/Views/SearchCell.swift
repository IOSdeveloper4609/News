//
//  SearchCell.swift
//  News
//
//  Created by Азат Киракосян on 02.08.2021.
//

import UIKit
import SDWebImage
import Hero

final class SearchCell: BaseCell {
    
    private var model: Article?
    
    private lazy var newsTitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 18)
        l.numberOfLines = 0
        l.textColor = .black
        
        return l
    }()
        
    private lazy var newsDescriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 16)
        l.numberOfLines = 0
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
    
    func setupWithModel(model: Article) {
        self.model = model
        
        newsTitleLabel.text = model.title
        newsDescriptionLabel.text = model.description
        avatarNewsImageView.sd_setImage(with: model.urlToImage, placeholderImage: #imageLiteral(resourceName: "image"))
    }
    
    func setupAnimationAvatar(param: String) {
        avatarNewsImageView.heroID = param
    }
    
}

private extension SearchCell {
    
    func setupUI() {
        setupAvatarImageView()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    func setupAvatarImageView() {
        contentView.addSubview(avatarNewsImageView)
        
        contentView.addConstraints([
            avatarNewsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarNewsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            avatarNewsImageView.heightAnchor.constraint(equalToConstant: 110),
            avatarNewsImageView.widthAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(newsTitleLabel)
        
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            newsTitleLabel.leftAnchor.constraint(equalTo: avatarNewsImageView.rightAnchor, constant: 15),
            newsTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])
    }
    
    func setupDescriptionLabel() {
        contentView.addSubview(newsDescriptionLabel)
        
        NSLayoutConstraint.activate([
            newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 10),
            newsDescriptionLabel.leftAnchor.constraint(equalTo: avatarNewsImageView.rightAnchor, constant: 15),
            newsDescriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            newsDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
}
