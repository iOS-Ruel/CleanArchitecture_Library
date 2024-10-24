//
//  UserListViewModel.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/18/24.
//

import Foundation
import RxSwift
import RxCocoa


protocol UserListViewModelProtocol {
    func transform(input: UserListViewModel.Input) -> UserListViewModel.Output
}

public final class UserListViewModel: UserListViewModelProtocol {
    private let usecase: UserListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) //fetchuser 즐겨찾기 여부를 위한 전체 목록
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 목록에 보여줄 리스트
    private var page: Int = 1
    
    public init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    
    //VC에서 이벤트가 발생 (사용자 액션) -> ViewModel에 전달
    // ViewModel은 데이터를 가공 or 외부에서 데이터 호출 or 뷰 데이터 전달(상태값 등)
    //-> VC에 전달
    
    //VC(이벤트) -(input)-> VM -(output)-> VC
    
    public struct Input { //VM에 전달되어야할 이벤트
        //탭, 텍스트필드, 즐겨찾기 추가/삭제, 페이지네이션 Observable
        let tabButtonType: Observable<TabButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
    }
    
    public struct Output {
        //VC에게 전달할 view관련 데이터, cell Data(유저리스트), error,
        let cellData: Observable<[UserListCellData]>
        let error: Observable<String>
    }
    
    //VC에서 이벤트가 전달되면 VM에 데이터 반환
    public func transform(input: Input) -> Output {
        input.query.bind {[weak self] query in
            //TODO: user fetch or Get favorite users
            guard let self = self, validateQuery(query: query) else {
                self?.getFavoriteUsers(query: "")
                return
            }
            
            page = 1
            //유저가 텍스트필드에 입력을 했다면
            //처음 검색했을 때는 페이지가 0이기 때문에 페이지를 0으로 지정
            fetchUser(query: query, page: page)
            getFavoriteUsers(query: query)
        }
        .disposed(by: disposeBag)
        
        input.saveFavorite
            .withLatestFrom(input.query, resultSelector: { users, query in
                return (users, query)
            })
            .bind {[weak self] user, query in
            //TODO: 즐겨찾기 추가
            self?.saveFavoriteUser(user: user, query: query)
        }
        .disposed(by: disposeBag)
        
        input.deleteFavorite
            .withLatestFrom(input.query, resultSelector: { ($0, $1) })
            .bind {[weak self] userID, query in
            //TODO: 즐겨찾기 삭제
                self?.deleteFavoriteUser(userId: userID, query: query)
        }
        .disposed(by: disposeBag)
        
        input.fetchMore
            .withLatestFrom(input.query)
            .bind {[weak self] query in
            //TODO: 다음페이지 검색
                guard let self = self else { return }
                page += 1
                fetchUser(query: query, page: page)
        }
        .disposed(by: disposeBag)
        
        
        //탭 -> api 유저 or 즐겨찾기 유저
        
        //유저리스트, 즐겨찾기 리스트
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList).map {[weak self] tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList in
            
            var cellData: [UserListCellData] = []
            guard let self = self else { return cellData}
            
            
            //TODO: cellData 생성
            //탭 타입에 따라 fetchuser list // favoriteuser list
            switch tabButtonType {
            case .api:
                //탭 타입에 따라 favoriteuser list
                let tuple = usecase.checkFavoriteState(fetchUsers: fetchUserList, favoriteUsers: allFavoriteUserList)
                let userCellList = tuple.map { user, isFavorite in
                    UserListCellData.user(user: user, isFavorite: isFavorite)
                }
                return userCellList
            case .favorite:
                //탭 타입에 따라 favoriteuser list
                
                // favorite user를 가지고 초성값을 가지고 dic로 분류
                let dic = usecase.convertListToDictionary(favoriteUsers: favoriteUserList)
                //key를 sorted하고
                let keys = dic.keys.sorted()
                //key를 가지고 반복문
                keys.forEach { key in
                    cellData.append(.header(key))
                    if let users = dic[key] {
                        cellData += users.map { UserListCellData.user(user: $0, isFavorite: true) }
                    }
                }
            }
            
            return cellData
        }
        return Output(cellData: cellData, error: error.asObservable())
        
    }
    
    private func fetchUser(query: String, page: Int) {
        guard let urlAllowQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        Task {
            let result = await usecase.fetchUser(query: urlAllowQuery, page: page)
            switch result {
            case let .success(users):
                if page == 0 {
                    //첫번째 페이지
                    fetchUserList.accept(users.items)
                } else {
                    //두번째 그이상 페이지
                    fetchUserList.accept(fetchUserList.value + users.items)
                }
                
            case let .failure(error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func getFavoriteUsers(query: String) {
        let result = usecase.getFavoriteUsers()
        switch result {
        case let .success(users):
            //검색했을 때 검색어가 있다면 필터링을 해줘야함
            if query.isEmpty {
                favoriteUserList.accept(users)
            } else {
                //전체리스트를 리턴
                let filteredUsers = users.filter { user in
                    user.login.contains(query)
                }
                favoriteUserList.accept(filteredUsers)
            }
            allFavoriteUserList.accept(users)
        
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    //즐겨찾기 추가
    private func saveFavoriteUser(user: UserListItem, query: String) {
        let result = self.usecase.saveFavoriteUser(user: user)
        switch result {
        case .success:
            //저장 후 getFavoriteUsers를 한번 더 호출해야 리스트가 갱신이 됨
            self.getFavoriteUsers(query: query)
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func deleteFavoriteUser(userId: Int, query: String) {
        let result = usecase.deleteFavoriteUser(userID: userId)
        switch result {
        case .success:
            self.getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func validateQuery(query: String) -> Bool {
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
}


public enum TabButtonType: String {
    case api = "API"
    case favorite = "Favorite"
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
