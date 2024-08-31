//
//  PreviewViewController.swift
//  TrackerNew
//
//  Created by gimon on 18.08.2024.
//

import UIKit

final class PreviewViewController: UIViewController {
    
    //MARK: - Visual Components
    private lazy var nameTracker: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.text = name
        return view
    }()
    
    private lazy var emojiTracker: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.text = emoji
        return view
    }()
    
    private var backgroundColorEmojiView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .ypWhite30
        return view
    }()
    
    //MARK: - Private Property
    let backgroundColor: UIColor
    let name: String
    let emoji: String
    
    init(
        backgroundColor: UIColor,
        name: String,
        emoji: String
    ) {
        self.backgroundColor = backgroundColor
        self.name = name
        self.emoji = emoji
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = CGSize(width: 167, height: 90)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 16
        [
            nameTracker,
            emojiTracker,
            backgroundColorEmojiView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        addConstraintNameTracker()
        addConstraintBackgroundColorEmojiView()
        addConstraintEmojiTracker()
    }
    
    // MARK: - Private Methods
    private func addConstraintNameTracker() {
        NSLayoutConstraint.activate([
            nameTracker.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -12),
            nameTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            nameTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    private func addConstraintBackgroundColorEmojiView() {
        NSLayoutConstraint.activate([
            backgroundColorEmojiView.topAnchor.constraint(equalTo: view.topAnchor,constant: 12),
            backgroundColorEmojiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
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
}
