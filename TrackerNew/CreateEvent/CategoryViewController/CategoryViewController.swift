//
//  CategoryViewController.swift
//  TrackerNew
//
//  Created by gimon on 05.08.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func createNewCategory(nameCategory: String)
}

final class CategoryViewController: UIViewController {
    
    //MARK: - Visual Components
    private lazy var createCategoryButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Добавить категорию", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(clickCreateCategoryButton), for: .touchUpInside)
        return view
    }()
    
    private var tableViewCategories: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 16
        view.separatorColor = .ypGray
        return view
    }()
    
    private let emptyCategoriesImage: UIImageView = {
        guard let image = UIImage(named: "EmptyTrackersImage") else {
            print(#fileID, #function, #line)
            return UIImageView()
        }
        let view = UIImageView(image: image)
        view.isHidden = true
        return view
    }()
    
    private let emptyCategoriesLabel: UILabel = {
        let view = UILabel()
        view.text = "Привычки и события можно\nобъединить по смыслу"
        view.numberOfLines = 2
        view.textAlignment = .center
        view.textColor = .ypBlack
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.isHidden = true
        return view
    }()
    
    //MARK: - Public Property
    weak var delegate: CreateTrackerViewControllerDelegate?
    var categoryViewModel: CategoryViewModelProtocol?
    
    //MARK: - Private Property
    private let cellReuseIdentifier = "categoryTableCellIdentifier"
    private lazy var tableViewCategoriesHeightConstraint: NSLayoutConstraint = {
        let tableHeight = CGFloat(75 * (categoryViewModel?.trackerCategoryCount() ?? 0))
        tableViewCategoriesHeightConstraint = tableViewCategories.heightAnchor.constraint(equalToConstant: tableHeight)
        tableViewCategoriesHeightConstraint.isActive = true
        return tableViewCategoriesHeightConstraint
    }()
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .white
        
        navigationItem.title = "Категория"
        
        tableViewCategories.delegate = self
        tableViewCategories.dataSource = self
        
        [
            createCategoryButton,
            tableViewCategories,
            emptyCategoriesImage,
            emptyCategoriesLabel
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableViewCategories.register(
            CategoryTableCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        
        addConstraintTableView()
        addConstraintCreateCategoryButton()
        addConstraintEmptyCategoriesImage()
        addConstraintEmptyCategoriesLabel()
        hiddenEmptyImageLabel()
    }
    
    func initViewModel() {
        categoryViewModel?.hiddenEmptyImageLabel = { [weak self] in
            self?.hiddenEmptyImageLabel()
            self?.tableViewCategoriesHeightConstraint.constant = CGFloat(75 * (self?.categoryViewModel?.trackerCategoryCount() ?? 0))
            self?.tableViewCategories.reloadData()
        }
    }
    
    // MARK: - Private Methods
    private func hiddenEmptyImageLabel() {
        if let trackerCategoryIsEmpty = categoryViewModel?.trackerCategoryIsEmpty() {
                print(#fileID, #function, #line, "trackerCategoryIsEmpty: \(trackerCategoryIsEmpty)")
                emptyCategoriesImage.isHidden = !trackerCategoryIsEmpty
                emptyCategoriesLabel.isHidden = !trackerCategoryIsEmpty
        }
    }
    
    private func addConstraintEmptyCategoriesImage() {
        NSLayoutConstraint.activate([
            emptyCategoriesImage.widthAnchor.constraint(equalToConstant: 80),
            emptyCategoriesImage.heightAnchor.constraint(equalToConstant: 80),
            emptyCategoriesImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyCategoriesImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addConstraintEmptyCategoriesLabel() {
        NSLayoutConstraint.activate([
            emptyCategoriesLabel.topAnchor.constraint(equalTo: emptyCategoriesImage.bottomAnchor, constant: 8),
            emptyCategoriesLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addConstraintTableView() {
        let _ = tableViewCategoriesHeightConstraint
        NSLayoutConstraint.activate(
            [
                tableViewCategories.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                tableViewCategories.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                tableViewCategories.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            ]
        )
    }
    
    private func addConstraintCreateCategoryButton() {
        NSLayoutConstraint.activate([
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func clickCreateCategoryButton() {
        print(#fileID, #function, #line)
        let createCategoryViewController = CreateCategoryViewController()
        createCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createCategoryViewController)
        present(navigationController, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "indexPath.row: \(indexPath.row)")
        let name = tableView.visibleCells.map{
            if let cell = $0 as? CategoryTableCell {
                return cell.getNameCategory()
            }
            return nil
        }[indexPath.row] ?? "Error"
        print(#fileID, #function, #line, "name: \(name)")
        categoryViewModel?.addLastCategory(categoryName: name)
        delegate?.setCategoryChecked(nameCategory: name)
        self.dismiss(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = categoryViewModel?.trackerCategoryCount() {
            print(#fileID, #function, #line, "categories.count: \(count)")
            return count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#fileID, #function, #line)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? CategoryTableCell else {
            print(#fileID, #function, #line)
            return UITableViewCell()
        }
        if let (name, isLast ) = categoryViewModel?.getNameCategory(id: indexPath.row) {
            cell.setDataInCell(text: name, doesCheckmarkHidden: !isLast)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == (categoryViewModel?.trackerCategoryCount() ?? 0) - 1
        
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

extension CategoryViewController: CategoryViewControllerDelegate {
    func createNewCategory(nameCategory: String) {
        print(#fileID, #function, #line, "name:\(nameCategory)")
        categoryViewModel?.addCategory(name: nameCategory)
    }
}
