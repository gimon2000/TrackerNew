//
//  CreateTrackerViewController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController, CreateTrackerViewControllerProtocol {
    
    //MARK: - Visual Components
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.alwaysBounceVertical = true
        return view
    }()
    
    private var textField: UITextField = {
        let view = UITextField()
        view.placeholder = NSLocalizedString(
            "text.field.placeholder",
            comment: "Text displayed in placeholder"
        )
        view.backgroundColor = .ypGray30
        view.layer.cornerRadius = 16
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        view.leftView = leftView
        view.leftViewMode = .always
        view.tintColor = .ypBlue
        return view
    }()
    
    private lazy var createButton: UIButton = {
        let view = UIButton(type: .custom)
        let createText = NSLocalizedString(
            "create.button",
            comment: "Text displayed in button"
        )
        view.setTitle(createText, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypGray
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(clickCreateButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let view = UIButton(type: .custom)
        let cancelText = NSLocalizedString(
            "cancel.button",
            comment: "Text displayed in button"
        )
        view.setTitle(cancelText, for: .normal)
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
    
    private var tableViewCategoryAndSchedule: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 16
        view.separatorColor = .ypGray
        return view
    }()
    
    private let titleEmojis: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        view.textColor = .ypBlack
        view.text = NSLocalizedString(
            "title.emojis",
            comment: "Text displayed in title emoji"
        )
        return view
    }()
    
    private let titleColors: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        view.textColor = .ypBlack
        view.text = NSLocalizedString(
            "title.colors",
            comment: "Text displayed in title colors"
        )
        return view
    }()
    
    private var emojisCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private var colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var countDaysLabel: UILabel = {
        let view = UILabel()
        view.textColor = .ypBlack
        view.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.text = countDaysText
        return view
    }()
    
    //MARK: - Public Property
    var createTrackerPresenter: CreateTrackerPresenterProtocol?
    weak var delegate: SelectTypeEventViewControllerDelegate?
    weak var trackersDelegate: TrackersViewControllerDelegate?
    
    //MARK: - Private Property
    private var navigationTitle: String
    private let cellReuseIdentifier = "tableCellIdentifier"
    private var numberOfRowsInSection: Int
    private lazy var tapGesture = UITapGestureRecognizer(
        target: view,
        action: #selector(view.endEditing)
    )
    private let emojiCellIdentifier = "emojiCellIdentifier"
    private let colorCellIdentifier = "colorCellIdentifier"
    private var trackerName: String?
    private var countDaysText: String?
    
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
            scrollView,
            countDaysLabel,
            textField,
            stackView,
            createButton,
            cancelButton,
            tableViewCategoryAndSchedule,
            titleEmojis,
            emojisCollectionView,
            titleColors,
            colorsCollectionView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(scrollView)
        [
            countDaysLabel,
            textField,
            stackView,
            tableViewCategoryAndSchedule,
            titleEmojis,
            emojisCollectionView,
            titleColors,
            colorsCollectionView,
        ].forEach{
            scrollView.addSubview($0)
        }
        
        tableViewCategoryAndSchedule.delegate = self
        tableViewCategoryAndSchedule.dataSource = self
        
        tableViewCategoryAndSchedule.register(
            TackerTableCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        
        emojisCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: emojiCellIdentifier)
        emojisCollectionView.delegate = self
        emojisCollectionView.dataSource = self
        emojisCollectionView.allowsMultipleSelection = false
        
        colorsCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: colorCellIdentifier)
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        colorsCollectionView.allowsMultipleSelection = false
        
        addConstraintScrollView()
        addConstraintCountDaysLabel()
        addConstraintTextField()
        addConstraintStackView()
        addConstraintCreateButton()
        addConstraintCancelButton()
        addConstraintTableView()
        addConstraintTitleEmojis()
        addConstraintEmojisCollectionView()
        addConstraintTitleColors()
        addConstraintColorsCollectionView()
        
        textField.delegate = self
        if let trackerName {
            textField.text = trackerName
        }
        changeStateCreateButton()
    }
    
    func setTracker(name: String) {
        trackerName = name
    }
    
    func setCountDays(count: String){
        countDaysText = count
    }
    
    // MARK: - Private Methods
    private func addConstraintScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func addConstraintCountDaysLabel() {
        NSLayoutConstraint.activate([
            countDaysLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countDaysLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    private func addConstraintTextField() {
        
        if countDaysText != nil {
            textField.topAnchor.constraint(equalTo: countDaysLabel.bottomAnchor, constant: 40).isActive = true
        } else {
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        }
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func addConstraintStackView() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            stackView.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 40)
        ])
    }
    
    private func addConstraintTableView() {
        NSLayoutConstraint.activate([
            tableViewCategoryAndSchedule.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewCategoryAndSchedule.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableViewCategoryAndSchedule.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableViewCategoryAndSchedule.heightAnchor.constraint(equalToConstant: CGFloat(75 * numberOfRowsInSection))
        ])
    }
    
    private func addConstraintTitleEmojis() {
        NSLayoutConstraint.activate([
            titleEmojis.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            titleEmojis.topAnchor.constraint(equalTo: tableViewCategoryAndSchedule.bottomAnchor, constant: 32),
        ])
    }
    
    private func addConstraintTitleColors() {
        NSLayoutConstraint.activate([
            titleColors.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            titleColors.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 40),
        ])
    }
    
    private func addConstraintEmojisCollectionView() {
        NSLayoutConstraint.activate([
            emojisCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            emojisCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            emojisCollectionView.topAnchor.constraint(equalTo: titleEmojis.bottomAnchor, constant: 24),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(52 * 3))
        ])
    }
    
    private func addConstraintColorsCollectionView() {
        NSLayoutConstraint.activate([
            colorsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            colorsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            colorsCollectionView.topAnchor.constraint(equalTo: titleColors.bottomAnchor, constant: 24),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(52 * 3))
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
        let name = textField.text
        createTrackerPresenter?.createTracker(name: name ?? "Название отсутсвует")
        self.dismiss(animated: true)
    }
    
    @objc private func clickCancelButton() {
        print(#fileID, #function, #line)
        self.dismiss(animated: true)
    }
    
    private func changeStateCreateButton() {
        let textFieldIsEmpty = textField.text?.isEmpty ?? true
        let weekdaysCheckedIsEmpty = createTrackerPresenter?.isWeekdaysCheckedNil() ?? true
        let categoryCheckedIsEmpty = createTrackerPresenter?.categoryCheckedIsEmpty() ?? true
        let selectedEmojiIsEmpty = createTrackerPresenter?.selectedEmojiIsEmpty() ?? true
        let selectedColorIsEmpty = createTrackerPresenter?.selectedColorIsEmpty() ?? true
        if !textFieldIsEmpty &&
            (!weekdaysCheckedIsEmpty || numberOfRowsInSection != 2) &&
            !selectedEmojiIsEmpty &&
            !selectedColorIsEmpty &&
            !categoryCheckedIsEmpty
        {
            print(#fileID, #function, #line)
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
        } else {
            print(#fileID, #function, #line)
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
}

//MARK: - UITableViewDelegate
extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "indexPath: \(indexPath)")
        if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            present(navigationController, animated: true)
        }
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            categoryViewController.categoryViewModel = CategoryViewModel()
            categoryViewController.initViewModel()
            let navigationController = UINavigationController(rootViewController: categoryViewController)
            present(navigationController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
        ) as? TackerTableCell else {
            print(#fileID, #function, #line)
            return UITableViewCell()
        }
        
        let titleCategory = NSLocalizedString(
            "title.table.cell.category",
            comment: "Text displayed in title table"
        )
        
        let titleSchedule = NSLocalizedString(
            "title.table.cell.schedule",
            comment: "Text displayed in title table"
        )
        
        let title = [titleCategory, titleSchedule]
        var subtitle = ""
        if indexPath.row == 1 {
            subtitle = createTrackerPresenter?.getSubtitleSchedule() ?? ""
        }
        if indexPath.row == 0 {
            subtitle = createTrackerPresenter?.getSubtitleCategory() ?? ""
        }
        cell.setTextInCell(title: title[indexPath.row], subtitle: subtitle)
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

//MARK: - CreateTrackerViewControllerDelegate
extension CreateTrackerViewController: CreateTrackerViewControllerDelegate {
    
    func setCategoryChecked(nameCategory: String) {
        createTrackerPresenter?.setCategoryChecked(nameCategory: nameCategory)
        tableViewCategoryAndSchedule.reloadData()
        changeStateCreateButton()
        print(#fileID, #function, #line, "nameCategory: \(nameCategory)")
    }
    
    func setWeekdaysChecked(_ weekdaysCheckedArray: [Weekdays]) {
        createTrackerPresenter?.setWeekdaysChecked(weekdaysChecked:weekdaysCheckedArray)
        tableViewCategoryAndSchedule.reloadData()
        changeStateCreateButton()
        print(#fileID, #function, #line, "weekdaysCheckedArray: \(String(describing: weekdaysCheckedArray))")
    }
    
    func containWeekday(weekday: Weekdays) -> Bool {
        print(#fileID, #function, #line)
        return createTrackerPresenter?.containWeekday(weekday: weekday) ?? false
    }
}

//MARK: - UITextFieldDelegate
extension CreateTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#fileID, #function, #line)
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(#fileID, #function, #line)
        changeStateCreateButton()
    }
}

//MARK: - UICollectionViewDelegate
extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#fileID, #function, #line)
        if collectionView == emojisCollectionView {
            createTrackerPresenter?.setSelectedEmoji(index: indexPath.row)
        }
        if collectionView == colorsCollectionView {
            createTrackerPresenter?.setSelectedColor(index: indexPath.row)
        }
        changeStateCreateButton()
    }
}

//MARK: - UICollectionViewDataSource
extension CreateTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#fileID, #function, #line)
        if collectionView == emojisCollectionView {
            return createTrackerPresenter?.arrayEmojis.count ?? 0
        }
        if collectionView == colorsCollectionView {
            return createTrackerPresenter?.arrayColors.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojisCollectionView {
            guard let cell = emojisCollectionView.dequeueReusableCell(withReuseIdentifier: emojiCellIdentifier, for: indexPath) as? EmojiCollectionViewCell else {
                return UICollectionViewCell()
            }
            print(#fileID, #function, #line)
            cell.emojiLabel.text = createTrackerPresenter?.arrayEmojis[indexPath.row]
            if let index = createTrackerPresenter?.getIndexSelectedEmoji(), index == indexPath.row {
                collectionView.selectItem(
                    at: indexPath,
                    animated: true,
                    scrollPosition: .top
                )
            }
            return cell
        }
        if collectionView == colorsCollectionView {
            guard let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: colorCellIdentifier, for: indexPath) as? ColorCollectionViewCell else {
                return UICollectionViewCell()
            }
            print(#fileID, #function, #line)
            cell.colorView.backgroundColor = createTrackerPresenter?.arrayColors[indexPath.row] ?? .ypRed
            if let index = createTrackerPresenter?.getIndexSelectedColor(), index == indexPath.row {
                collectionView.selectItem(
                    at: indexPath,
                    animated: true,
                    scrollPosition: .top
                )
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(#fileID, #function, #line)
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        print(#fileID, #function, #line)
        if collectionView == emojisCollectionView {
            return (emojisCollectionView.bounds.width - 52 * 6) / 5
        }
        if collectionView == colorsCollectionView {
            return (colorsCollectionView.bounds.width - 52 * 6) / 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(#fileID, #function, #line)
        return 0
    }
    
}
