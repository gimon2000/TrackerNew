//
//  StatisticTableCell.swift
//  TrackerNew
//
//  Created by gimon on 18.08.2024.
//

import UIKit

final class StatisticTableCell: UITableViewCell {
    
    //MARK: - Visual Components
    private var titleLabelCell: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.textColor = .ypBlack
        return view
    }()
    
    private var subtitleLabelCell: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .ypBlack
        view.text = NSLocalizedString(
            "statistic.subtitle.label.cell.text",
            comment: "Text displayed on empty state"
        )
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        print(#fileID, #function, #line)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        
        [
            titleLabelCell,
            subtitleLabelCell
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        addConstraintTitleLabelCell()
        addConstraintSubtitleLabelCell()
    }
    
    required init?(coder: NSCoder) {
        print(#fileID, #function, #line)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setTitleInCell(text: String) {
        print(#fileID, #function, #line, "text: \(text)")
        titleLabelCell.text = text
    }
    
    // MARK: - Private Methods
    private func addConstraintTitleLabelCell() {
        NSLayoutConstraint.activate([
            titleLabelCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabelCell.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        ])
    }
    
    private func addConstraintSubtitleLabelCell() {
        NSLayoutConstraint.activate([
            subtitleLabelCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            subtitleLabelCell.topAnchor.constraint(equalTo: titleLabelCell.bottomAnchor, constant: 7)
        ])
    }
}
