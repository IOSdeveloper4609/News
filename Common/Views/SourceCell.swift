//
//  NewsCell.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import UIKit

protocol AddToFavoritesDelegate {
    func addToFavoritesButton(model: SourceObject)
}

final class SourceCell: BaseCell {
    
    var delegate: AddToFavoritesDelegate?
    private let databaseManager = DatabaseManager.shared
    
    private var sourcesObject: SourceObject?
    
    lazy var categorySourceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 14)
        l.numberOfLines = 0
        l.textColor = .red
       
        return l
    }()
    
    private lazy var favouriteButton: UIButton = {
        let b = UIButton()
        b.tintColor = .blue
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "heart"), for: .normal)
        b.contentMode = .scaleToFill
        b.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
       
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithModel(model: SourceObject) {
        self.sourcesObject = model
        
        sourceTitleLabel.text = model.name
        sourceDescriptionLabel.text = model.detailed
        categorySourceLabel.text = model.category
        
        if model.isFavourite {
            favouriteButton.setImage(#imageLiteral(resourceName: "redHeart"), for: .normal)
        } else {
            favouriteButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }
    }
    
}

// MARK: - Private
private extension SourceCell {
    
    func setupUI() {
        setupSourceTitleLabel()
        setupSourceDescriptionLabel()
        setupFavouriteButton()
        setupCategorySourceLabel()
    }
    
    func setupSourceTitleLabel() {
        contentView.addSubview(sourceTitleLabel)
        
        NSLayoutConstraint.activate([
            sourceTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            sourceTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            sourceTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50),
        ])
    }
    
    func setupCategorySourceLabel() {
        contentView.addSubview(categorySourceLabel)
        
        NSLayoutConstraint.activate([
            categorySourceLabel.topAnchor.constraint(equalTo: sourceDescriptionLabel.bottomAnchor, constant: 10),
            categorySourceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            categorySourceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -100),
            categorySourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func setupSourceDescriptionLabel() {
        contentView.addSubview(sourceDescriptionLabel)
        
        NSLayoutConstraint.activate([
            sourceDescriptionLabel.topAnchor.constraint(equalTo: sourceTitleLabel.bottomAnchor, constant: 17),
            sourceDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            sourceDescriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])
    }
    
    func setupFavouriteButton() {
        contentView.addSubview(favouriteButton)
        
        NSLayoutConstraint.activate([
            favouriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            favouriteButton.heightAnchor.constraint(equalToConstant: 23),
            favouriteButton.widthAnchor.constraint(equalToConstant: 23)
        ])
    }
    
}

// MARK: - Actions
private extension SourceCell {
    
    @objc func addToFavorites() {
        if let sourcesObject = sourcesObject {
            delegate?.addToFavoritesButton(model: sourcesObject)
        }
    }
    
}
