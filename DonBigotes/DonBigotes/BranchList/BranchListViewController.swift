//
//  BranchListViewController.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import UIKit

class BranchListViewController: UIViewController {
    
    private var viewModel: BranchListViewModel
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(branches: [Branch]) {
        self.viewModel = BranchListViewModel(branches: branches)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sucursales"
        setupTableView()
        setupSearch()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BranchCell")
        tableView.backgroundColor = .systemBackground
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension BranchListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredBranches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "BranchCell")
        let branch = viewModel.getBranch(at: indexPath.row)
        
        cell.textLabel?.text = branch.name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        cell.detailTextLabel?.text = branch.address
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBranch = viewModel.getBranch(at: indexPath.row)
        let detailVC = BranchDetailViewController(branch: selectedBranch)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BranchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterData(searchText: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }
}
