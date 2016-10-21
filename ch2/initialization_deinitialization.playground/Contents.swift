
// 定義一個類別 SomeClass 並在建構器中指派初始值給屬性 number
class SomeClass {
    let number: Int
    
    init() {
        number = 12
    }
}


class SomeClass2 {
    let number: Int = 20
    let anotherNumber: Int
    
    init() {
        anotherNumber = 12
    }
}


class OneQuestion {
    var question: String
    
    // 可選型別 即可在建構過程時不用指派值
    var answer: String?
    
    init() {
        // 僅指派一個型別為 String 的屬性
        question = "問題的題目"
    }
}

let someQuestion = OneQuestion()
// 這時才將 anser 指派值
someQuestion.answer = "答案隨後跟上"


class SomeClass3 {
    let numbers: [Int] = {
        var temporaryNumbers = [Int]()
        var isBlack = false
        for i in 1...10 {
            temporaryNumbers.append(i)
        }
        return temporaryNumbers
    }()
}


struct SimpleMath {
    var number: Double
    init(huge n: Double) {
        number = n * 100
    }
    init(tiny n: Double) {
        number = n / 10
    }
}

let oneSimpleMath = SimpleMath(huge: 30.0)
// 印出 3000.0
print(oneSimpleMath.number)

let anotherSimpleMath = SimpleMath(tiny: 10.0)
// 印出 1.0
print(anotherSimpleMath.number)


// 定義一個結構 有兩個建構器
struct Color {
    let red, green, blue: Double
    
    // 這個建構器有寫 參數標籤 跟 參數名稱
    init(red r: Double, green g : Double, blue b: Double) {
        self.red   = r
        self.green = g
        self.blue  = b
    }
    
    // 這個建構器則是合併成一個參數名稱
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}

var oneColor = Color(red: 0.9, green: 0.5, blue: 0.5)
var anotherColor = Color(white: 1.0)


struct SomeNumbers {
    let number: Int
    // 使用下底線 _ 表示要省略參數標籤
    init(_ n: Int) {
        number = n
    }
}

// 生成一個實體時 參數前就不需要有參數標籤
var oneNumbers = SomeNumbers(9)


struct CharacterStats {
    var hp = 0.0
    var mp = 0.0
}

let someoneStats = CharacterStats(hp: 120, mp: 100)


// 定義兩個示範需要用到的結構
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}

// 定義一個方形的結構 Rect
struct Rect {
    // 使用上面兩個定義的結構來儲存這個方形的原點及尺寸
    var origin = Point()
    var size = Size()
    
    // 三個建構器
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}


let basicRect = Rect()
// basicRect 內的屬性的值分別為
// origin 為 (0.0, 0.0)
// size 為 (0.0, 0.0)


let originRect = Rect(origin: Point(x: 2.0, y: 2.0),
                      size: Size(width: 5.0, height: 5.0))
// originRect 內的屬性的值分別為
// origin 為 (2.0, 2.0)
// size 為 (5.0, 5.0)


let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
// centerRect 內的屬性的值分別為
// origin 為 (2.5, 2.5)
// size 為 (3.0, 3.0)


class GameCharacter {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[未命名]")
    }
}


// 使用指定建構器 生成實體後的屬性 name 為: Kevin
let oneChar = GameCharacter(name:"Kevin")

// 使用便利建構器 生成實體後的屬性 name 為: [未命名]
let anotherChar = GameCharacter()


class Archer: GameCharacter {
    var attackRange: Double
    init(name: String, attackRange: Double) {
        self.attackRange = attackRange
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, attackRange: 1)
    }
}


// 繼承自父類別的建構器
let oneArcher = Archer()

// 覆寫自父類別並重新定義的建構器
let secondArcher = Archer(name: "Joe")

// 類別本身自己定義的建構器
let anotherArcher = Archer(name: "Adam", attackRange: 2.4)


class Hunter: Archer {
    var hp = 100
    var description: String {
        return "\(name) ,基礎血量為 \(hp)"
    }
}


