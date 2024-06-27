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
    
    //MARK: - Private Property
    
    //    private var categories: [TrackerCategory]?
    //    private var completedTrackers: [TrackerRecord]?
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewTracker)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        [
            emptyTrackersImage,
            emptyTrackersLabel,
            header,
            searchTextField
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        addConstraintHeader()
        addConstraintSearchTextField()
        addConstraintEmptyTrackersImage()
        addConstraintEmptyTrackersLabel()
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
