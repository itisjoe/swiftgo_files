
// 定義一個協定 包含一個唯讀的字串屬性
protocol FullyNamed {
    var fullName: String { get }
}

// 定義一個類別 遵循協定 FullyNamed
struct Person: FullyNamed {
    // 因為遵循協定 FullyNamed
    // fullName 這個屬性一定要定義才行 否則會報錯誤
    var fullName: String
}

let joe = Person(fullName: "Joe Black")
print("名字為 \(joe.fullName)")
// 印出：名字為 Joe Black


protocol SomeProtocol {
    // 定義一個實體方法 返回一個整數
    func instanceMethod() -> Int
}

// 定義一個類別 遵循協定 SomeProtocol
class MyClass: SomeProtocol {
    // 因為遵循協定 SomeProtocol
    // instanceMethod() 這個方法一定要定義才行 否則會報錯誤
    func instanceMethod() -> Int {
        return 300
    }
}


// 定義一個包含變異方法的協定
protocol Togglable {
    // 只需標明方法名稱 不用實作
    mutating func toggle()
}

// 定義一個開關切換的列舉
enum OnOffSwitch: Togglable {
    case off, on
    
    // 實作這個遵循協定後需要定義的變異方法
    mutating func toggle() {
        // 會在 On, Off 兩者中切換
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch 現在切換為 .on


protocol OtherProtocol {
    init(someParameter: Int)
}


class OtherClass: OtherProtocol {
    required init(someParameter: Int) {
        // 建構器的內容
    }
}


protocol AnontherProtocol {
    init()
}

// 定義一個類別
class AnontherSuperClass {
    init() {
        // 建構器的內容
    }
}

// 定義一個繼承 AnontherSuperClass 的類別 同時還遵循了協定 AnontherProtocol
class SomeSubClass: AnontherSuperClass, AnontherProtocol {
    // 必須同時加上 required 和 override
    required override init() {
        // 建構器的內容
    }
}


// 定義一個協定
protocol SomeOtherProtocol {
    func method() -> Int
}

// 定義一個類別 遵循協定 SomeOtherProtocol
class OneClass: SomeOtherProtocol {
    func method() -> Int {
        return 5566
    }
}

// 定義另一個類別 有一個型別為 SomeOtherProtocol 的常數
class AnotherClass {
    // 常數屬性 型別為一個協定：SomeOtherProtocol
    let oneMember: SomeOtherProtocol
    
    // 建構器有個參數 member 型別為 SomeOtherProtocol
    init(member: SomeOtherProtocol) {
        self.oneMember = member
    }
    
}

// 先宣告一個類別 OneClass 的實體
let oneInstance = OneClass();

// 任何遵循 協定：SomeOtherProtocol 的實體 都可以被當做 協定：SomeOtherProtocol 型別
// 所以上面宣告的 oneInstance 可以被當做參數傳入
let twoInstance = AnotherClass(member: oneInstance)

// 印出：5566
print(twoInstance.oneMember.method())


// 定義一個協定 遵循這個協定的類別都要實作 attack() 方法
protocol GameCharacterProtocol {
    func attack()
}

// 定義一個委任協定 將一些其他功能委任給別的實體實作
protocol GameCharacterProtocolDelegate {
    // 這邊是定義一個在攻擊後需要做的整理工作
    func didAttackDelegate()
}

// 定義一個類別 表示一個遊戲角色
class GameCharacter: GameCharacterProtocol {
    // 首先定義一個變數屬性 delegate 型別為 GameCharacterProtocolDelegate
    // 定義為可選型別 會先初始化為 nil 之後再將其設置為負責其他動作的另一個型別的實體
    var delegate: GameCharacterProtocolDelegate?
    
    // 因為遵循協定：GameCharacterProtocol
    // 所以需要實作 attack() 這個方法
    func attack() {
        print("攻擊！")
        
        // 最後將其他動作委任給另一個型別的實體實作
        delegate?.didAttackDelegate()
    }
}

// 定義一個類別 遵循協定：GameCharacterProtocolDelegate
// 這個類別生成的實體會被委任其他動作
class GameCharacterDelegate: GameCharacterProtocolDelegate {
    // 必須實作這個方法
    func didAttackDelegate() {
        print("攻擊後的整理工作")
    }
}

// 首先生成一個遊戲角色的實體
let oneChar = GameCharacter()

// 接著生成一個委任類別的實體 要負責其他的動作
let charDelegate = GameCharacterDelegate()

// 將遊戲角色的 delegate 屬性設為委任的實體
oneChar.delegate = charDelegate

// 接著呼叫攻擊方法
oneChar.attack()
// 會依序印出：
// 攻擊！
// 攻擊後的整理工作


// 定義另一個協定 增加一個防禦方法 defend
protocol GameCharacterDefend {
    func defend()
}

// 定義一個擴展 會遵循新定義的協定 GameCharacterDefend
extension GameCharacter: GameCharacterDefend {
    // 必須實作這個方法
    func defend() {
        print("防禦！")
    }
}

// 使用前面生成的實體 oneChar
// 這樣這個被擴展的類別生成的實體 也隨即可以使用這個方法
oneChar.defend()
// 印出：防禦！


// 定義一個協定
protocol NewProtocol {
    var name: String { get set }
}

// 定義一個類別 滿足了[協定 NewProtocol]的要求 但尚未遵循它
class NewClass {
    var name = "good day"
}

// 這時可以使用擴展來遵循
extension NewClass: NewProtocol {}


// 生成另外兩個實體
let twoChar = GameCharacter()
let threeChar = GameCharacter()

// 宣告一個型別為 [GameCharacterProtocol] 的陣列
let team: [GameCharacterProtocol] = [oneChar, twoChar, threeChar]

// 因為都遵循這個協定 所以這個 attack() 方法一定存在可以呼叫
for member in team {
    member.attack()
}


// 定義一個協定 有一個 name 屬性
protocol Named {
    var name: String { get }
}

// 定義另一個協定 有一個 age 屬性
protocol Aged {
    var age: Int { get }
}

// 定義一個結構 遵循上面兩個定義的協定
struct OnePerson: Named, Aged {
    var name: String
    var age: Int
}

// 定義一個函式 有一個參數 定義為遵循這兩個協定的型別
// 所以寫成 : Named & Aged 格式
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("生日快樂！ \(celebrator.name) ， \(celebrator.age) 歲囉！")
}

let birthdayPerson = OnePerson(name: "Brian", age: 25)
wishHappyBirthday(to: birthdayPerson)
// 印出：生日快樂！ Brian ， 25 歲囉！


// 定義一個協定 有一個 area 屬性 表示面積
protocol HasArea {
    var area: Double { get }
}

// 定義一個圓的類別 遵循協定：HasArea 所以會有 area 屬性
class Circle: HasArea {
    var area: Double
    init(radius: Double) { self.area = 3.14 * radius * radius }
}

// 定義一個國家的類別 遵循協定：HasArea 所以會有 area 屬性
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}

