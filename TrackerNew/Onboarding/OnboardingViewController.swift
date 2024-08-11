//
//  OnboardingViewController.swift
//  TrackerNew
//
//  Created by gimon on 02.08.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    //MARK: - Visual Components
    private lazy var onboardingImage: UIImageView = {
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var onboardingText: UILabel = {
        let view = UILabel()
        view.text = text
        view.numberOfLines = 2
        view.textColor = .ypBlack
        view.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var onboardingButton: UIButton = {
        let view = UIButton(type: .custom)
        let titleText = NSLocalizedString(
            "onboarding.button",
            comment: "Text displayed in onboarding button"
        )
        view.setTitle(titleText, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = 16
        view.addTarget(
            self,
            action: #selector(clickOnboardingButton),
            for: .touchUpInside
        )
        return view
    }()
    
    //MARK: - Private Properties
    private var image: UIImage
    private var text: String
    
    // MARK: - Initializers
    init(
        image: UIImage,
        text: String
    ) {
        print(#fileID, #function, #line)
        self.image = image
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        print(#fileID, #function, #line)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        [
            onboardingImage,
            onboardingText,
            onboardingButton
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        addConstraintOnboardingImage()
        addConstraintOnboardingText()
        addConstraintOnboardingButton()
    }
    
    //MARK: - Private Methods    
    private func addConstraintOnboardingImage() {
        NSLayoutConstraint.activate([
            onboardingImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            onboardingImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            onboardingImage.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addConstraintOnboardingText() {
        NSLayoutConstraint.activate([
            onboardingText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            onboardingText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            onboardingText.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -160)
        ])
    }
    
    private func addConstraintOnboardingButton() {
        NSLayoutConstraint.activate([
            onboardingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            onboardingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func clickOnboardingButton() {
        print(#fileID, #function, #line)
        guard let window = UIApplication.shared.windows.first else {
            print(#fileID, #function, #line, "window error")
            return
        }
        UserDefaults.standard.setValue(true, forKey: "didOnboardingShow")
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}
