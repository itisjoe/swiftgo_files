
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
}


// 直接對型別 Double 的值取得屬性
let aMarathon = 42.km + 195.m

// 印出：馬拉松的距離全長為 42195.0 公尺
print("馬拉松的距離全長為 \(aMarathon) 公尺")


// 新增一個實體方法 有一個參數 型別為 () -> Void 的閉包
// 這個新增的實體方法會執行這個閉包
// 執行次數為：這個整數本身代表數字
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

// 會依序印出 3 次：Hello!
// 這邊使用 尾隨閉包 簡化語法
3.repetitions {
    print("Hello!")
}


// 為內建的 Int 型別新增一個變異實體方法：取得這個整數的平方數
extension Int {
    mutating func square() {
        self = self * self
    }
}

// 先宣告一個整數
var oneInt = 5

// 接著呼叫方法 這裡會得到 25
oneInt.square()


// 定義一個結構 會有一個自動生成的成員逐一建構器
struct GameCharacter {
    var hp = 100,mp = 100, name = ""
}

// 為結構 GameCharacter 定義一個建構器的擴展
extension GameCharacter {
    init(name:String) {
        self.name = name
        print("新名字為 \(name)")
    }
}

// 使用擴展後定義的建構器
let oneChar = GameCharacter(name: "弓箭手")

// 原本的成員逐一建構器仍然可以使用
let twoChar = GameCharacter(hp: 200, mp: 50, name: "戰士")


// 定義下標 取得一個整數從個位數算起第幾個數字
// 索引值：0 為取得個位數, 1 為取得十位數, 2為取得百位數 依此類推
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

// 接著就可以得到每一個位數的數字
// 得到個位數：9
123456789[0]

// 得到千位數：6
123456789[3]


// 為內建的 Int 型別內新增一個列舉的擴展
// 用來表示這個整數是負數、零還是正數
extension Int {
    enum Kind {
        case Negative, Zero, Positive
    }
    
    // 另外還新增一個計算屬性 用來返回列舉情況
    var kind: Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
}

// 依序會印出：Positive、Negative、Zero
for number in [3, -12, 0] {
    print(number.kind)
}
