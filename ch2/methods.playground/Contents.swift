
// 定義一個類別 Counter
class Counter {
    
    // 定義一個變數屬性 預設值為零
    var count = 0
    
    // 定義一個實體方法 會將變數屬性加一
    func increment() {
        count += 1
    }
    
    // 定義一個實體方法 會將變數屬性加上一個傳入的數字
    func incrementBy(amount: Int) {
        count += amount
    }
    
    // 定義一個實體方法 會將變數屬性歸零
    func reset() {
        count = 0
    }
}


// 生成一個實體 counter 其內的計數值屬性初始化為 0
let counter = Counter()

// 呼叫其內的一個實體方法 現在計數值為 1
counter.increment()

// 呼叫其內的一個實體方法, 傳入一個參數 9, 現在計數值為 10
counter.incrementBy(9)

// 呼叫其內的一個實體方法, 將計數值歸零, 現在計數值為 0
counter.reset()


//定義一個結構 Point
struct Point {
    // 兩個變數屬性 可以代表一個二維圖上的一個點
    var x = 0.0, y = 0.0
    
    // 一個變異方法 會將兩個屬性各別加上一個值
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

// 生成一個結構的實體的變數 並給初始值
var somePoint = Point(x: 1.0, y: 1.0)

// 修改其內的屬性值
somePoint.moveByX(2.0, y: 3.0)

// 現在兩個屬性已經被改變了
// 印出：x: 3.0, y: 4.0
print("x: \(somePoint.x), y: \(somePoint.y)")


// 將前面定義的結構 Point 改寫成這樣
struct AnotherPoint {
    var x = 0.0, y = 0.0
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        self = AnotherPoint(x: x + deltaX, y: y + deltaY)
    }
}


// 定義一個三態開關的列舉
enum TriStateSwitch {
    // 列舉的三個成員
    case Off, Low, High
    
    // 變異方法 會在三個成員中依序切換
    mutating func next() {
        switch self {
        case Off:
            self = Low
        case Low:
            self = High
        case High:
            self = Off
        }
    }
}

// 宣告一個列舉的變數 且目前 ovenLight 為 TriStateSwitch.Low
var ovenLight = TriStateSwitch.Low

// 每次呼叫這個變異方法 都會在三個成員中依序切換
ovenLight.next()
// 現在 ovenLight 為 .High
ovenLight.next()
// 現在 ovenLight 為 .Off


// 定義一個類別
class SomeClass {
    // 定義一個型別方法
    class func someTypeMethod() {
        print("型別方法")
    }
}

// 呼叫一個型別方法
SomeClass.someTypeMethod()
