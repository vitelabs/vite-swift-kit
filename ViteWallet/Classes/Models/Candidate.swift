//
//  Candidate.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

public class Candidate: Mappable {
    public typealias VoteNum = Amount

    required public init?(map: Map) {

    }

    public fileprivate(set) var name: String = ""
    public fileprivate(set) var nodeAddr: ViteAddress = ""
    public fileprivate(set) var voteNum: VoteNum = VoteNum()
    public fileprivate(set) var rank: Int = 0

    public func mapping(map: Map) {
        name <- map["name"]
        nodeAddr <- map["nodeAddr"]
        voteNum <- (map["voteNum"], JSONTransformer.balance)
    }

    public func updateRank(_ rank: Int) {
        self.rank = rank
    }
}
