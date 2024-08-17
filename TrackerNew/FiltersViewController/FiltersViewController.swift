//
//  FiltersViewController.swift
//  TrackerNew
//
//  Created by gimon on 17.08.2024.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    //MARK: - Visual Components
    private var tableViewFilters: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 16
        view.separatorColor = .ypGray
        view.tableHeaderView = UIView()
        return view
    }()
    
    //MARK: - Public Property
    weak var delegate: TrackersViewControllerDelegate?
    
    //MARK: - Private Property
    private let cellReuseIdentifier = "filtersTableCellIdentifier"
    private let nameColumns = [
        "Все трекеры",
        "Трекеры на сегодня",
        "Завершенные",
        "Не завершенные"
    ]
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .white
        
        navigationItem.title = NSLocalizedString(
            "trackers.view.controller.filters",
            comment: "Text displayed in title"
        )
        
        tableViewFilters.delegate = self
        tableViewFilters.dataSource = self
        
        tableViewFilters.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableViewFilters)
        
        tableViewFilters.register(
            CategoryTableCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        
        addConstraintTableView()
    }
    
    private func addConstraintTableView() {
        NSLayoutConstraint.activate(
            [
                tableViewFilters.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                tableViewFilters.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                tableViewFilters.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                tableViewFilters.heightAnchor.constraint(equalToConstant: 4 * 75)
            ]
        )
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print(#fileID, #function, #line, "index: \(index)")
        switch index {
        case 0:
            delegate?.cleanAllFilters()
        case 1:
            delegate?.todayFilter()
        case 2:
            delegate?.completedFilter()
        case 3:
            delegate?.uncompletedFilter()
        default:
            print(#fileID, #function, #line)
        }
        UserDefaults.standard.setValue(index, forKey: "selectedFilter")
        self.dismiss(animated: true)
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameColumns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? CategoryTableCell else {
            return UITableViewCell()
        }
        let text = nameColumns[indexPath.row]
        let bool = UserDefaults.standard.integer(forKey: "selectedFilter") == indexPath.row
        cell.setDataInCell(text: text, doesCheckmarkHidden: !bool)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == nameColumns.count - 1
        
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
