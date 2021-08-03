//
//  FavouritesCell.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import UIKit

protocol OpenLinkDelegate {
    func openLinkButtonTapped(model: SourceObject)
}

final class FavouriteCell: BaseCell {
    
    var model: SourceObject?
    var delegate: OpenLinkDelegate?
    
    private lazy var openlinkButton: UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 10
        b.clipsToBounds = true
        b.titleLabel?.font = .boldSystemFont(ofSize: 11)
        b.layer.masksToBounds = true
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemBlue
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("открыть канал", for: .normal)
        b.contentMode = .scaleToFill
        b.addTarget(self, action: #selector(openLink), for: .touchUpInside)
       
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
        self.model = model
        
        sourceTitleLabel.text = model.name
        sourceDescriptionLabel.text = model.detailed
    }
    
}

// MARK: - Private
private extension FavouriteCell {
    
    func setupUI() {
        setupSourceTitleLabel()
        setupSourceDescriptionLabel()
        setupLinkButton()
    }
    
    func setupSourceTitleLabel() {
        contentView.addSubview(sourceTitleLabel)
        
        NSLayoutConstraint.activate([
            sourceTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            sourceTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            sourceTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50),
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
    
    func setupLinkButton() {
        contentView.addSubview(openlinkButton)
        
        NSLayoutConstraint.activate([
            openlinkButton.topAnchor.constraint(equalTo: sourceDescriptionLabel.bottomAnchor, constant: 25),
            openlinkButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            openlinkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            openlinkButton.heightAnchor.constraint(equalToConstant: 21),
            openlinkButton.widthAnchor.constraint(equalToConstant: 110)
        ])
    }
    
}

// MARK: - Actions
private extension FavouriteCell {
    
    @objc func openLink() {
        if let sourcesObject = model {
            delegate?.openLinkButtonTapped(model: sourcesObject)
        }
    }
    
}

