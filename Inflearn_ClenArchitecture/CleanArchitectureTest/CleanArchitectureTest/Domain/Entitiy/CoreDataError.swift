//
//  CoreDataError.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/14/24.
//

import Foundation

public enum CoreDataError: Error {
    case entityNotFount(String)
    case saveError(String)
    case readError(String)
    case deleteErrorr(String)
    
    public var description: String {
        switch self {
        case .entityNotFount(let objectName):
            "에러를 찾을 수 없습니다 \(objectName)"
        case .saveError(let message):
            "객체 저장 에러 \(message)"
        case .readError(let message):
            "객체 조회 에러 \(message)"
        case .deleteErrorr(let message):
            "객체 삭제 에러 \(message)"
        }
    }
}
