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
    
}

public final class UserListViewModel: UserListViewModelProtocol {
    private let usecase: UserListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) //fetchuser 즐겨찾기 여부를 위한 전체 목록
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 목록에 보여줄 리스트
    
    
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
            guard let isValidate = self?.validateQuery(query: query), isValidate else {
                self?.getFavoriteUsers(query: "")
                return
            }
            //유저가 텍스트필드에 입력을 했다면
            //처음 검색했을 때는 페이지가 0이기 때문에 페이지를 0으로 지정
            self?.fetchUser(query: query, page: 0)
            self?.getFavoriteUsers(query: query)
        }
        .disposed(by: disposeBag)
        
        input.saveFavorite.bind { user in
            //TODO: 즐겨찾기 추가
        }
        .disposed(by: disposeBag)
        
        input.deleteFavorite.bind { userID in
            //TODO: 즐겨찾기 삭제
        }
        .disposed(by: disposeBag)
        
        input.fetchMore.bind {
            //TODO: 다음페이지 검색
        }
        .disposed(by: disposeBag)
        
        
        //탭 -> api 유저 or 즐겨찾기 유저
        
        //유저리스트, 즐겨찾기 리스트
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList).map { tabButtonType, fetchUserList, favoriteUserList in
            let cellData: [UserListCellData] = []
            //TODO: cellData 생성
            return cellData
        }
        return Output(cellData: cellData, error: error.asObservable())
        
    }
    
    private func fetchUser(query: String, page: Int) {
        guard let urlAllowQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        Task {
            let result = await usecase.fetchUser(query: query, page: page)
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
    
    private func validateQuery(query: String) -> Bool {
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
}


public enum TabButtonType {
    case api
    case favorite
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
