//
//  ABIDecoding.swift
//  Pods
//
//  Created by Stone on 2018/12/11.
//

import Vite_HDWalletKit
import BigInt

extension ABI.Decoding {

    public enum DecodingError: Error {
        case conversionFailed
//        case invalidParameter
//        case invalidValue(value: Any, type: ABI.ParameterType)
    }


    static func decodeParameter(_ data: Data, type: ABI.ParameterType) throws -> ABIParameterValue {
        guard let value = type.valueType.init(from: data, type: type) else {
            throw DecodingError.conversionFailed
        }
        return value
    }
}
