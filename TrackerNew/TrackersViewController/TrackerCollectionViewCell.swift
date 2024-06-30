//
//  TrackerCollectionViewCell.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Visual Components
    private var backgroundColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .green
        return view
    }()
    
    private let nameTracker: UILabel = {
        let view = UILabel()
        view.text = "Трекер"
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    private let emojiTracker: UILabel = {
        let view = UILabel()
        view.text = "❤️"
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private var backgroundColorEmojiView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .ypWhite30
        return view
    }()
    
    private lazy var plusTrackerCellButton: UIButton = {
        guard let image = UIImage(named: "PlusTrackerCellButton") else {
            print(#fileID, #function, #line)
            return UIButton()
        }
        let view = UIButton.systemButton(
            with: image,
            target: self,
            action: #selector(clickPlusTrackerCellButton)
        )
        view.tintColor = .green
        return view
    }()
    
    private let daysTracker: UILabel = {
        let view = UILabel()
        view.text = "5 дней"
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .ypBlack
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(#fileID, #function, #line)
        
        [
            backgroundColorView,
            nameTracker,
            backgroundColorEmojiView,
            emojiTracker,
            plusTrackerCellButton,
            daysTracker
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(backgroundColorView)
        contentView.addSubview(plusTrackerCellButton)
        contentView.addSubview(daysTracker)
        backgroundColorView.addSubview(nameTracker)
        backgroundColorView.addSubview(backgroundColorEmojiView)
        backgroundColorEmojiView.addSubview(emojiTracker)
        
        addConstraintBackgroundColorView()
        addConstraintNameTracker()
        addConstraintBackgroundColorEmojiView()
        addConstraintEmojiTracker()
        addConstraintPlusTrackerCellButton()
        addConstraintDaysTracker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func addConstraintBackgroundColorView() {
        NSLayoutConstraint.activate([
            backgroundColorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundColorView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.7)
        ])
    }
    
    private func addConstraintNameTracker() {
        NSLayoutConstraint.activate([
            nameTracker.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor,constant: -12),
            nameTracker.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 12),
            nameTracker.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -12)
        ])
    }
    
    private func addConstraintBackgroundColorEmojiView() {
        NSLayoutConstraint.activate([
            backgroundColorEmojiView.topAnchor.constraint(equalTo: backgroundColorView.topAnchor,constant: 12),
            backgroundColorEmojiView.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 12),
            backgroundColorEmojiView.widthAnchor.constraint(equalToConstant: 24),
            backgroundColorEmojiView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func addConstraintEmojiTracker() {
        NSLayoutConstraint.activate([
            emojiTracker.centerXAnchor.constraint(equalTo: backgroundColorEmojiView.centerXAnchor),
            emojiTracker.centerYAnchor.constraint(equalTo: backgroundColorEmojiView.centerYAnchor)
        ])
    }
    
    private func addConstraintPlusTrackerCellButton() {
        NSLayoutConstraint.activate([
            plusTrackerCellButton.topAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: 8),
            plusTrackerCellButton.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -12),
            plusTrackerCellButton.heightAnchor.constraint(equalToConstant: 34),
            plusTrackerCellButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func addConstraintDaysTracker() {
        NSLayoutConstraint.activate([
            daysTracker.centerYAnchor.constraint(equalTo: plusTrackerCellButton.centerYAnchor),
            daysTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    @objc private func clickPlusTrackerCellButton() {
        print(#fileID, #function, #line)
        //TODO: -
    }
}
