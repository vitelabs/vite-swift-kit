//
//  ViteErrorCode.swift
//  Vite
//
//  Created by Stone on 2018/11/20.
//  Copyright © 2018 vite labs. All rights reserved.
//

import Foundation

public struct ViteErrorCode {

    public let type: CodeType
    public let id: Int

    public init(type: CodeType, id: Int) {
        self.type = type
        self.id = id
    }

    public enum CodeType: String {

        // session task error
        case st_con         // connectionError
        case st_req         // requestError
        case st_res         // responseError

        // rpc error, in st_res error
        case rpc            // responseError
        case rpc_res_nf     // responseNotFound
        case rpc_ro_p       // resultObjectParseError
        case rpc_eo_p       // errorObjectParseError
        case rpc_u_v        // unsupportedVersion
        case rpc_u_t        // unexpectedTypeObject
        case rpc_m_re       // missingBothResultAndError
        case rpc_nar        // nonArrayResponse

        // json error
        case json_t_e       // json type error
        // cancel error
        case cancel         // cancel operation

        // custom
        case custom
    }

    // rpc error
    public static let rpcNotEnoughBalance = ViteErrorCode(type: .rpc, id: -35001)
    public static let rpcNotEnoughQuota = ViteErrorCode(type: .rpc, id: -35002)
    public static let rpcIdConflict = ViteErrorCode(type: .rpc, id: -35003)
    public static let rpcContractDataIllegal = ViteErrorCode(type: .rpc, id: -35004)
    public static let rpcRefrenceSameSnapshootBlock = ViteErrorCode(type: .rpc, id: -35005)
    public static let rpcContractMethodNotExist = ViteErrorCode(type: .rpc, id: -35006)
    public static let rpcNoTransactionBefore = ViteErrorCode(type: .rpc, id: -36001)
    public static let rpcHashVerifyFailure = ViteErrorCode(type: .rpc, id: -36002)
    public static let rpcSignatureVerifyFailure = ViteErrorCode(type: .rpc, id: -36003)
    public static let rpcPowNonceVerifyFailure = ViteErrorCode(type: .rpc, id: -36004)
    public static let rpcRefrenceSnapshootBlockIllegal = ViteErrorCode(type: .rpc, id: -36005)
    public static let rpcRefrencePrevBlockFailed = ViteErrorCode(type: .rpc, id: -36006)
    public static let rpcRefrenceBlockIsPending = ViteErrorCode(type: .rpc, id: -36007)

    public static let JSONType = ViteErrorCode(type: .json_t_e, id: 0)
    public static let cancel = ViteErrorCode(type: .cancel, id: 0)
}

extension ViteError {
    public static var JSONTypeError: ViteError {
        return ViteError(code: ViteErrorCode.JSONType, rawMessage: "JSON Type Error", rawError: nil)
    }

    public static var cancelError: ViteError {
        return ViteError(code: ViteErrorCode.cancel, rawMessage: "Cancel Operation", rawError: nil)
    }
}

extension ViteErrorCode: Hashable {
    public static func == (lhs: ViteErrorCode, rhs: ViteErrorCode) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }

    public var hashValue: Int {
        return toString().hashValue
    }
}

extension ViteErrorCode: CustomStringConvertible, CustomDebugStringConvertible {

    public func toString() -> String {
        return type.rawValue.uppercased().replacingOccurrences(of: "_", with: ".") + "." + String(id)
    }

    public var description: String {
        return toString()
    }

    public var debugDescription: String {
        return toString()
    }
}
