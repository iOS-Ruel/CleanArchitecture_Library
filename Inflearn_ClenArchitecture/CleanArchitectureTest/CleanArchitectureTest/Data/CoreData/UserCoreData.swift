//
//  UserCoreData.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/15/24.
//

import Foundation
import CoreData

public protocol UserCoreDataProtocol {
    //유저 리스트 조회 -> 전체 즐겨찾기 리스트 불러오기
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>
    
    //코어데이터이기 때문에 async는 필요없음
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    
    //삭제
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
}

public struct UserCoreData: UserCoreDataProtocol {
    private let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let userList: [UserListItem] = result.compactMap { favoriteUser in
                guard let login = favoriteUser.login,
                      let imageURL = favoriteUser.imageURL else { return nil }
                return UserListItem(id: Int(favoriteUser.id), login: login, imageURL: imageURL)
            }
            return .success(userList)
        } catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteUser", in: viewContext) else {
            return .failure(.entityNotFount("FavoriteUser"))
        }
        let userObject = NSManagedObject(entity: entity, insertInto: viewContext)
        userObject.setValue(user.id, forKey: "id")
        userObject.setValue(user.login, forKey: "login")
        userObject.setValue(user.imageURL, forKey: "imageURL")
        do {
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError(error.localizedDescription))
        }
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", userID)
        
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach { favoriteUser in
                viewContext.delete(favoriteUser)
            }
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.deleteErrorr(error.localizedDescription))
        }
    }    
}
