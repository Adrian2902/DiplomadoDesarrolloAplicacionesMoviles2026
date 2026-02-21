//
//  BranchDetailViewModel.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import Foundation

class BranchDetailViewModel {
    let branch: Branch
    
    init(branch: Branch) {
        self.branch = branch
    }

    var name: String { branch.name }
    var address: String { branch.address }
    var phone: String { "Telefono: \(branch.phone)" }
    
    var servicesList: String {
        branch.services.joined(separator: "\n• ")
    }

    var formattedHours: [(day: String, hours: String)] {
        var hours = [(String, String)]()
        
        hours.append(("Lunes - Viernes", "\(branch.openingHours.weekdays.open) - \(branch.openingHours.weekdays.close)"))
        
        hours.append(("Sábado", "\(branch.openingHours.saturday.open) - \(branch.openingHours.saturday.close)"))
        
        if let sunday = branch.openingHours.sunday {
            hours.append(("Domingo", "\(sunday.open) - \(sunday.close)"))
        } else {
            hours.append(("Domingo", "Cerrado"))
        }
        
        return hours
    }
}
