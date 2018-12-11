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

    deinit {
        printLog("")
    }

    public let account: Wallet.Account
    public init(account: Wallet.Account) {
        self.account = account
    }

    public var registerCount: Int = 0
    public var isPolling: Bool = false
    public var interval: TimeInterval = 0

    public func handle(completion: @escaping () -> ()) {
        let a = account
        Provider.default.receiveLatestTransactionIfHasWithoutPow(account: a)
            .recover { (e) -> Promise<Void> in
                if ViteError.conversion(from: e).code == ViteErrorCode.rpcNotEnoughQuota {
                    printLog("Use PoW")
                    let d = ViteWalletConst.DefaultDifficulty.receive.value
                    return Provider.default.receiveLatestTransactionIfHasWithPow(account: a, difficulty: d)
                } else {
                    return Promise(error: e)
                }
            }.done { (ret) in
                printLog(ret)
            }.catch { (e) in
                printLog(e)
            }.finally {
                completion()
        }
    }
}
