//
//  ABI+Extension.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import BigInt

extension Data {

    func stripPadding(rawLength: UInt64, isLeftPadding: Bool, isNegative: Bool = false) -> Data? {
        guard self.count >= rawLength else { return nil }
        let paddingLength = UInt64(self.count) - rawLength
        let padding: Data
        let raw: Data

        if isLeftPadding {
            padding = Data(self[..<paddingLength])
            raw = Data(self[paddingLength...])
        } else {
            padding = Data(self[rawLength...])
            raw = Data(self[..<rawLength])
        }

        if isNegative {
            guard padding == Data(repeating: UInt8(255), count: Int(paddingLength)) else { return nil }
        } else {
            guard padding == Data(repeating: UInt8(0), count: Int(paddingLength)) else { return nil }
        }
        return raw
    }


    func setLengthLeft(_ toBytes: UInt64, isNegative:Bool = false) -> Data? {
        let existingLength = UInt64(self.count)
        if (existingLength == toBytes) {
            return Data(self)
        } else if (existingLength > toBytes) {
            return nil
        }
        var data:Data
        if (isNegative) {
            data = Data(repeating: UInt8(255), count: Int(toBytes - existingLength))
        } else {
            data = Data(repeating: UInt8(0), count: Int(toBytes - existingLength))
        }
        data.append(self)
        return data
    }

    func setLengthRight(_ toBytes: UInt64, isNegative:Bool = false) -> Data? {
        let existingLength = UInt64(self.count)
        if (existingLength == toBytes) {
            return Data(self)
        } else if (existingLength > toBytes) {
            return nil
        }
        var data:Data = Data()
        data.append(self)
        if (isNegative) {
            data.append(Data(repeating: UInt8(255), count: Int(toBytes - existingLength)))
        } else {
            data.append(Data(repeating: UInt8(0), count:Int(toBytes - existingLength)))
        }
        return data
    }


    func alignTo32Bytes() -> Data? {
        let minLength = ((count + 31) / 32)*32
        guard let paddedData = setLengthRight(UInt64(minLength)) else { return nil }
        guard let head = ABI.Encoding.lengthABIEncode(length: UInt64(count)) else { return nil }
        return head + paddedData
    }
}

extension BigInt {
    func toTwosComplement() -> Data {
        if (self.sign == BigInt.Sign.plus) {
            return self.magnitude.serialize()
        } else {
            let serializedLength = self.magnitude.serialize().count
            let MAX = BigUInt(1) << (serializedLength*8)
            let twoComplement = MAX - self.magnitude
            return twoComplement.serialize()
        }
    }

    static func fromTwosComplement(data: Data) -> BigInt {
        let isPositive = ((data[0] & 128) >> 7) == 0
        if (isPositive) {
            let magnitude = BigUInt(data)
            return BigInt(magnitude)
        } else {
            let MAX = (BigUInt(1) << (data.count*8))
            let magnitude = MAX - BigUInt(data)
            let bigint = BigInt(0) - BigInt(magnitude)
            return bigint
        }
    }
}

extension BigInt {
    func abiEncode(bits: UInt64) -> Data? {
        let isNegative = self < (BigInt(0))
        let data = self.toTwosComplement()
        let paddedLength = UInt64(ceil((Double(bits)/8.0)))
        let padded = data.setLengthLeft(paddedLength, isNegative: isNegative)
        return padded
    }
}

extension BigUInt {
    func abiEncode(bits: UInt64) -> Data? {
        let data = self.serialize()
        let paddedLength = UInt64(ceil((Double(bits)/8.0)))
        let padded = data.setLengthLeft(paddedLength)
        return padded
    }
}

extension String {
    
    func hasHexPrefix() -> Bool {
        return self.hasPrefix("0x")
    }

    func stripHexPrefixIfHas() -> String {
        if self.hasHexPrefix() {
            let indexStart = index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }
}
