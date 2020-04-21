import XCTest
import BigInt
import PromiseKit
import Vite_HDWalletKit
@testable import ViteWallet

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Box.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWallet() {
        let uuid = "1"
        let name = "name"
        let mnemonic = "soccer turn style rifle shy south toilet sphere boost arrange client provide betray pond orphan circle paddle job basic mango coil kingdom excite level"
        let language = MnemonicCodeBook.english
        let encryptedKey = "123456"

        let wallet = Wallet(uuid: uuid, name: name, mnemonic: mnemonic, language: language, encryptedKey: encryptedKey)
        let jsonString = wallet.toJSONString() ?? ""

        guard let unlockWallet = Wallet(JSONString: jsonString) else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(unlockWallet.toJSONString(), wallet.toJSONString())

        for index in 0..<10 {
            do {
                let account = try wallet.account(at: index, encryptedKey: encryptedKey)
                printLog("\(index): \(account.address) \(account.sign(hash: "1234".hex2Bytes).toHexString())")
            } catch {
                XCTAssert(false)
            }
        }

        for index in 0..<10 {
            do {
                let account = try unlockWallet.account(at: index, encryptedKey: encryptedKey)
                printLog("\(index): \(account.address) \(account.sign(hash: "1234".hex2Bytes).toHexString())")
            } catch {
                XCTAssert(false)
            }
        }
    }

    func testAccountBlock() {
        let jsonString = "{\"accountAddress\":\"vite_ab24ef68b84e642c0ddca06beec81c9acb1977bbd7da27a87a\",\"amount\":\"11000000000000000000\",\"blockType\":2,\"data\":\"5L2g5aW9\",\"hash\":\"65039ec9ea031bf69a6a65f51f4a923716ce4900c5cf9989056aa94a51189af1\",\"height\":\"30\",\"prevHash\":\"20a75cc0baf4d0b6a3eef4f486825f9f00dba00ed1b4af0aad91a48895165186\",\"publicKey\":\"WHZinxslscE+WaIqrUjGu2scOvorgD4Q+DQOOcDBv4M=\",\"signature\":\"rvELIvlDbWYegiK1puvxliqG5UYFdTXvP55FM/o+lYyNWnE6De1rB9sFgVl3g5+5K+HI8kkQHRIdu7frW6x+DA==\",\"timestamp\":1555405235,\"toAddress\":\"vite_ab24ef68b84e642c0ddca06beec81c9acb1977bbd7da27a87a\",\"tokenId\":\"tti_5649544520544f4b454e6e40\"}"

        guard let accountBlock = AccountBlock(JSONString: jsonString) else {
            XCTAssert(false)
            return
        }

        let (h, s) = AccountBlock.sign(accountBlock: accountBlock, secretKeyHexString: "", publicKeyHexString: "")
        print(h)
        print(s)
    }

    func testPrintAllBuildIn() {
        for abi in ABI.BuildIn.allCases {
            printLog("\(abi.toAddress).\(abi.encodedFunctionSignature.toHexString())  \(abi)")
        }
        print("")
    }

    func testABI() {
        let abi = "{\"type\":\"function\",\"name\":\"CreateNewInviter\",\"inputs\":[]}"
        let functionSignature = try! ABI.Encoding.encodeFunctionSignature(abiString: abi).toHexString()
        print(functionSignature)
        print("")
    }

    func testABIValue() {
        let abi = ABI.BuildIn.dexPlaceOrder.rawValue
        let data = Data(base64Encoded: "BFT17wAAAAAAAAAAAAAAAAAAAAAAAAAAAABWSVRFWCBDT0lOAAAAAAAAAAAAAAAAAAAAAAAAAAAAADIoYrP47a47ArEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABfXhAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADMS4yAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")!
        do {
            let values = try ABI.Decoding.decodeParameters(data, abiString: abi)
            for value in values {
                print(value.toString())
            }
            print("")
        } catch {
            print(error)
            XCTAssert(false, error.localizedDescription)
        }
    }
}
