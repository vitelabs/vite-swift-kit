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

    public typealias Ret = Result<Quota>

    deinit {
        printLog("")
    }

    public let address: Address
    public init(address: Address, interval: TimeInterval, completion: ((Ret) -> ())? = nil) {
        self.address = address
        self.interval = interval
        self.completion = completion
    }

    public var taskId: String = ""
    public var isPolling: Bool = false
    public var interval: TimeInterval = 0
    public var completion: ((Ret) -> ())?

    public func handle(completion: @escaping (Ret) -> ()) {

        Provider.default.getPledgeQuota(address: address)
            .done { (ret) in
                completion(Result(value: ret))
            }.catch { (e) in
                completion(Result(error: e))
        }
    }
}
