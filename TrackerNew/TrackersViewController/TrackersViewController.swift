//
//  TrackersViewController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    //MARK: - Visual Components
    private lazy var addNewTracker: UIButton = {
        guard let image = UIImage(named: "AddTracker") else {
            print(#fileID, #function, #line)
            return UIButton()
        }
        let view = UIButton.systemButton(
            with: image,
            target: self,
            action: #selector(clickAddNewTracker)
        )
        view.tintColor = .ypBlack
        return view
    }()
    
    private let header: UILabel = {
        let view = UILabel()
        view.text = "Трекеры"
        view.textColor = .ypBlack
        view.font = UIFont.boldSystemFont(ofSize: 34)
        return view
    }()
    
    private let emptyTrackersImage: UIImageView = {
        guard let image = UIImage(named: "EmptyTrackersImage") else {
            print(#fileID, #function, #line)
            return UIImageView()
        }
        let view = UIImageView(image: image)
        return view
    }()
    
    private let emptyTrackersLabel: UILabel = {
        let view = UILabel()
        view.text = "Что будем отслеживать?"
        view.textColor = .ypBlack
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_Ru")
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        picker.calendar.firstWeekday = 2
        picker.addTarget(
            self,
            action: #selector(datePickerValueChanged(_:)),
            for: .valueChanged
        )
        return picker
    }()
    
    private var searchTextField : UISearchTextField = {
        let viewSearchTextField = UISearchTextField()
        viewSearchTextField.text = "Поиск"
        return viewSearchTextField
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    //MARK: - Private Property
    
    //    private var categories: [TrackerCategory]?
    //    private var completedTrackers: [TrackerRecord]?
    private let cellIdentifier = "cellIdentifier"
    private let headerIdentifier = "header"
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewTracker)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )
        collectionView.register(
            CategoryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.allowsMultipleSelection = false
        
        [
            emptyTrackersImage,
            emptyTrackersLabel,
            header,
            searchTextField,
            collectionView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        addConstraintHeader()
        addConstraintSearchTextField()
        addConstraintEmptyTrackersImage()
        addConstraintEmptyTrackersLabel()
        addConstraintCollectionView()
    }
    
    // MARK: - Private Methods
    private func addConstraintHeader() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addConstraintEmptyTrackersImage() {
        NSLayoutConstraint.activate([
            emptyTrackersImage.widthAnchor.constraint(equalToConstant: 80),
            emptyTrackersImage.heightAnchor.constraint(equalToConstant: 80),
            emptyTrackersImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyTrackersImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addConstraintEmptyTrackersLabel() {
        NSLayoutConstraint.activate([
            emptyTrackersLabel.topAnchor.constraint(equalTo: emptyTrackersImage.bottomAnchor, constant: 8),
            emptyTrackersLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addConstraintSearchTextField() {
        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 7)
        ])
    }
    
    private func addConstraintCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
    
    //TODO: добавить реализацию
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        print(#fileID, #function, #line, sender)
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    @objc private func clickAddNewTracker() {
        let selectTypeEventViewController = SelectTypeEventViewController()
        let navigationController = UINavigationController(rootViewController: selectTypeEventViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerIdentifier,
            for: indexPath
        ) as! CategoryView
        return view
    }
    
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 9) / 2, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}
