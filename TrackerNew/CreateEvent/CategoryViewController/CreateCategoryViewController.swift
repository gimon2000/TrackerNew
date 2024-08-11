//
//  CreateCategoryViewController.swift
//  TrackerNew
//
//  Created by gimon on 05.08.2024.
//

import UIKit

final class CreateCategoryViewController: UIViewController {
    
    //MARK: - Visual Components
    private lazy var doneButton: UIButton = {
        let view = UIButton(type: .custom)
        let textButton = NSLocalizedString(
            "done.button.category",
            comment: "Text displayed in button"
        )
        view.setTitle(textButton, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypGray
        view.layer.cornerRadius = 16
        view.isEnabled = false
        view.addTarget(self, action: #selector(clickDoneButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var nameCategoryTextField : UITextField = {
        let view = UITextField()
        view.placeholder = NSLocalizedString(
            "name.category.text.field.placeholder",
            comment: "Text displayed in placeholder"
        )
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: view.frame.height))
        view.leftViewMode = .always
        view.backgroundColor = .ypGray30
        view.layer.cornerRadius = 16
        view.delegate = self
        return view
    }()
    
    //MARK: - Public Property
    weak var delegate: CategoryViewControllerDelegate?
    
    //MARK: - Private Property
    private lazy var tapGesture = UITapGestureRecognizer(
        target: view,
        action: #selector(view.endEditing)
    )
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .white
        
        navigationItem.title = NSLocalizedString(
            "create.category.view.controller.title",
            comment: "Text displayed in title"
        )
                
        [
            doneButton,
            nameCategoryTextField
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        addConstraintDoneButton()
        addConstraintNameCategoryTextField()
    }
    
    private func addConstraintDoneButton() {
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func addConstraintNameCategoryTextField() {
        NSLayoutConstraint.activate([
            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    @objc private func clickDoneButton() {
        print(#fileID, #function, #line)
        if let name = nameCategoryTextField.text {
            print(#fileID, #function, #line, "name:\(name)")
            self.delegate?.createNewCategory(nameCategory: name)
        }
        self.dismiss(animated: true)
    }
}

extension CreateCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(#fileID, #function, #line)
        guard let didTextIntroduced = textField.text?.isEmpty else {
            return
        }
        
        if !didTextIntroduced && !doneButton.isEnabled {
            changeDoneButton(isEnabled: true, backgroundColor: .ypBlack)
        }
        if didTextIntroduced && doneButton.isEnabled {
            changeDoneButton(isEnabled: false, backgroundColor: .ypGray)
        }
    }
    
    private func changeDoneButton(
        isEnabled: Bool,
        backgroundColor: UIColor
    ) {
        print(#fileID, #function, #line, "isEnabled: \(isEnabled)", "backgroundColor: \(backgroundColor)")
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = backgroundColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#fileID, #function, #line)
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#fileID, #function, #line)
        view.removeGestureRecognizer(tapGesture)
        return true
    }
}
