//
//  TrackersViewController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    
    //MARK: - Visual Components
    private lazy var filtersButton: UIButton = {
        let view = UIButton(type: .custom)
        let habitTitleButton = NSLocalizedString(
            "trackers.view.controller.filters",
            comment: "Text displayed in button"
        )
        view.setTitle(habitTitleButton, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.backgroundColor = .ypBlue
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(clickFiltersButton), for: .touchUpInside)
        return view
    }()
    
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
        view.text = NSLocalizedString(
            "empty.trackers.label",
            comment: "Text displayed on empty state"
        )
        view.textColor = .ypBlack
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = .current
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        picker.calendar.firstWeekday = 2
        picker.addTarget(
            self,
            action: #selector(datePickerValueChanged(_:)),
            for: .valueChanged
        )
        picker.tintColor = .ypBlue
        return picker
    }()
    
    private lazy var searchTextField : UISearchTextField = {
        let viewSearchTextField = UISearchTextField()
        viewSearchTextField.placeholder = NSLocalizedString(
            "search.text.field.placeholder",
            comment: "Text displayed in placeholder"
        )
        viewSearchTextField.addTarget(self, action: #selector(searchTextFieldDidChanged), for: .editingChanged)
        return viewSearchTextField
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset.bottom = 100
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
        
        title = NSLocalizedString(
            "trackers.view.controller.title",
            comment: "Text displayed in title"
        )
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
            filtersButton
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        addConstraintSearchTextField()
        addConstraintEmptyTrackersImage()
        addConstraintEmptyTrackersLabel()
        addConstraintCollectionView()
        addConstraintFiltersButton()
        
        hideEmptyImage(setHidden: true)
    }
    
    // MARK: - Private Methods
    private func addConstraintFiltersButton() {
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
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
    
    @objc private func clickFiltersButton() {
        print(#fileID, #function, #line)
        let filtersViewController = FiltersViewController()
        filtersViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: filtersViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func searchTextFieldDidChanged(_ searchField: UISearchTextField) {
        if let searchText = searchField.text, !searchText.isEmpty {
            trackersPresenter?.setSearchText(text: searchText)
        } else {
            trackersPresenter?.setSearchText(text: "")
        }
        hideEmptyImage(setHidden: true)
        collectionView.reloadData()
    }
    
    private func hideEmptyImage(setHidden: Bool) {
        print(#fileID, #function, #line, "setHidden: \(setHidden)")
        emptyTrackersImage.isHidden = setHidden
        emptyTrackersLabel.isHidden = setHidden
        filtersButton.isHidden = !setHidden
    }
    
    func collectionViewReloadData() {
        print(#fileID, #function, #line)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let number =  trackersPresenter?.getCountCategoriesInCurrentDate() ?? 0
        print(#fileID, #function, #line, "number: \(number)")
        if number == 0 {
            hideEmptyImage(setHidden: false)
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = trackersPresenter?.getCountTrackersInCategoriesInCurrentDate(inSection: section) ?? 0
        print(#fileID, #function, #line, "number: \(number)")
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let tracker = trackersPresenter?.getTrackersInDate(
            indexSection: indexPath.section,
            indexTracker: indexPath.row
        ) else {
            print(#fileID, #function, #line)
            return cell
        }
        cell.delegate = trackersPresenter
        cell.setCellItems(tracker: tracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print(#fileID, #function, #line)
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerIdentifier,
            for: indexPath
        ) as! CategoryView
        let nameCategory = trackersPresenter?.getNameCategory(index: indexPath.section)
        view.titleLabel.text = nameCategory
        return view
    }
    
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let trackersPresenter else {
            assertionFailure("collectionView contextMenuConfigurationForItemAt trackersPresenter nil")
            return nil
        }
        
        let categoryName = trackersPresenter.getNameCategory(index: indexPath.section)
        let firstNameMenu = categoryName == "Закрепленные" ? "Открепить" : "Закрепить"
        let idTracker = getIdCell(index: indexPath)
        let tracker = trackersPresenter.getTrackersInDate(
            indexSection: indexPath.section,
            indexTracker: indexPath.row
        )
        let numberOfRowsInSection = tracker?.eventDate == nil ? 2 : 1
        return UIContextMenuConfiguration(actionProvider: {
            actions in
            return UIMenu(
                children: [
                    UIAction(title: firstNameMenu){[weak self] _ in
                        self?.trackersPresenter?.changeCategoryInTrackerCoreData(categoryName: categoryName, idTracker: idTracker)
                        self?.collectionView.reloadData()
                    },
                    UIAction(title: "Редактировать"){[weak self] _ in
                        print(#fileID, #function, #line)
                        let createTrackerViewController = CreateTrackerViewController(
                            navigationTitle: "Редактирование привычки",
                            numberOfRowsInSection: numberOfRowsInSection
                        )
                        let createTrackerPresenter = CreateTrackerPresenter()
                        createTrackerViewController.createTrackerPresenter = createTrackerPresenter
                        createTrackerPresenter.createTrackerView = createTrackerViewController
                        createTrackerPresenter.setParam(
                            oldWeekdaysChecked: tracker?.schedule ?? [],
                            oldCategory: categoryName,
                            oldSelectedEmoji: tracker?.emoji ?? "",
                            oldSelectedColor: tracker?.color ?? .ypBlack,
                            oldTrackerId: idTracker
                        )
                        createTrackerViewController.setTracker(name: tracker?.name ?? "")
                        createTrackerViewController.trackersDelegate = self
                        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
                        self?.present(navigationController, animated: true)
                    },
                    UIAction(title: "Удалить", attributes: .destructive){[weak self] _ in
                        let alert = UIAlertController(
                            title: nil,
                            message: "Уверены что хотите удалить трекер?",
                            preferredStyle: .actionSheet
                        )
                        let actionDelete = UIAlertAction(
                            title: "Удалить",
                            style: .destructive){[weak self] _ in
                                print(#fileID, #function, #line)
                                self?.trackersPresenter?.deleteTracker(id: idTracker)
                            }
                        let actionCancel = UIAlertAction(
                            title: "Отменить",
                            style: .cancel){ _ in
                                print(#fileID, #function, #line)
                            }
                        alert.addAction(actionDelete)
                        alert.addAction(actionCancel)
                        self?.present(alert, animated: true)
                    },
                ]
            )
        })
    }
    
    func getIdCell(index: IndexPath) -> UInt {
        let cell = collectionView.cellForItem(at: index) as? TrackerCollectionViewCell
        guard let id = cell?.getIdTracker() else {
            assertionFailure("getIdCell cell?.getIdTracker() nil")
            return 0
        }
        print(#fileID, #function, #line, "name: \(id)")
        return id
    }
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
    func changeTracker(tracker: Tracker, category: String) {
        trackersPresenter?.changeTracker(tracker: tracker, category: category)
        hideEmptyImage(setHidden: true)
        collectionView.reloadData()
    }
    
    func setTracker(tracker: Tracker, category: String) {
        trackersPresenter?.setTracker(tracker: tracker, category: category)
        hideEmptyImage(setHidden: true)
    }
    
    func cleanAllFilters() {
        trackersPresenter?.cleanAllFilters()
        collectionView.reloadData()
    }
    
    func todayFilter() {
        trackersPresenter?.todayFilter()
        collectionView.reloadData()
    }
    
    func completedFilter() {
        trackersPresenter?.completedFilter()
        collectionView.reloadData()
    }
    
    func uncompletedFilter() {
        trackersPresenter?.uncompletedFilter()
        collectionView.reloadData()
    }
}
