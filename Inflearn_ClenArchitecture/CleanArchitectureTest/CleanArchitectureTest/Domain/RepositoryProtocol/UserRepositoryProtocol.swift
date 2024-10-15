//
//  UserRepositoryProtocol.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/15/24.
//

import Foundation

public protocol UserRepositoryProtocol {
    // 코어데이터와 네트워크에 접근해서 유저리스트에 대한 CRUD작업을 필요로함
    
    //UserListItem 혹은 실패일 경우 NetworkError를 받아올것이기 때문에 async 사용
    // ->유저리스트 불러오기(원격)
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
    
    //유저 리스트 조회 -> 전체 즐겨찾기 리스트 불러오기
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>
    
    //코어데이터이기 때문에 async는 필요없음
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    
    //삭제
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
}
