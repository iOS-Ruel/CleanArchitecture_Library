//
//  UserSession.swift
//  CleanArchitectureTest
//
//  Created by Chung Wussup on 10/15/24.
//

import Foundation
import Alamofire

//세션을 통해 필요한 리퀘스트 작업을 수행할 것임
//네트워크 매니저를 통해서 특정 api를 호출하고 네트워크 호출에 필요한 공통적인 에러처리, 동작값 처리에 대한
//공통적 처리를 위해 매니저처리를 할것


public protocol SessionProtocol {
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 headers: HTTPHeaders?) -> DataRequest
}

//Session
class UserSession {
    private var session: Session
    
    init(session: Session) {
        let config = URLSessionConfiguration.default
        //캐시가 있으면 캐시 리턴 아니면 api 호출
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    //기존 Alamofire에서 제공하는데로 사용해도 되지만 아래와 같이 직접 구현해서 사용하는 이유는
    //네트워크 호출에 관련한 테스트 코드를 짜야하는데 진짜 세션을 담아서 요청하면 진짜 API를 호출하게 됨으로
    //Mock 세션을 추상화하여 사용할 수 있기 때문
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, headers: headers)
    }
}
