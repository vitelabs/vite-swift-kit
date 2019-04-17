//
//  GetCreateContractToAddressRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetCreateContractToAddressRequest: JSONRPCKit.Request {
    public typealias Response = ViteAddress

    let address: ViteAddress
    let height: UInt64
    let prevHash: String
    let snapshotHash: String

    public var method: String {
        return "contract_getCreateContractToAddress"
    }

    public var parameters: Any? {
        return [address, height, prevHash, snapshotHash]
    }

    public init(address: ViteAddress, height: UInt64, prevHash: String, snapshotHash: String) {
        self.address = address
        self.height = height
        self.prevHash = prevHash
        self.snapshotHash = snapshotHash
    }

    public func response(from resultObject: Any) throws -> Response {

        guard let response = resultObject as? ViteAddress else {
            throw ViteError.JSONTypeError
        }

        let address = response

        guard address.isViteAddress else {
            throw ViteError.JSONTypeError
        }

        return address
    }
}
