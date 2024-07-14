//
//  TrackersViewController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    
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
    
    //MARK: - Public Property
    var trackersPresenter: TrackersPresenterProtocol?
    
    //MARK: - Private Property
    private let cellIdentifier = "cellIdentifier"
    private let headerIdentifier = "header"
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .white
        
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
            searchTextField,
            collectionView,
            emptyTrackersImage,
            emptyTrackersLabel,
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        addConstraintSearchTextField()
        addConstraintEmptyTrackersImage()
        addConstraintEmptyTrackersLabel()
        addConstraintCollectionView()
        
        hideEmptyImage(setHidden: true)
    }
    
    // MARK: - Private Methods
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
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7)
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
        print(#fileID, #function, #line, "sender.date: \(sender.date)")
        trackersPresenter?.setCurrentDate(date: sender.date)
        hideEmptyImage(setHidden: true)
        collectionView.reloadData()
    }
    
    @objc private func clickAddNewTracker() {
        print(#fileID, #function, #line)
        let selectTypeEventViewController = SelectTypeEventViewController()
        selectTypeEventViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: selectTypeEventViewController)
        present(navigationController, animated: true)
    }
    
    private func hideEmptyImage(setHidden: Bool) {
        print(#fileID, #function, #line, "setHidden: \(setHidden)")
        emptyTrackersImage.isHidden = setHidden
        emptyTrackersLabel.isHidden = setHidden
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = trackersPresenter?.getCountTrackersInCategoriesInCurrentDate() ?? 0
        print(#fileID, #function, #line, "number: \(number)")
        if number == 0 {
            hideEmptyImage(setHidden: false)
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let tracker = trackersPresenter?.getTrackersInDate(index: indexPath.row) else {
            print(#fileID, #function, #line)
            return cell
        }
        cell.delegate = trackersPresenter
        cell.setCellItems(tracker: tracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print(#fileID, #function, #line)
        let countCategories = trackersPresenter?.getCountCategories() ?? 0
        let number = trackersPresenter?.getCountTrackersInCategoriesInCurrentDate() ?? 0
        if countCategories > 0 && number > 0 {
            print(#fileID, #function, #line, "count: \(countCategories)")
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: headerIdentifier,
                for: indexPath
            ) as! CategoryView
            let nameCategory = trackersPresenter?.getNameCategory(index: countCategories) ?? ""
            view.titleLabel.text = nameCategory
            return view
        }
        return UICollectionReusableView()
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

// MARK: - TrackersViewControllerDelegate
extension TrackersViewController: TrackersViewControllerDelegate {
    func setTracker(tracker: Tracker, category: String) {
        trackersPresenter?.setTracker(tracker: tracker, category: category)
        collectionView.reloadData()
        hideEmptyImage(setHidden: true)
    }
}
