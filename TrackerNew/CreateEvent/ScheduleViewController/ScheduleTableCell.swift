//
//  ScheduleTableCell.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import UIKit

final class ScheduleTableCell: UITableViewCell {
    
    //MARK: - Visual Components
    private var textLabelCell: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .ypBlack
        return view
    }()
    
    private lazy var checkBox: UISwitch = {
        let view = UISwitch()
        view.addTarget(
            self,
            action: #selector(checkBoxChanged(_:)),
            for: .valueChanged
        )
        view.onTintColor = .ypBlue
        return view
    }()
    
    // MARK: - Public Properties
    private(set) var isCheckDay = false
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        print(#fileID, #function, #line)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypGray30
        
        [
            textLabelCell,
            checkBox
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        addConstraintTextLabelCell()
        addConstraintCheckBox()
    }
    
    required init?(coder: NSCoder) {
        print(#fileID, #function, #line)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setTextInTextLabelCell(text: String) {
        print(#fileID, #function, #line)
        textLabelCell.text = text
    }
    
    // MARK: - Private Methods
    private func addConstraintTextLabelCell() {
        NSLayoutConstraint.activate([
            textLabelCell.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabelCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func addConstraintCheckBox() {
        NSLayoutConstraint.activate([
            checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkBox.heightAnchor.constraint(equalToConstant: 31),
            checkBox.widthAnchor.constraint(equalToConstant: 51)
        ])
    }
    
    @objc private func checkBoxChanged(_ sender: UISwitch){
        print(#fileID, #function, #line, "sender.isOn: \(sender.isOn)")
        isCheckDay = sender.isOn
    }
}
