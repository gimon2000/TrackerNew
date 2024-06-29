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
    
    private var imageChevron: UIImageView = {
        let image = UIImage(named: "Chevron")
        let view = UIImageView(image: image)
        view.tintColor = .ypGray2
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        print(#fileID, #function, #line)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypGray
        
        [
            textTitleLabelCell,
            imageChevron
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        addConstraintTextLabelCell()
        addConstraintImageChevron()
    }
    
    required init?(coder: NSCoder) {
        print(#fileID, #function, #line)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setTextInTextLabelCell(text: String) {
        print(#fileID, #function, #line)
        textTitleLabelCell.text = text
    }
    
    // MARK: - Private Methods
    private func addConstraintTextLabelCell() {
        NSLayoutConstraint.activate([
            textTitleLabelCell.centerYAnchor.constraint(equalTo: centerYAnchor),
            textTitleLabelCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
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
