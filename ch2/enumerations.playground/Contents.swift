
//這是一個定義指南針四個方位的列舉
enum CompassPoint {
    case north
    case south
    case east
    case west
}

// 多個成員值可以寫在同一行 以逗號 , 隔開
// 這是一個定義太陽系八大行星的列舉
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}


// 這邊使用上面定義過的指南針方位的列舉

// 型別為 CompassPoint 的一個變數 值為其列舉內的 west
var directionToHead = CompassPoint.west

// 這時已經可以自動推斷這個變數的型別為 CompassPoint
// 如果要再指派新的值 可以省略列舉的型別名稱
directionToHead = .north


directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins") // 這行會被印出
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}


enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}


// 指派 Barcode 型別 成員值為 upc
// 相關值為 (8, 85909, 51226, 3)
var productBarcode = Barcode.upc(8, 85909, 51226, 3)

// 如果要修改為儲存 QR Code 條碼
productBarcode = .qrCode("ABCDEFG")

// 這時 .upc(8, 85909, 51226, 3) 會被 .qrCode("ABCDEFG") 所取代
// 一個變數 同一時間只能儲存一個列舉的成員值(及其相關值)


switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR Code: \(productCode).") // 會印出這行
}


switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR Code: \(productCode).")
}


enum WeekDay: Int {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
}

let today = WeekDay.friday
// 使用 rawValue 屬性來取得原始值
// 印出：5
print(today.rawValue)


// 第一個成員有設置原始值 1, 接著下去成員的原始值就是 2, 3, 4 這樣遞增下去
enum SomePlanet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

let ourPlanet = SomePlanet.earth

// 印出：3
print(ourPlanet.rawValue)


enum AnotherCompassPoint: String {
    case north, south, east, west
}

let directionPoint = AnotherCompassPoint.east

// 印出：east
print(directionPoint.rawValue)


// 一個使用原始值的列舉 原始值依序是 1,2,3,4,5,6,7,8
enum OtherPlanet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

let possiblePlanet = OtherPlanet(rawValue: 7)
// possiblePlanet 型別為 OtherPlanet? 值為 OtherPlanet.uranus


let positionToFind = 9
if let targetPlanet = OtherPlanet(rawValue: positionToFind) {
    switch targetPlanet {
    case .earth:
        print("We are here !")
    default:
        print("Not Safe !")
    }
} else {
    print("No planet at position \(positionToFind)")
}
// 印出：No planet at position 9


// 定義一個列舉
enum ArithmeticExpression {
    // 一個純數字成員
    case number(Int)
    
    // 兩個成員 表示為加法及乘法運算 各自有兩個[列舉的實體]相關值
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

// 或是你也可以把 indirect 加在 enum 前面
// 表示整個列舉都是可以遞迴的
/*
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
*/


func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case .number(let value):
        return value
    case .addition(let left, let right):
        return evaluate(left) + evaluate(right)
    case .multiplication(let left, let right):
        return evaluate(left) * evaluate(right)
    }
}

// 計算 (5 + 4) * 2
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

// 印出：18
print(evaluate(product))
