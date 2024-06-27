//
//  CreateTrackerViewController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    //MARK: - Visual Components
    private var textField: UITextField = {
        let view = UITextField()
        view.placeholder = "Введите название трекера"
        view.backgroundColor = .ypGray
        view.layer.cornerRadius = 16
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        view.leftView = leftView
        view.leftViewMode = .always
        view.tintColor = .ypBlue
        return view
    }()
    
    private lazy var createButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Создать", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypGray2
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(clickCreateButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Отменить", for: .normal)
        view.setTitleColor(.ypRed, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.ypRed.cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cancelButton, createButton])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    private var tableView: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 16
        view.separatorColor = .ypGray2
        return view
    }()
    
    //MARK: - Private Property
    private var navigationTitle: String
    private let cellReuseIdentifier = "tableCellIdentifier"
    private var numberOfRowsInSection: Int
    
    // MARK: - Initializers
    init(
        navigationTitle: String,
        numberOfRowsInSection: Int
    ) {
        print(#fileID, #function, #line)
        self.navigationTitle = navigationTitle
        self.numberOfRowsInSection = numberOfRowsInSection
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
        
        view.backgroundColor = .white
        
        navigationItem.title = navigationTitle
        
        [
            textField,
            stackView,
            createButton,
            cancelButton,
            tableView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            textField,
            stackView,
            tableView
        ].forEach{
            view.addSubview($0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            TableCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        
        
        addConstraintTextField()
        addConstraintStackView()
        addConstraintCreateButton()
        addConstraintCancelButton()
        addConstraintTableView()
    }
    
    // MARK: - Private Methods
    private func addConstraintTextField() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    private func addConstraintStackView() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])
    }
    
    private func addConstraintTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * numberOfRowsInSection))
        ])
    }
    
    private func addConstraintCreateButton() {
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addConstraintCancelButton() {
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func clickCreateButton() {
        print(#fileID, #function, #line)
        //TODO: добавить реализацию
    }
    
    @objc private func clickCancelButton() {
        print(#fileID, #function, #line)
        self.dismiss(animated: true)
    }
}

//MARK: - UITableViewDelegate
extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

//MARK: - UITableViewDataSource
extension CreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#fileID, #function, #line)
        return numberOfRowsInSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#fileID, #function, #line)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? TableCell else {
            print(#fileID, #function, #line)
            return UITableViewCell()
        }
        let title = ["Категория", "Расписание"]
        cell.setTextInTextLabelCell(text: title[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == numberOfRowsInSection - 1
        
        if isLastCell {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: cell.bounds.width,
                bottom: 0,
                right: 0
            )
        } else {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 16,
                bottom: 0,
                right: 16
            )
        }
    }
}
