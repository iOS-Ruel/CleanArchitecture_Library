//
//  UserListViewModelTests.swift
//  CleanArchitectureTestTests
//
//  Created by Chung Wussup on 10/25/24.
//

import Foundation
import XCTest
@testable import CleanArchitectureTest
import RxSwift
import RxCocoa

final class UserListViewModelTests: XCTest {
    
    private var viewModel: UserListViewModel!
    private var mockUsecase: MockUserUsecase!
    
    private var tabButtonType: BehaviorRelay<TabButtonType>!
    private var query: BehaviorRelay<String>!
    private var saveFavorite: PublishRelay<UserListItem>!
    private var deleteFavorite: PublishRelay<Int>!
    private var fetchMore: PublishRelay<Void>!
    
    private var input: UserListViewModel.Input!
    
    private var disposedBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockUsecase = MockUserUsecase()
        viewModel = UserListViewModel(usecase: mockUsecase)
        tabButtonType = BehaviorRelay<TabButtonType>(value: .api)
        query = BehaviorRelay<String>(value: "")
        saveFavorite = PublishRelay<UserListItem>()
        deleteFavorite = PublishRelay<Int>()
        fetchMore = PublishRelay<Void>()
        disposedBag = DisposeBag()
        
        input = UserListViewModel.Input(tabButtonType: tabButtonType.asObservable(),
                                        query: query.asObservable(),
                                        saveFavorite: saveFavorite.asObservable(),
                                        deleteFavorite: deleteFavorite.asObservable(),
                                        fetchMore: fetchMore.asObservable())
        
        
    }
    
    
    
    //쿼리 결과 cell data로 잘 나오는지
    func testFetchUserCellData() {
        let userList: [UserListItem] = [
            UserListItem(id: 1, login: "Ruel1", imageURL: ""),
            UserListItem(id: 2, login: "Ruel2", imageURL: ""),
            UserListItem(id: 3, login: "Ruel3", imageURL: ""),
            UserListItem(id: 4, login: "Ruel4", imageURL: ""),
            UserListItem(id: 5, login: "Ruel5", imageURL: ""),
            UserListItem(id: 6, login: "Ruel6", imageURL: "")
        ]
        
        
        mockUsecase.fetchUserResult = .success(UserListResult(totalCount: 6, incompleteResults: false, items: userList))
        
        let output = viewModel.transform(input: input)
        query.accept("user")
        
        
        
        var result: [UserListCellData] = []
        output.cellData.bind { cellData in
            result = cellData
        }.disposed(by: disposedBag)
        
        if case .user(let userItem, _) = result.first {
            XCTAssertEqual(userItem.login, "user1")
        } else {
            XCTFail("Cell Data user cell 아님")
        }
    }
    
    //즐겨찾기 결과 cell data로 잘나오는지 테스트
    func testFavoriteUserCellData() {
        let users = [
            UserListItem(id: 1, login: "Alice", imageURL: ""),
            UserListItem(id: 2, login: "Bob", imageURL: ""),
            UserListItem(id: 3, login: "Charlie", imageURL: ""),
        ]
        
        mockUsecase.favoriteUserResult = .success(users)
        let output = viewModel.transform(input: input)
        tabButtonType.accept(.favorite)
        
        
        var result: [UserListCellData] = []
        output.cellData.bind { cellData in
            result = cellData
        }
        .disposed(by: disposedBag)
        
        if case let .header(key) = result.first {
            XCTAssertEqual(key, "A")
        } else {
            XCTFail("Cell data not header cell ")
        }
        
        if case .user(let userItem, let isFavorite) = result[1] {
            XCTAssertEqual(userItem.login, "Alice")
            XCTAssertTrue(isFavorite)
        } else {
            XCTFail("Cell data not user cell")
        }
         
    }
    
    
    override func tearDown() {
        viewModel = nil
        mockUsecase = nil
        disposedBag = nil
        super.tearDown()
    }
}
