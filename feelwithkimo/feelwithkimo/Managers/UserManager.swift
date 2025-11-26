//
//  UserManager.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import Foundation

internal class UserManager {
    // MARK: - Properties
    static let shared = UserManager()

    // MARK: - Lifecycle
    private init() {}

    // MARK: - Public Methods

    /// Mengambil data pengguna yang sedang login.
    /// Dalam aplikasi nyata, fungsi ini akan berkomunikasi dengan server atau database.
    /// - Returns: Sebuah instance `UserModel`.
    func getCurrentUser() -> UserModel {
        // Data dummy untuk contoh
        return UserModel(id: UUID(), name: "Cynthia")
    }
}
