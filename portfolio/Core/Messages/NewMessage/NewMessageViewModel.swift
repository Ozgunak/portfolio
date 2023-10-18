//
//  NewMessageViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import Foundation
import Firebase

@MainActor
class NewMessageViewModel: ObservableObject {
    @Published var users = [DBUser]()
    @Published var searchResultUsers = [DBUser]()

    func fetchAllUsers() async throws {
        var userlist = try await FirestoreManager.shared.fetchAllUsers()
        userlist.removeAll(where: { $0.id == Auth.auth().currentUser?.uid })
        users = userlist
    }
}
