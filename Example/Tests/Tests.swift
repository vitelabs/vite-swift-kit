import XCTest
import ViteWallet
import Vite_HDWalletKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        LogConfig.instance.isEnable = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }


    func testWallet() {
        let uuid = "1"
        let name = "name"
        let mnemonic = "soccer turn style rifle shy south toilet sphere boost arrange client provide betray pond orphan circle paddle job basic mango coil kingdom excite level"
        let language = MnemonicCodeBook.english
        let encryptedKey = "123456"

        let wallet = Wallet(uuid: uuid, name: name, mnemonic: mnemonic, language: language, encryptedKey: encryptedKey)
        let jsonString = wallet.toCipherJSONString()

        guard let unlockWallet = Wallet(JSONString: jsonString) else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(unlockWallet.toCipherJSONString(), wallet.toCipherJSONString())

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
}
