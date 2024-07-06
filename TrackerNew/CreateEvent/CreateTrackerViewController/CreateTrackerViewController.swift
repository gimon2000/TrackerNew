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
        view.placeholder = "Введите название трекера"
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
        view.setTitle("Создать", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypGray
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
        view.text = "Emoji"
        return view
    }()
    
    private var emojisCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    //MARK: - Public Property
    var createTrackerPresenter: CreateTrackerPresenterProtocol?
    weak var delegate: SelectTypeEventViewControllerDelegate?
    
    //MARK: - Private Property
    private var navigationTitle: String
    private let cellReuseIdentifier = "tableCellIdentifier"
    private var numberOfRowsInSection: Int
    private lazy var tapGesture = UITapGestureRecognizer(
        target: view,
        action: #selector(view.endEditing)
    )
    private let emojiCellIdentifier = "emojiCellIdentifier"
    
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
            textField,
            stackView,
            createButton,
            cancelButton,
            tableViewCategoryAndSchedule,
            titleEmojis,
            emojisCollectionView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(scrollView)
        [
            textField,
            stackView,
            tableViewCategoryAndSchedule,
            titleEmojis,
            emojisCollectionView
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
        
        addConstraintScrollView()
        addConstraintTextField()
        addConstraintStackView()
        addConstraintCreateButton()
        addConstraintCancelButton()
        addConstraintTableView()
        addConstraintTitleEmojis()
        addConstraintEmojisCollectionView()
        
        textField.delegate = self
        changeStateCreateButton()
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
    
    private func addConstraintTextField() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24)
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
    
    private func addConstraintEmojisCollectionView() {
        NSLayoutConstraint.activate([
            emojisCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            emojisCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            emojisCollectionView.topAnchor.constraint(equalTo: titleEmojis.bottomAnchor, constant: 24),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(52 * 3))
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
        let createTrackerPresenterIsEmpty = createTrackerPresenter?.isWeekdaysCheckedNil() ?? true
        let selectedEmojiIsEmpty = createTrackerPresenter?.selectedEmojiIsEmpty() ?? true
        if !textFieldIsEmpty &&
            (!createTrackerPresenterIsEmpty || numberOfRowsInSection != 2) &&
            !selectedEmojiIsEmpty {
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
        let title = ["Категория", "Расписание"]
        var subtitle = ""
        if indexPath.row == 1 {
            subtitle = createTrackerPresenter?.getSubtitle() ?? ""
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

//MARK: - ScheduleViewControllerDelegate
extension CreateTrackerViewController: ScheduleViewControllerDelegate {
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
        createTrackerPresenter?.setSelectedEmoji(index: indexPath.row)
        changeStateCreateButton()
    }
}

//MARK: - UICollectionViewDataSource
extension CreateTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#fileID, #function, #line)
        return createTrackerPresenter?.arrayEmojis.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = emojisCollectionView.dequeueReusableCell(withReuseIdentifier: emojiCellIdentifier, for: indexPath) as? EmojiCollectionViewCell else {
            return UICollectionViewCell()
        }
        print(#fileID, #function, #line)
        cell.emojiLabel.text = createTrackerPresenter?.arrayEmojis[indexPath.row]
        return cell
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
        return (emojisCollectionView.bounds.width - 52 * 6) / 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(#fileID, #function, #line)
        return 0
    }
    
}
