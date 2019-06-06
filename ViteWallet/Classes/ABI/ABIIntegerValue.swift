//
//  ABIIntegerValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import Vite_HDWalletKit
import BigInt

//public protocol ABIIntegerValue: ABIParameterValue {
//    func toBigUInt() -> BigUInt?
//    func toBigInt() -> BigInt?
//}

extension String {
    public func toBigUInt() -> BigUInt? {
        return BigUInt(self, radix: 10)
    }

    public func toBigInt() -> BigInt? {
        return BigInt(self, radix: 10)
    }
}

extension BigUInt {
    public func toBigUInt() -> BigUInt? {
        return self
    }

    public func toBigInt() -> BigInt? {
        return BigInt(self)
    }
}

extension BigInt {
    public func toBigUInt() -> BigUInt? {
        switch sign {
        case .minus:
            return nil
        case .plus:
            return magnitude
        }
    }

    public func toBigInt() -> BigInt? {
        return self
    }
}

extension SignedInteger {
    public func toBigUInt() -> BigUInt? {
        return BigUInt(self)
    }

    public func toBigInt() -> BigInt? {
        return BigInt(self)
    }
}

extension UnsignedInteger {
    public func toBigUInt() -> BigUInt? {
        return BigUInt(self)
    }

    public func toBigInt() -> BigInt? {
        return BigInt(self)
    }
}
