//
//  UserListUsecase.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/15/24.
//

import Foundation

public protocol UserListUsecaseProtocol {
    //UserListItem 혹은 실패일 경우 NetworkError를 받아올것이기 때문에 async 사용
    // ->유저리스트 불러오기(원격)
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
    
    //유저 리스트 조회 -> 전체 즐겨찾기 리스트 불러오기
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>
    
    //코어데이터이기 때문에 async는 필요없음
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    
    //삭제
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
    
    //배열을 딕셔너리 형태로 변환 -> [초성: [유저리스트]]
    
    //유저리스트 -> 즐겨찾기에 포함된 유저인지 체크
    
    
}

public struct UserListUsecase: UserListUsecaseProtocol {
    //repository는 데이터 영역에 있고 데이터 영역은 저수준
    //저수준 모듈을 의존하는 상황이 발생함
    
    private var repository: UserRepositoryProtocol
    public init(repository: UserRepositoryProtocol ) {
        self.repository = repository
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        await repository.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        repository.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        repository.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        repository.deleteFavoriteUser(userID: userID)
    }
    
    
}
