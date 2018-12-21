//
//  FetchBalanceInfoService.swift
//  Vite
//
//  Created by Stone on 2018/9/19.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import PromiseKit

public class FetchBalanceInfoService: PollService {

    public typealias Ret = Result<[BalanceInfo]>

    deinit {
        printLog("")
    }

    public let address: Address
    public init(address: Address, interval: TimeInterval, completion: ((Result<[BalanceInfo]>) -> ())? = nil) {
        self.address = address
        self.interval = interval
        self.completion = completion
    }

    public var taskId: String = ""
    public var isPolling: Bool = false
    public var interval: TimeInterval = 0
    public var completion: ((Result<[BalanceInfo]>) -> ())?

    public func handle(completion: @escaping (Result<[BalanceInfo]>) -> ()) {

        Provider.default.getBalanceInfos(address: address)
            .done { (ret) in
                completion(Result(value: ret))
            }.catch { (e) in
                completion(Result(error: e))
        }
    }
}
