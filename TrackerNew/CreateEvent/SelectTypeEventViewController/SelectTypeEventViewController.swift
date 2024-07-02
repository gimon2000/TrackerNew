//
//  SelectTypeEventViewController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class SelectTypeEventViewController: UIViewController {
    
    //MARK: - Visual Components
    private lazy var addNewHabit: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Привычка", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(clickAddNewHabit), for: .touchUpInside)
        return view
    }()
    
    private lazy var addNewIrregularEvent: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Нерегулярное событие", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(clickAddNewIrregularEvent), for: .touchUpInside)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [addNewHabit, addNewIrregularEvent])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()
    
    //MARK: - Public Properties
    weak var delegate: TrackersViewControllerDelegate?
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line)
        
        view.backgroundColor = .white
        
        navigationItem.title = "Создание трекера"
        
        [
            stackView,
            addNewHabit,
            addNewIrregularEvent
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(stackView)
        
        addConstraintStackView()
        addConstraintAddNewHabit()
        addConstraintAddNewIrregularEvent()
    }
    
    // MARK: - Private Methods
    private func addConstraintStackView() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addConstraintAddNewHabit() {
        NSLayoutConstraint.activate([
            addNewHabit.heightAnchor.constraint(equalToConstant: 60),
            addNewHabit.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            addNewHabit.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    private func addConstraintAddNewIrregularEvent() {
        NSLayoutConstraint.activate([
            addNewIrregularEvent.heightAnchor.constraint(equalToConstant: 60),
            addNewIrregularEvent.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            addNewIrregularEvent.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    @objc private func clickAddNewHabit () {
        print(#fileID, #function, #line)
        clickAddNewEvent(
            navigationTitle: "Новая привычка",
            numberOfRowsInSection: 2
        )
    }
    
    @objc private func clickAddNewIrregularEvent () {
        print(#fileID, #function, #line)
        clickAddNewEvent(
            navigationTitle: "Новое нерегулярное событие",
            numberOfRowsInSection: 1
        )
    }
    
    private func clickAddNewEvent (navigationTitle: String, numberOfRowsInSection: Int) {
        print(#fileID, #function, #line)
        let createTrackerViewController = CreateTrackerViewController(
            navigationTitle: navigationTitle,
            numberOfRowsInSection: numberOfRowsInSection
        )
        let createTrackerPresenter = CreateTrackerPresenter()
        createTrackerViewController.createTrackerPresenter = createTrackerPresenter
        createTrackerPresenter.createTrackerView = createTrackerViewController
        createTrackerViewController.delegate = self
        navigationController?.pushViewController(createTrackerViewController, animated: true)
    }
    
}

// MARK: - SelectTypeEventViewControllerDelegate
extension SelectTypeEventViewController: SelectTypeEventViewControllerDelegate {
    func setTracker(tracker: Tracker) {
        delegate?.setTracker(tracker: tracker)
    }
}
