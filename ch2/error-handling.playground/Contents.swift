
enum VendingMachineError: ErrorType {
    case InvalidSelection
    case InsufficientFunds(coinsNeeded: Int)
    case OutOfStock
}


throw VendingMachineError.InsufficientFunds(coinsNeeded: 3)


// 先定義一個結構來表示一個商品的內容 分別為商品的價錢及數量
struct Item {
    var price: Int
    var count: Int
}

// 定義一個自動販賣機的類別
class VendingMachine {
    // 自動販賣機內的商品
    var inventory = [
        "可樂": Item(price: 25, count: 4),
        "洋芋片": Item(price: 20, count: 7),
        "巧克力": Item(price: 35, count: 11)
    ]
    
    // 目前已投入了多少錢幣 預設值為 0
    var coinsDeposited = 0
    
    // 所有判斷錯誤的邏輯都通過後 確定購買商品的動作
    func dispenseSnack(snack: String) {
        print("Dispensing \(snack)")
    }
    
    // 販售的動作 確定售出前會做些判斷
    // 這是一個拋出函式 所以函式名稱需要加上 throws
    func vend(itemNamed name: String) throws {
        // 檢查是否有這個商品 沒有的話會拋出錯誤
        guard var item = inventory[name] else {
            throw VendingMachineError.InvalidSelection
        }
        
        // 檢查這個商品是否還有剩 已賣光的話會拋出錯誤
        guard item.count > 0 else {
            throw VendingMachineError.OutOfStock
        }
        
        // 檢查目前投入的錢幣夠不夠 不夠的話會拋出錯誤
        guard item.price <= coinsDeposited else {
            // 參數為還需要補足多少錢幣 所以是商品價錢減掉已投入錢幣
            throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        // 所有判斷都通過後 才確定會售出
        coinsDeposited -= item.price
        item.count -= 1
        inventory[name] = item
        dispenseSnack(name)
    }
}


// 生成一個自動販賣機類別的實體 並設置已投入 8 個錢幣
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8

// 進行錯誤的拋出、捕獲及處理
do {
    // 呼叫拋出函式 我要購買可樂這個商品
    try vendingMachine.vend(itemNamed: "可樂")
    
    // 其他可能需要執行的程式 這邊先省略
    
    // 以下每個 catch 為各自匹配錯誤的處理
} catch VendingMachineError.InvalidSelection {
    print("無此商品")
} catch VendingMachineError.OutOfStock {
    print("商品已賣光")
} catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
    print("金額不足，還差 \(coinsNeeded) 個錢幣")
}


// 定義一個拋出函式 會返回一個 Int
func someThrowingFunction() throws -> Int {
    // 內部執行的程式
}

// 宣告一個可選型別 Int? 的常數 x
let x: Int?
do {
    // 呼叫拋出函式 會返回一個 Int
    x = try someThrowingFunction()
} catch {
    // 錯誤發生而被拋出 進而捕獲時 將其設為 nil
    x = nil
}


let y = try? someThrowingFunction()


let z = try! someThrowingFunction()


func someMethod() throws {
    // 打開一個資源 像是開啟一個檔案
    
    defer {
        // 釋放資源記憶體或清理工作
        // 像是關閉一個開啟的檔案
    }
    
    // 錯誤處理 像是檔案不存在或沒有讀取權限
    
    // 及其他要執行的程式
}
