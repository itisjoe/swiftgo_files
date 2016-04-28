
//這是一個定義指南針四個方位的列舉
enum CompassPoint {
    case North
    case South
    case East
    case West
}

// 多個成員值可以寫在同一行 以逗號 , 隔開
// 這是一個定義太陽系八大行星的列舉
enum Planet {
    case Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}


// 這邊使用上面定義過的指南針方位的列舉

// 型別為 CompassPoint 的一個變數 值為其列舉內的 West
var directionToHead = CompassPoint.West

// 這時已經可以自動推斷這個變數的型別為 CompassPoint
// 如果要再指派新的值 可以省略列舉的型別名稱
directionToHead = .North


directionToHead = .South
switch directionToHead {
case .North:
    print("Lots of planets have a north")
case .South:
    print("Watch out for penguins") // 這行會被印出
case .East:
    print("Where the sun rises")
case .West:
    print("Where the skies are blue")
}


enum Barcode {
    case UPCA(Int, Int, Int, Int)
    case QRCode(String)
}


// 指派 Barcode 型別 成員值為 UPCA
// 相關值為 (8, 85909, 51226, 3)
var productBarcode = Barcode.UPCA(8, 85909, 51226, 3)

// 如果要修改為儲存 QR Code 條碼
productBarcode = .QRCode("ABCDEFG")

// 這時 .UPCA(8, 85909, 51226, 3) 會被 .QRCode("ABCDEFG") 所取代
// 一個變數 同一時間只能儲存一個列舉的成員值(及其相關值)


switch productBarcode {
case .UPCA(let numberSystem, let manufacturer, let product, let check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case .QRCode(let productCode):
    print("QR Code: \(productCode).") // 會印出這行
}


switch productBarcode {
case let .UPCA(numberSystem, manufacturer, product, check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .QRCode(productCode):
    print("QR Code: \(productCode).")
}


enum WeekDay: Int {
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    case Sunday = 7
}

let today = WeekDay.Friday
// 使用 rawValue 屬性來取得原始值
// 印出：5
print(today.rawValue)


// 第一個成員有設置原始值 1, 接著下去成員的原始值就是 2, 3, 4 這樣遞增下去
enum SomePlanet: Int {
    case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

let ourPlanet = SomePlanet.Earth

// 印出：3
print(ourPlanet.rawValue)


enum AnotherCompassPoint: String {
    case North, South, East, West
}

let directionPoint = AnotherCompassPoint.East

// 印出：East
print(directionPoint.rawValue)


// 一個使用原始值的列舉 原始值依序是 1,2,3,4,5,6,7,8
enum OtherPlanet: Int {
    case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

let possiblePlanet = OtherPlanet(rawValue: 7)
// possiblePlanet 型別為 OtherPlanet? 值為 OtherPlanet.Uranus


let positionToFind = 9
if let targetPlanet = OtherPlanet(rawValue: positionToFind) {
    switch targetPlanet {
    case .Earth:
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
    case Number(Int)
    
    // 兩個成員 表示為加法及乘法運算 各自有兩個[列舉的實體]相關值
    indirect case Addition(ArithmeticExpression, ArithmeticExpression)
    indirect case Multiplication(ArithmeticExpression, ArithmeticExpression)
}

// 或是你也可以把 indirect 加在 enum 前面
// 表示整個列舉都是可以遞迴的
/*
indirect enum ArithmeticExpression {
    case Number(Int)
    case Addition(ArithmeticExpression, ArithmeticExpression)
    case Multiplication(ArithmeticExpression, ArithmeticExpression)
}
*/


func evaluate(expression: ArithmeticExpression) -> Int {
    switch expression {
    case .Number(let value):
        return value
    case .Addition(let left, let right):
        return evaluate(left) + evaluate(right)
    case .Multiplication(let left, let right):
        return evaluate(left) * evaluate(right)
    }
}

// 計算 (5 + 4) * 2
let five = ArithmeticExpression.Number(5)
let four = ArithmeticExpression.Number(4)
let sum = ArithmeticExpression.Addition(five, four)
let product = ArithmeticExpression.Multiplication(sum, ArithmeticExpression.Number(2))

// 印出：18
print(evaluate(product))
