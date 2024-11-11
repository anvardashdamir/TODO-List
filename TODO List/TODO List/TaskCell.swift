//
//  TaskCell.swift
//  TODO List
//
//  Created by Enver's Macbook Pro on 11/2/24.
//

import UIKit

class TaskCell: UITableViewCell {
    
    // MARK: - Properties
    var onTextChanged: ((String) -> Void)?
    var inCheckboxChanged: ((Bool) -> Void)?
    
    let checkbox: UIImageView = {
        let checkbox = UIImageView()
        checkbox.image = .uncheck
        checkbox.contentMode = .scaleAspectFit
        return checkbox
    }()
    
    let taskField: UITextField = {
        let taskField = UITextField()
        taskField.placeholder = "What's the task?"
        taskField.font = UIFont.systemFont(ofSize: 16)
        taskField.borderStyle = .none
        taskField.returnKeyType = .done
        return taskField
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupSubviews()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    func setupSubviews() {
        contentView.addSubview(checkbox)
        contentView.addSubview(taskField)
    }
    
    func setupActions() {
        // Checkbox reacts when you tap on it
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
        checkbox.isUserInteractionEnabled = true
        checkbox.addGestureRecognizer(tapGesture)
        
        taskField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
    }
    
    func setupLayout() {
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        taskField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24),
            checkbox.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            taskField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskField.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12),
            taskField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    // MARK: - Action Methods

    @objc func toggleCheckbox() {
        let isChecked = checkbox.image == .checked
        checkbox.image = isChecked ? .uncheck : .checked
        inCheckboxChanged?(!isChecked)
        applyStrikethrough(!isChecked)
    }
    
    @objc func textDidChanged() {
        onTextChanged?(taskField.text ?? "")
    }

    // MARK: - Helper Methods
    
    func configure(with text: String, isCompleted: Bool) {
        taskField.text = text
        checkbox.image = isCompleted ? .checked : .uncheck
        applyStrikethrough(isCompleted)
    }
    
    func applyStrikethrough(_ isCompleted: Bool) {
        let text = taskField.text ?? ""
        taskField.attributedText = NSAttributedString(
            string: text,
            attributes: isCompleted ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]
        )
    }
}
