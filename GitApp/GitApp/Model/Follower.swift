//
//  Follower.swift
//  GitApp
//
//  Created by Adrian Gutierrez on 15/01/26.
//

import Foundation

struct Follower: Codable, Sendable {
    var login: String
    var avatarUrl: String
}

// Make the Hashable conformance explicitly nonisolated so it can be used
// with APIs that require Sendable generic parameters.
nonisolated extension Follower: Hashable {
    static func == (lhs: Follower, rhs: Follower) -> Bool {
        lhs.login == rhs.login && lhs.avatarUrl == rhs.avatarUrl
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
        hasher.combine(avatarUrl)
    }
}