let oneHunter = Hunter()
let secondHunter = Hunter(name: "Black")
let anotherHunter = Hunter(name: "Dwight", attackRange: 3)


// 定義一個結構 Animal 當傳入的參數為空字串時 建構過程會失敗
struct Animal {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

// 傳入 Lion 當參數
var oneAnimal = Animal(name: "Lion")
if let one = oneAnimal {
    print("動物的名字為 \(one.name)")
}

// 傳入一個空字串當參數 (請注意 空字串與 nil 完全不一樣)
var anotherAnimal = Animal(name: "")
if anotherAnimal == nil {
    print("沒有傳入名字 所以建構過程中失敗了")
}


enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}


let oneUnit = TemperatureUnit(symbol: "F")
if oneUnit != nil {
    print("這是一個溫度單位")
}

let anotherUnit = TemperatureUnit(symbol: "X")
if anotherUnit == nil {
    print("這不是一個溫度單位")
}


enum AnotherTemperatureUnit: Character {
    case kelvin = "K", celsius = "C", fahrenheit = "F"
}

// 可以匹配到成員的原始值 所以建構成功
let oneUnit2 = AnotherTemperatureUnit(rawValue: "F")

// 無法匹配到成員的原始值 所以建構失敗
let anotherUnit2 = AnotherTemperatureUnit(rawValue: "X")


// 定義一個類別 AnotherGameCharacter 有一個可失敗建構器 當名稱參數為空字串時會建構失敗
class AnotherGameCharacter {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

// 定義一個繼承自 AnotherGameCharacter 的類別 AnotherArcher
// 有一個可失敗建構器 當攻速參數小於 1 時會建構失敗
class AnotherArcher: AnotherGameCharacter {
    let attackSpeed: Int
    init?(name: String, attackSpeed: Int) {
        if attackSpeed < 1 { return nil }
        self.attackSpeed = attackSpeed
        super.init(name: name)
    }
}

// 作為參數的名稱跟攻速都符合規則 建構成功 會生成一個 AnotherArcher 的實體
let oneArcher2 = AnotherArcher(name: "Jim", attackSpeed: 2)

// 作為參數的攻速為 0 會建構失敗
// 在 AnotherArcher 中即返回 nil 不會再向上傳遞至父類別 AnotherGameCharacter
let anotherArcher2 = AnotherArcher(name: "Zack", attackSpeed: 0)

// 作為參數的名稱為空字串 會建構失敗
// 建構過程一直到父類別 AnotherGameCharacter 的建構器 才會失敗
let finalArcher = AnotherArcher(name: "", attackSpeed: 1)


//定義一個類別 Document
class Document {
    // 可選型別的屬性
    var name: String?
    // 使用這個建構器 會生成一個屬性 name 為 nil 的實體
    init() {}
    // 使用這個建構器 會生成一個屬性 name 不為空字串的實體
    // 或是建構失敗 返回 nil
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}

// 定義一個繼承自 Document 的類別 AutomaticallyNamedDocument
class AutomaticallyNamedDocument: Document {
    // 覆寫父類別的建構器 會指派值給屬性
    override init() {
        super.init()
        self.name = "[未命名]"
    }
    // 覆寫父類別的可失敗建構器 成為 非可失敗建構器
    // 可以看到他將條件修改成為 不會有失敗的狀況發生
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[未命名]"
        } else {
            self.name = name
        }
    }
}


// 定義一個繼承自 Document 的類別 UntitledDocument
class UntitledDocument: Document {
    // 覆寫一個父類別的可失敗建構器 並向上委任到這個建構器
    override init() {
        // 這時必須強制解析這個父類別的建構器
        // 表示不會有失敗的狀況
        super.init(name: "[未命名]")!
    }
}


class SomeClass4 {
    required init() {
        // 建構器執行程式的實作
    }
}


class SomeSubclass: SomeClass4 {
    required init() {
        // 必要建構器執行程式的實作
    }
}
