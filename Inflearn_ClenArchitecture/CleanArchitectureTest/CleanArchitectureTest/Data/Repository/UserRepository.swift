//
//  UserRepository.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/15/24.
//

import Foundation

public struct UserRepository: UserRepositoryProtocol {
    
    private let coredata: UserCoreDataProtocol, network: UserNetworkProtocol
    
    init(coreData: UserCoreDataProtocol, network: UserNetworkProtocol) {
        self.coredata = coreData
        self.network = network
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await network.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        return coredata.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        return coredata.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        return coredata.deleteFavoriteUser(userID: userID)
    }
    
    
}
