//
//  ViewController.swift
//  TODO List
//
//  Created by Enver's Macbook Pro on 11/2/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    // MARK: - Properties
    var tasks: [TaskModel] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TODO LIST"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.square"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        return button
    }()

    private let tableSection: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 12
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        return tableView
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        setupUI()
        setupLayout()
        setupTableView()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableSection)
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    }

    private func setupTableView() {
        tableSection.dataSource = self
        tableSection.delegate = self
    }

    // MARK: - Layout Setup
    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        tableSection.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableSection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableSection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableSection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Data Management
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    private func loadItems() {
        if let savedData = UserDefaults.standard.data(forKey: "tasks"),
           let savedTasks = try? JSONDecoder().decode([TaskModel].self, from: savedData) {
            tasks = savedTasks
        }
    }

    // MARK: - Actions
    @objc private func addTask() {
        let newTask = TaskModel(text: "", isCompleted: false)
        tasks.append(newTask)
        
        let newIndexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableSection.insertRows(at: [newIndexPath], with: .automatic)
        
        tableSection.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        
        DispatchQueue.main.async {
            if let cell = self.tableSection.cellForRow(at: newIndexPath) as? TaskCell {
                cell.taskField.becomeFirstResponder()
            }
        }        
        saveItems()
    }

    // MARK: - Table View Data Source & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }

        let task = tasks[indexPath.row]
        cell.configure(with: task.text, isCompleted: task.isCompleted)
        cell.checkbox.image = task.isCompleted ? .checked : .uncheck

        cell.onTextChanged = { [weak self] newText in
            self?.tasks[indexPath.row].text = newText
            self?.saveItems()
        }
        
        cell.taskField.delegate = self

        cell.inCheckboxChanged = { [weak self] isCompleted in
            self?.tasks[indexPath.row].isCompleted = isCompleted
            self?.saveItems()
        }
        return cell
    }
    
    // Dismiss keyboard when you press "DONE" key on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableSection.deleteRows(at: [indexPath], with: .automatic)
            saveItems()
        }
    }
}
