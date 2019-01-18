//
//  AutoGatheringService.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import PromiseKit

public class ReceiveTransactionService: PollService {
    public typealias Ret = Result<AccountBlock?>

    deinit {
        printLog("")
    }

    public let account: Wallet.Account
    public init(account: Wallet.Account, interval: TimeInterval, completion: ((Result<AccountBlock?>) -> ())? = nil) {
        self.account = account
        self.interval = interval
        self.completion = completion
    }

    public var taskId: String = ""
    public var isPolling: Bool = false
    public var interval: TimeInterval = 0
    public var completion: ((Result<AccountBlock?>) -> ())?

    public func handle(completion: @escaping (Result<AccountBlock?>) -> ()) {
        let a = account
        Provider.default.receiveLatestTransactionIfHasWithoutPow(account: a)
            .recover { (e) -> Promise<AccountBlock?> in
                if ViteError.conversion(from: e).code == ViteErrorCode.rpcNotEnoughQuota {
                    printLog("Use PoW")
                    return Provider.default.receiveLatestTransactionIfHasWithPow(account: a)
                } else {
                    return Promise(error: e)
                }
            }.done { (ret) in
                completion(Result(value: ret))
            }.catch { (e) in
                completion(Result(error: e))
        }
    }
}
