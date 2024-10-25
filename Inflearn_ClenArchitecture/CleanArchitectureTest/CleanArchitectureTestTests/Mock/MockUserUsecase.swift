//
//  MockUserUsecase.swift
//  CleanArchitectureTestTests
//
//  Created by Chung Wussup on 10/25/24.
//

import Foundation
@testable import CleanArchitectureTest

public class MockUserUsecase: UserListUsecaseProtocol {
    public var fetchUserResult: Result<UserListResult, NetworkError>?
    public var favoriteUserResult: Result<[UserListItem], CoreDataError>?
    
    
    public func fetchUser(query: String, page: Int) async -> Result<CleanArchitectureTest.UserListResult, CleanArchitectureTest.NetworkError> {
        fetchUserResult ?? .failure(.dataNil)
    }
    
    public func getFavoriteUsers() -> Result<[CleanArchitectureTest.UserListItem], CleanArchitectureTest.CoreDataError> {
        favoriteUserResult ?? .failure(.entityNotFount(""))
    }
    
    public func saveFavoriteUser(user: CleanArchitectureTest.UserListItem) -> Result<Bool, CleanArchitectureTest.CoreDataError> {
        .success(true)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CleanArchitectureTest.CoreDataError> {
        .success(true)
    }
    
    public func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] {

        let favoriteSet = Set(favoriteUsers)
        
        return  fetchUsers.map { user in
            if favoriteSet.contains(user) {
                return (user:user, isFavorite: true)
            } else {
                return (user:user, isFavorite: false)
            }
        }
    }
    
    public func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        return favoriteUsers.reduce(into: [String: [UserListItem]]()) { dic, user in
            if let firstString = user.login.first { //초성을 받아옴
                let key = String(firstString).uppercased() // 키값을 대문자로 변환
                dic[key, default: []].append(user) // 대문자로 변환한 키값을 통해서 value에 접근
            }
        }
    }
    
    
}
