//
//  ScheduleViewController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    //MARK: - Visual Components
    private lazy var doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Готово", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(clickDoneButton), for: .touchUpInside)
        return view
    }()
    
    private var tableView: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 16
        view.separatorColor = .ypGray2
        view.allowsSelection = false
        return view
    }()
    
    //MARK: - Private Property
    private let cellReuseIdentifier = "dayTableCellIdentifier"
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .white
        
        navigationItem.title = "Расписание"
        
        [
            doneButton,
            tableView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            ScheduleTableCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        
        addConstraintTableView()
        addConstraintDoneButton()
    }
    
    // MARK: - Private Methods
    
    private func addConstraintTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 525)
        ])
    }
    
    private func addConstraintDoneButton() {
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func clickDoneButton() {
        print(#fileID, #function, #line)
        //TODO: добавить реализацию
    }
}

//MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
}

//MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#fileID, #function, #line)
        return 7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#fileID, #function, #line)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? ScheduleTableCell else {
            print(#fileID, #function, #line)
            return UITableViewCell()
        }
        cell.setTextInTextLabelCell(text: Weekdays.allCases[indexPath.row].fullName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == 6
        
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
