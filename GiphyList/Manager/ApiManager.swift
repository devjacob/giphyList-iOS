//
//  ApiManager.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/25.
//

import Foundation

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

private let timeOutLimit: Int = 6 * 1000
private let retryCount: Int = 3
private let baseDomain: String = "https://api.giphy.com/v1"
private let apiKey: String = "a6k06zgmJyeNrWAwYRZJsg6EzW45Mlag"

struct ApiRequestModel {
    var path: String!
    let method: HTTPMethod!

    init(path: String, method: HTTPMethod) {
        self.method = method
        self.path = baseDomain + path
    }
}

enum ApiManager {
    case searchList(type: SearchType, keyword: String, limit: Int = 25, offset: Int = 0)

    var requestModel: ApiRequestModel {
        switch self {
        case let .searchList(type, keyword, limit, offset):
            let encodingString = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            return ApiRequestModel(path: "/\(type.rawValue)/search?api_key=\(apiKey)&q=\(encodingString)&limit=\(limit)&offset=\(offset)", method: .get)
        }
    }

    var parameters: Parameters? {
        var parameters: Parameters = Parameters()

        switch self {
        case .searchList:
            break
        }

        return nil
    }

    var header: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

extension ApiManager {
    private func request() -> Observable<(HTTPURLResponse, Data)> {
        let requestData = RxAlamofire.requestData(requestModel.method,
                                                  requestModel.path,
                                                  parameters: parameters,
                                                  encoding: JSONEncoding.default,
                                                  headers: header).timeout(RxTimeInterval.milliseconds(timeOutLimit), scheduler: MainScheduler.instance).retry(retryCount).observeOn(MainScheduler.instance)
        #if DEBUG
            return requestData.debug()
        #else
            return requestData
        #endif
    }

    func response<T>(_ type: T.Type, onError: ((Error) -> Void)? = nil, onCompleted: ((T) -> Void)? = nil) -> Disposable where T: BaseModel {
        let disposable = request().subscribe(onNext: { _, data in
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                if model.meta.status == StatusCode.success.rawValue {
                    onCompleted?(model)
                } else {
                }
            } catch {
                onError?(error)
            }

        }, onError: { error in
            onError?(error)
        })

        return disposable
    }
}
