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
        return view
    }()
    
    private let nameTracker: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    private let emojiTracker: UILabel = {
        let view = UILabel()
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
        let view = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(clickPlusTrackerCellButton)
        )
        view.layer.cornerRadius = 17
        view.layer.masksToBounds = true
        return view
    }()
    
    private let daysTracker: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .ypBlack
        return view
    }()
    
    // MARK: - Public Properties
    var delegate: TrackersPresenterProtocol?
    
    // MARK: - Private Properties
    private var plusTrackerCellButtonColor = UIColor.red
    private var trackerId: UInt = 0
    
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
    
    // MARK: - Public Methods
    func setCellItems(tracker: Tracker) {
        backgroundColorView.backgroundColor = tracker.color
        nameTracker.text = tracker.name
        emojiTracker.text = tracker.emoji
        plusTrackerCellButtonColor = tracker.color
        trackerId = tracker.id
        daysTracker.text = delegate?.countTrackerRecordDate(id: trackerId) ?? "0 дней"
        setColorPlusTrackerCellButton()
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
        
        guard let delegate else {
            print(#fileID, #function, #line)
            assertionFailure()
            return
        }
        
        if delegate.getCurrentDate() > Date() {
            print(#fileID, #function, #line)
            return
        }
        
        if delegate.containTrackerRecordDate(id: trackerId) {
            print(#fileID, #function, #line)
            delegate.deleteTrackerRecordDate(id: trackerId)
            setColorPlusTrackerCellButton()
            daysTracker.text = delegate.countTrackerRecordDate(id: trackerId)
        } else {
            print(#fileID, #function, #line)
            delegate.setTrackerRecordDate(id: trackerId)
            setColorPlusTrackerCellButton()
            daysTracker.text = delegate.countTrackerRecordDate(id: trackerId)
        }
    }
    
    private func setColorPlusTrackerCellButton() {
        
        guard let delegate else {
            print(#fileID, #function, #line)
            assertionFailure()
            return
        }
        
        guard let imageDone = UIImage(named: "DoneTrackerCellButton"),
              let imagePlus = UIImage(named: "PlusTrackerCellButton")
        else {
            print(#fileID, #function, #line)
            return
        }
        
        if delegate.containTrackerRecordDate(id: trackerId) {
            print(#fileID, #function, #line)
            plusTrackerCellButton.setImage(imageDone, for: .normal)
            plusTrackerCellButton.backgroundColor = plusTrackerCellButtonColor
            plusTrackerCellButton.tintColor = .white
            plusTrackerCellButton.backgroundColor = plusTrackerCellButton.backgroundColor?.withAlphaComponent(0.3)
        } else {
            print(#fileID, #function, #line)
            plusTrackerCellButton.setImage(imagePlus, for: .normal)
            plusTrackerCellButton.backgroundColor = .white
            plusTrackerCellButton.tintColor = plusTrackerCellButtonColor
        }
    }
}