// 定義一個動物的類別 沒有面積
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

// 以上三個類別的實體都可以作為 [AnyObject] 陣列的成員
let objects: [AnyObject] = [
    Country(area: 243610),
    Circle(radius: 2.0),
    Animal(legs: 4)
]

// 遍歷這個陣列
for object in objects {
    // 使用可選綁定來將成員綁定為 HasArea 的實體
    if let objectWithArea = object as? HasArea {
        // 符合協定 就會綁定成功 也就可以取得 area 屬性
        print("面積為 \(objectWithArea.area)")
    } else {
        // 不符合協定 則是返回 nil
        print("沒有面積！")
    }
}

// 依序印出：
// 面積為 243610.0
// 面積為 12.56
// 沒有面積！


// 要加上 @objc 必須引入 Foundation
import Foundation
// 這邊不詳細說明 因為可選協定與 Objective-C 程式語言有關係
// 而 Objective-C 大量使用到 Foundation 的功能 所以需要引入

// 定義一個可選協定 用於計數 分別有兩種不同的增量值
@objc protocol CounterDataSource {
    // 定義一個可選方法 可以傳入一個要增加的整數
    @objc optional func increment(forCount: Int) -> Int
    
    // 定義一個可選屬性 為一個固定增加的整數
    @objc optional var fixedIncrement: Int { get }
}

// 定義一個遵循可選協定的類別 計數用
class CounterSource: CounterDataSource {
    // 一個經由遵循協定而擁有的可選屬性 設值為 3
    // 前面必須加上 @objc
    @objc let fixedIncrement = 3
    
    // 不過因為是可選的 所以另一個可選方法可以不用實作 這邊將其註解起來
    /*
     @objc func increment(forCount: Int) -> Int {
     return count
     }
     */
    
}

// 用來計數的變數
var count = 0

// 生成一個型別為可選協定：CounterDataSource 的實體
// 因為類別 CounterSource 有遵循這個協定 所以可以指派為這個類別的實體
var dataSource: CounterDataSource = CounterSource()

// 迴圈跑 4 次
for _ in 1...4 {
    // 使用可選綁定
    // 首先呼叫 increment(forCount:) 方法 但因為這是個可選方法 所以需要加上 ?
    // 而目前這個 increment 沒有實作這個方法
    // 所以會返回 nil 也就不會執行 if 內的程式
    if let amount = dataSource.increment?(forCount: count){
        count += amount
    }
    // 接著依舊使用可選綁定 取得屬性 fixedIncrement
    // 因為有設置這個屬性 所以會有值 流程則會進入此 else if 內的程式
    else if let amount = dataSource.fixedIncrement{
        count += amount
    }
}

// 因為迴圈跑了 4 次,每次都是加上 3 ,所以最後計為 12
// 印出：最後計數為 12
print("最後計數為 \(count)")


// 擴展前面定義的協定 GameCharacterProtocol
// 此協定原本只有定義一個 attack() 方法
// 這邊增加一個新的方法
extension GameCharacterProtocol {
    func superAttack() {
        print("額外的攻擊！")
        attack()
    }
}

// 生成一個遊戲角色的實體
let member = GameCharacter()
member.delegate = GameCharacterDelegate()

// 可以直接呼叫擴展協定後新增的方法
member.superAttack()
// 依序印出：
// 額外的攻擊！
// 攻擊！
// 攻擊後的整理工作


// 先為協定：GameCharacterProtocol 經由擴展增加一個新的屬性
extension GameCharacterProtocol {
    var description: String {
        return "成員"
    }
}

// 接著擴展 集合型別的協定：Collection 且其內成員必須遵循 協定：GameCharacterProtocol
extension Collection where Iterator.Element: GameCharacterProtocol {
    var allDescription: String {
        let itemsAsText = self.map { $0.description }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

// 生成三個實體並放入一個陣列中
let oneMember = GameCharacter()
let twoMember = GameCharacter()
let threeMember = GameCharacter()
let myTeam = [oneMember, twoMember, threeMember]

// 因為陣列定義時有遵循 協定：CollectionType
// 且其內成員都遵循 協定：GameCharacterProtocol
// 所以這個 allDescription 屬性會自動獲得
// 印出：[成員, 成員, 成員]
print(myTeam.allDescription)
