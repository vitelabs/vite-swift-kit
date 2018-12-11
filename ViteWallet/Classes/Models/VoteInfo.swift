//
//  VoteInfo.swift
//  Vite
//
//  Created by Water on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

public struct VoteInfo: Mappable {

    public enum NodeStatus: Int {
        case valid = 1
        case invalid = 2
    }

    public fileprivate(set) var nodeName: String?
    public fileprivate(set) var nodeStatus: NodeStatus?
    public fileprivate(set) var balance: Balance?

    public init(_ nodeName: String? = "", _ nodeStatus: NodeStatus? = .valid, _ balance: Balance? = nil) {
        self.nodeName = nodeName
        self.nodeStatus = nodeStatus
        self.balance = balance
    }

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {
        nodeName <- (map["nodeName"])
        nodeStatus <- (map["nodeStatus"])
        balance <- (map["balance"], JSONTransformer.balance)
    }
}
