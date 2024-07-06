//
//  TableCell.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class TackerTableCell: UITableViewCell {
    
    //MARK: - Visual Components
    private var textTitleLabelCell: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .ypBlack
        return view
    }()
    
    private var textSubtitleLabelCell: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .ypGray
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        //        let view = UIStackView(arrangedSubviews: [textTitleLabelCell, textSubtitleLabelCell])
        let view = UIStackView(arrangedSubviews: [textTitleLabelCell])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 2
        return view
    }()
    
    private var imageChevron: UIImageView = {
        let image = UIImage(named: "Chevron")
        let view = UIImageView(image: image)
        view.tintColor = .ypGray
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        print(#fileID, #function, #line)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypGray30
        
        [
            stackView,
            imageChevron
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        [
            textTitleLabelCell,
            textSubtitleLabelCell
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraintStackView()
        addConstraintImageChevron()
    }
    
    required init?(coder: NSCoder) {
        print(#fileID, #function, #line)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setTextInCell(title: String, subtitle: String) {
        print(#fileID, #function, #line)
        textTitleLabelCell.text = title
        if subtitle == "" {
            if stackView.contains(textSubtitleLabelCell) {
                stackView.removeArrangedSubview(textSubtitleLabelCell)
            }
        } else {
            if !stackView.contains(textSubtitleLabelCell) {
                stackView.addArrangedSubview(textSubtitleLabelCell)
            }
            textSubtitleLabelCell.text = subtitle
        }
    }
    
    // MARK: - Private Methods
    private func addConstraintStackView() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func addConstraintImageChevron() {
        NSLayoutConstraint.activate([
            imageChevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageChevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imageChevron.heightAnchor.constraint(equalToConstant: 24),
            imageChevron.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
