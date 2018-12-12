//
//  FetchPledgeQuotaService.swift
//  Vite
//
//  Created by Stone on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import PromiseKit

public class FetchPledgeQuotaService: PollService {

    public typealias Ret = Result<(UInt64, UInt64)>

    deinit {
        printLog("")
    }

    public let address: Address
    public init(address: Address, completion: ((Result<(UInt64, UInt64)>) -> ())? = nil) {
        self.address = address
        self.completion = completion
    }

    public var registerCount: Int = 0
    public var isPolling: Bool = false
    public var interval: TimeInterval = 0
    public var completion: ((Result<(UInt64, UInt64)>) -> ())?

    public func handle(completion: @escaping (Result<(UInt64, UInt64)>) -> ()) {

        Provider.default.getPledgeQuota(address: address)
            .done { (ret) in
                completion(Result(value: ret))
            }.catch { (e) in
                completion(Result(error: e))
        }
    }
}
