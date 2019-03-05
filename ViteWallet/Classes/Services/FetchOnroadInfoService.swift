//
//  FetchOnroadInfoService.swift
//  ViteWallet
//
//  Created by Stone on 2019/3/1.
//

import UIKit
import Foundation
import PromiseKit

public class FetchOnroadInfoService: PollService {

    public typealias Ret = Result<[OnroadInfo]>

    deinit {
        printLog("")
    }

    public let address: Address
    public init(address: Address, interval: TimeInterval, completion: ((Result<[OnroadInfo]>) -> ())? = nil) {
        self.address = address
        self.interval = interval
        self.completion = completion
    }

    public var taskId: String = ""
    public var isPolling: Bool = false
    public var interval: TimeInterval = 0
    public var completion: ((Result<[OnroadInfo]>) -> ())?

    public func handle(completion: @escaping (Result<[OnroadInfo]>) -> ()) {

        Provider.default.getOnroadInfos(address: address)
            .done { (ret) in
                completion(Result(value: ret))
            }.catch { (e) in
                completion(Result(error: e))
        }
    }
}
