//
//  BaseModel.swift
//  GiphyList
//
//  Created by 29cm on 2020/02/25.
//

import Foundation

enum StatusCode:Int {
    case success = 200
}

protocol BaseModel: Codable {
    var meta: MetaModel { get set }
}
 
struct MetaModel: Codable {
    let status: Int
    let msg, responseID: String

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}
