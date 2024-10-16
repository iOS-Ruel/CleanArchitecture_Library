//
//  MockUserRepository.swift
//  CleanArchitectureTestTests
//
//  Created by Chung Wussup on 10/16/24.
//

import Foundation
@testable import CleanArchitectureTest

public struct MockUserRepository: UserRepositoryProtocol {
    public func fetchUser(query: String, page: Int) async -> Result<CleanArchitectureTest.UserListResult, CleanArchitectureTest.NetworkError> {
        .failure(.dataNil)
    }
    
    public func getFavoriteUsers() -> Result<[CleanArchitectureTest.UserListItem], CleanArchitectureTest.CoreDataError> {
        .failure(.entityNotFount(""))
    }
    
    public func saveFavoriteUser(user: CleanArchitectureTest.UserListItem) -> Result<Bool, CleanArchitectureTest.CoreDataError> {
        .failure(.entityNotFount(""))
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CleanArchitectureTest.CoreDataError> {
        .failure(.entityNotFount(""))
    }
    
    
}
