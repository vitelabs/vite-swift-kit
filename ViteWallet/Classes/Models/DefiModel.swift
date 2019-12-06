//
//  DefiModel.swift
//  Action
//
//  Created by haoshenyang on 2019/12/6.
//

import Foundation
import ObjectMapper

enum DeFiLoanStatus: Int {
    case invalid = 0
    case raising = 1
    case raised = 2
    case dueAndWaitToRefund = 3
    case dueAndrefunded = 4
    case failedAndWaitToRefund = 5
    case failedAndRefunded = 6
}

public struct DefiAccountInfo: Mappable {

    public struct BaseAccount: Mappable {

        public fileprivate(set) var available = Amount()
        public fileprivate(set) var subscribed = Amount()
        public fileprivate(set) var invested = Amount()

        public init() {  }

        public init?(map: Map) { }

        public mutating func mapping(map: Map) {
            available <- (map["available"], JSONTransformer.bigint)
            subscribed <- (map["subscribed"], JSONTransformer.bigint)
            invested <- (map["invested"], JSONTransformer.bigint)
        }
    }

    public struct LoanAccount: Mappable {
        public fileprivate(set) var available = Amount()
        public fileprivate(set) var invested = Amount()

        public init() { }

        public init?(map: Map) { }

        public mutating func mapping(map: Map) {
            available <- (map["available"], JSONTransformer.bigint)
            invested <- (map["invested"], JSONTransformer.bigint)
        }
    }

    public fileprivate(set) var token: String = ""
    public fileprivate(set) var baseAccount = BaseAccount()
    public fileprivate(set) var loanAccount = LoanAccount()

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {
        token <- map["token"]
        baseAccount <- map["baseAccount"]
        loanAccount <- map["loanAccount"]
    }
}

public struct DeFiLoanInfo: Mappable {

    fileprivate(set) var id: Int = 0
    fileprivate(set) var address: ViteAddress = ""
    fileprivate(set) var token: ViteAddress = ""
    fileprivate(set) var shareAmount: Amount = Amount()
    fileprivate(set) var shares: Int = 0
    fileprivate(set) var dayRate: Double = 0
    fileprivate(set) var subscribeDays: Int = 0
    fileprivate(set) var expireDays: Int = 0
    fileprivate(set) var expireHeight: Int = 0
    fileprivate(set) var invested: String = ""
    fileprivate(set) var status: DeFiLoanStatus = .invalid
    fileprivate(set) var created: Date = Date()
    fileprivate(set) var startTime: Date = Date()
    fileprivate(set) var updated: Date = Date()

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {
        id <- map["id"]
        address <- map["address"]
        token <- map["token"]
        shareAmount <- (map["shareAmount"], JSONTransformer.bigint)
        shares <- map["shares"]
        dayRate <- map["dayRate"]
        subscribeDays <- map["subscribeDays"]
        expireDays <- map["expireDays"]
        expireHeight <- map["expireHeight"]
        invested <- map["invested"]
        status <- map["status"]
        created <- (map["created"], JSONTransformer.timestamp)
        startTime <- (map["startTime"], JSONTransformer.timestamp)
        updated <- (map["updated"], JSONTransformer.timestamp)
    }
}

public struct DefiSubscriptionInfo: Mappable {

    fileprivate(set) var id: Int = 0
    fileprivate(set) var loanId: Int = 0
    fileprivate(set) var address: ViteAddress = ""
    fileprivate(set) var token: String = ""
    fileprivate(set) var shareAmount: Amount = Amount()
    fileprivate(set) var shares: Int = 0
    fileprivate(set) var status: DeFiLoanStatus = .invalid
    fileprivate(set) var created: Date = Date()
    fileprivate(set) var updated: Date = Date()

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {
        id <- map["id"]
        loanId <- map["loanId"]
        address <- map["address"]
        token <- map["token"]
        shareAmount <- (map["shareAmount"], JSONTransformer.bigint)
        shares <- map["shares"]
        status <- map["status"]
        created <- (map["created"], JSONTransformer.timestamp)
        updated <- (map["updated"], JSONTransformer.timestamp)
   }
}

