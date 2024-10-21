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
    private let fetchUserList = BehaviorSubject<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorSubject<[UserListItem]>(value: []) //fetchuser 즐겨찾기 여부를 위한 전체 목록
    private let favoriteUserList = BehaviorSubject<[UserListItem]>(value: []) // 목록에 보여줄 리스트
    
    
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
        input.query.bind { query in
            //TODO: 상황에 맞춰 user fetch or Get favorite users
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
}


public enum TabButtonType {
    case api
    case favorite
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
