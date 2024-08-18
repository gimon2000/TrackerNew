//
//  StatisticViewController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    //MARK: - Visual Components
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString(
            "statistic.view.controller.title",
            comment: "Text displayed on title"
        )
        view.textColor = .ypBlack
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return view
    }()
    
    private let emptyStatisticImage: UIImageView = {
        guard let image = UIImage(named: "EmptyStatisticImage") else {
            print(#fileID, #function, #line)
            return UIImageView()
        }
        let view = UIImageView(image: image)
        view.isHidden = true
        return view
    }()
    
    private let emptyStatisticLabel: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString(
            "empty.statistic.label",
            comment: "Text displayed on empty state"
        )
        view.textColor = .ypBlack
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.isHidden = true
        return view
    }()
    
    private var tableViewStatistic: UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        return view
    }()
    
    //MARK: - Private Property
    private let cellReuseIdentifier = "statisticTableCellIdentifier"
    private let trackerRecordStore = TrackerRecordStore()
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .systemBackground
        
        [
            titleLabel,
            emptyStatisticImage,
            emptyStatisticLabel,
            tableViewStatistic
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableViewStatistic.register(
            StatisticTableCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        tableViewStatistic.delegate = self
        tableViewStatistic.dataSource = self
        
        addConstraintEmptyCategoriesImage()
        addConstraintEmptyStatisticImage()
        addConstraintEmptStatisticLabel()
        addConstraintTableView()
        hiddenEmptyImageLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenEmptyImageLabel()
        tableViewStatistic.reloadData()
    }
    
    // MARK: - Private Methods
    private func addConstraintEmptyCategoriesImage() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
    }
    
    private func addConstraintEmptyStatisticImage() {
        NSLayoutConstraint.activate([
            emptyStatisticImage.widthAnchor.constraint(equalToConstant: 80),
            emptyStatisticImage.heightAnchor.constraint(equalToConstant: 80),
            emptyStatisticImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyStatisticImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addConstraintEmptStatisticLabel() {
        NSLayoutConstraint.activate([
            emptyStatisticLabel.topAnchor.constraint(equalTo: emptyStatisticImage.bottomAnchor, constant: 8),
            emptyStatisticLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addConstraintTableView() {
        NSLayoutConstraint.activate([
            tableViewStatistic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewStatistic.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableViewStatistic.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            tableViewStatistic.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func hiddenEmptyImageLabel() {
        let bool = trackerRecordStore.getCountRecords() == 0
        print(#fileID, #function, #line, "hiddenEmptyImageLabel: \(bool)")
        emptyStatisticImage.isHidden = bool ? false : true
        emptyStatisticLabel.isHidden = bool ? false : true
        tableViewStatistic.isHidden = !bool ? false : true
    }
}

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? StatisticTableCell else {
            print(#fileID, #function, #line)
            return UITableViewCell()
        }
        addBorder(cell: cell)
        let count = trackerRecordStore.getCountRecords()
        cell.setTitleInCell(text: "\(count)")
        return cell
    }
    
    private func addBorder(cell: StatisticTableCell) {
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [
            UIColor.ypLGStart.cgColor,
            UIColor.ypLGMiddle.cgColor,
            UIColor.ypLGEnd.cgColor
        ]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
        layerGradient.cornerRadius = 16
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: layerGradient.bounds, cornerRadius: layerGradient.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.cornerRadius = 16
        layerGradient.mask = shape
        cell.layer.addSublayer(layerGradient)
        cell.layer.cornerRadius = 16
    }
}
