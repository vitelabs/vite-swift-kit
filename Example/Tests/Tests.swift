import XCTest
import ViteWallet
import BigInt
import PromiseKit
import Vite_HDWalletKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Box.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetTestToken() {
        let address = Box.testWallet.secondAccount.address
        let amount = "10000"
        let balance = Balance(value: BigInt("1000000000000000000") * BigInt(amount)!)
        async { (c) in
            ViteNode.transaction.getPow(account: Box.genesisWallet.secondAccount, toAddress: address, tokenId: ViteWalletConst.viteToken.id, amount: balance, note: nil)
                .then { context -> Promise<AccountBlock> in
                    return ViteNode.rawTx.send.context(context)
                }.done { (ret) in
                    printLog("get \(ret.amount!.value.description)")
                }.catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    c()
            }
        }
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
}
