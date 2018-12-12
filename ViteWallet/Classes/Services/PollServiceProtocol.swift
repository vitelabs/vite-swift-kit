//
//  PollServiceProtocol.swift
//  APIKit
//
//  Created by Stone on 2018/12/11.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)

    public init(value: T) {
        self = .success(value)
    }

    public init(error: Error) {
        self = .failure(error)
    }
}

public protocol PollService: class {

    associatedtype Ret

    var registerCount: Int { get set }
    var isPolling: Bool { get set }
    var interval: TimeInterval { get set }
    var completion: ((Ret) -> ())? { get set }

    func handle(completion: @escaping (Ret) -> ())
}

extension PollService {

    public func register(interval: TimeInterval) {
        printLog("interval: \(interval), registerCount: \(registerCount + 1)")
        DispatchQueue.main.async {
            self.interval = interval
            self.registerCount += 1
            self.startPoll()
        }

    }

    public func unregister() {
        printLog(", registerCount: \(max(registerCount - 1, 0))")
        DispatchQueue.main.async {
            self.registerCount = max(self.registerCount - 1, 0)
            if self.registerCount == 0 {
                self.stopPoll()
            }
        }
    }

    private func run() {
        printLog("start")
        handle(completion: { [weak self] r in
            printLog("end")
            guard let `self` = self else { return }
            if let c = self.completion { c(r) }
            guard self.isPolling else { return }
            printLog("will run again after \(self.interval)")
            DispatchQueue.main.asyncAfter(deadline: .now() + self.interval, execute: self.run)
        })
    }

    private func startPoll() {
        printLog("")
        DispatchQueue.main.async {
            guard self.isPolling == false else { return }
            self.isPolling = true
            self.run()
        }
    }

    private func stopPoll() {
        printLog("")
        DispatchQueue.main.async {
            self.isPolling = false
        }
    }
}
