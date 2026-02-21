//
//  DiaryListTableViewController.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import UIKit

class DiaryListTableViewController: UITableViewController {
    
    private let viewModel = DiaryListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis Entradas"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadEntries()
        tableView.reloadData()
    }
    
    @objc private func didTapAdd() {
      
        let editorVM = EntryEditorViewModel(existingEntry: nil)
        let editorVC = EntryEditorViewController(viewModel: editorVM)
        navigationController?.pushViewController(editorVC, animated: true)
    }
    
    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let entry = viewModel.entries[indexPath.row]

        cell.backgroundColor = .systemBackground
        cell.textLabel?.textColor = .label
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        cell.textLabel?.text = entry.title.isEmpty ? "Sin Título" : entry.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateStr = formatter.string(from: entry.date)
        
        if entry.isDraft {
         
            let draftString = NSMutableAttributedString(string: "BORRADOR - ", attributes: [.foregroundColor: UIColor.systemOrange, .font: UIFont.boldSystemFont(ofSize: 12)])
            draftString.append(NSAttributedString(string: dateStr))
            cell.detailTextLabel?.attributedText = draftString
        } else {
            cell.detailTextLabel?.text = dateStr
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = viewModel.entries[indexPath.row]
        
        if entry.isDraft {
            
            let editorVM = EntryEditorViewModel(existingEntry: entry)
            let editorVC = EntryEditorViewController(viewModel: editorVM)
            navigationController?.pushViewController(editorVC, animated: true)
        } else {
            
            let detailVM = EntryDetailViewModel(entry: entry)
            let detailVC = EntryDetailViewController(viewModel: detailVM)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - Swipe to Delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] (_, _, completion) in
            self?.viewModel.deleteEntry(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
