//
//  EmojiCollectionViewCell.swift
//  TrackerNew
//
//  Created by gimon on 06.07.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    let emojiLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return view
    }()
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                print(#fileID, #function, #line)
                self.contentView.backgroundColor = .ypGraySelectEmoji
                self.contentView.layer.cornerRadius = 16
                self.contentView.layer.masksToBounds = true
            } else {
                print(#fileID, #function, #line)
                self.contentView.backgroundColor = .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line)
        
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
