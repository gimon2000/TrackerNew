//
//  ColorCollectionViewCell.swift
//  TrackerNew
//
//  Created by gimon on 07.07.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                print(#fileID, #function, #line)
                self.contentView.backgroundColor = colorView.backgroundColor?.withAlphaComponent(0.3)
            } else {
                print(#fileID, #function, #line)
                self.contentView.backgroundColor = .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line)
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 46),
            colorView.heightAnchor.constraint(equalToConstant: 46)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
