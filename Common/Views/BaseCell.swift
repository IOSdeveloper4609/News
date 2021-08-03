//
//  BaseCell.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import UIKit

class BaseCell: UITableViewCell {

    lazy var avatarNewsImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = (frame.height * 0.72) / 2
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    lazy var sourceTitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 18)
        l.numberOfLines = 0
        l.textColor = .black
       
        return l
    }()
    
     lazy var sourceDescriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 16)
        l.numberOfLines = 0
        l.textColor = .systemBlue
        
        return l
    }()
    
    static var identifier: String {
        String(describing: type(of: self))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
}
