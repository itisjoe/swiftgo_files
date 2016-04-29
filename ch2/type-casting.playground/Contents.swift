
// 首先定義一個類別 GameCharacter
class GameCharacter {
    var name: String
    init(name: String) {
        self.name = name
    }
}

// 接著定義兩個繼承自 GameCharacter 的類別
class Archer: GameCharacter {
    var intro: String
    init(name: String, intro: String) {
        self.intro = intro
        super.init(name: name)
    }
}

class Warrior: GameCharacter {
    var description: String
    init(name: String, description: String) {
        self.description = description
        super.init(name: name)
    }
}


// gameTeam 的型別被自動推斷為 [GameCharacter]
let gameTeam = [
    Archer(name: "one", intro: "super power"),
    Warrior(name: "two", description: "good fighter"),
    Archer(name: "three", intro: "not bad")
]


// 用來計算弓箭手跟戰士的數量
var archerCount = 0
var warriorCount = 0

for character in gameTeam {
    // 檢查是否是弓箭手或戰士
    if character is Archer {
        archerCount += 1
    } else if character is Warrior {
        warriorCount += 1
    }
}

// 最後印出：這隻隊伍有 2 個弓箭手跟 1 個戰士。
print("這隻隊伍有 \(archerCount) 個弓箭手跟 \(warriorCount) 個戰士。 ")


for character in gameTeam {
    if let oneChar = character as? Archer {
        print("弓箭手的名字：\(oneChar.name)，介紹：\(oneChar.intro)")
    } else if let anotherChar = character as? Warrior {
        print("戰士的名字：\(anotherChar.name)，描述：\(anotherChar.description)")
    }
}

// 使用可選綁定來檢查是否轉換成功 會依序印出：
// 弓箭手的名字：one，介紹：super power
// 戰士的名字：two，描述：good fighter
// 弓箭手的名字：three，介紹：not bad


let someObjects: [AnyObject] = [
    Archer(name: "one", intro: "super power"),
    Archer(name: "two", intro: "not bad")
]

// 我們明確的知道這個陣列只包含著 Archer 實體
// 所以可以使用強制性的 as! 來向下轉換至 Archer 型別
for object in someObjects {
    let oneChar = object as! Archer
    print("弓箭手的名字：\(oneChar.name)，介紹：\(oneChar.intro)")
}

// 依序會印出：
// 弓箭手的名字：one，介紹：super power
// 弓箭手的名字：two，介紹：not bad


for object in someObjects as! [Archer] {
    print("弓箭手的名字：\(object.name)，介紹：\(object.intro)")
}


var things = [Any]()

// 依序加入 浮點數, 字串, 元組, Archer 實體, 閉包
things.append(3.1415926)
things.append("Hello, world")
things.append((3.0, 5.0))
things.append(Archer(name: "one", intro: "super power"))
things.append({ (name: String) -> String in "Hello, \(name)" })

// 再以 for-in 遍歷陣列 使用 switch 配對每一個值
for thing in things {
    switch thing {
    case let someDouble as Double where someDouble > 0:
        print("浮點數為 \(someDouble)")
    case let someString as String:
        print("字串為 \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("元組為 \(x), \(y)")
    case let oneChar as Archer:
        print("弓箭手的名字：\(oneChar.name)，介紹：\(oneChar.intro)")
    case let stringConverter as String -> String:
        print(stringConverter("Jess"))
    default:
        print("沒有配對到的值")
    }
}

// 依序印出：
// 浮點數為 3.1415926
// 字串為 "Hello, world"
// 元組為 3.0, 5.0
// 弓箭手的名字：one，介紹：super power
// Hello, Jess
