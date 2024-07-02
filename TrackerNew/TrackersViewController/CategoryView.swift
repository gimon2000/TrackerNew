//
//  CategoryView.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import UIKit

final class CategoryView: UICollectionReusableView {
    
    //MARK: - Visual Components
    var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .ypBlack
        view.font = UIFont.boldSystemFont(ofSize: 19)
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
