//
//  BranchListViewmodel.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import Foundation

class BranchListViewModel {
    private var allBranches: [Branch]
    var filteredBranches: [Branch]
    
    init(branches: [Branch]) {
        self.allBranches = branches
        self.filteredBranches = branches
    }
    
    func filterData(searchText: String) {
        if searchText.isEmpty {
            filteredBranches = allBranches
        } else {
            filteredBranches = allBranches.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.address.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func getBranch(at index: Int) -> Branch {
        return filteredBranches[index]
    }
}
