//
//  CategoryTableCell.swift
//  TrackerNew
//
//  Created by gimon on 05.08.2024.
//

import UIKit

final class CategoryTableCell: UITableViewCell {
    
    //MARK: - Visual Components
    private var textLabelCell: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .ypBlack
        return view
    }()
    
    private lazy var checkmarkImage: UIImageView = {
        guard let image = UIImage(named: "checkmarkCell") else {
            return UIImageView()
        }
        let view = UIImageView(image: image)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        print(#fileID, #function, #line)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypGray30
        
        [
            textLabelCell,
            checkmarkImage
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        addConstraintTextLabelCell()
        addConstraintCheckmarkImage()
    }
    
    required init?(coder: NSCoder) {
        print(#fileID, #function, #line)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setDataInCell(text: String, doesCheckmarkHidden: Bool) {
        print(#fileID, #function, #line, "text: \(text), doesCheckmarkHidden: \(doesCheckmarkHidden)")
        textLabelCell.text = text
        checkmarkImage.isHidden = doesCheckmarkHidden
    }
    
    func getNameCategory() -> String {
        print(#fileID, #function, #line, "text: \(String(describing: textLabelCell.text))")
        return textLabelCell.text ?? "Error"
    }
    
    // MARK: - Private Methods
    private func addConstraintTextLabelCell() {
        NSLayoutConstraint.activate([
            textLabelCell.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabelCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func addConstraintCheckmarkImage() {
        NSLayoutConstraint.activate([
            checkmarkImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkmarkImage.heightAnchor.constraint(equalToConstant: 24),
            checkmarkImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
