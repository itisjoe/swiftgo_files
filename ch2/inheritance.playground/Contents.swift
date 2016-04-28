
// 定義一個遊戲角色職業通用的類別
class GameCharacter {
    // 攻擊速度
    var attackSpeed = 1.5
    
    // 這個職業的敘述
    var description: String {
        return "職業敘述"
    }
    
    // 執行攻擊的動作
    func attack() {
        // 無任何動作 有待子類別實作
    }
}

// 生成一個類別 GameCharacter 的實體
let oneChar = GameCharacter()

// 印出：職業敘述
print(oneChar.description)


class Archer: GameCharacter {
    // 新增一個屬性 攻擊範圍
    var attackRange = 2.5
}

// 父類別所有的特性都一併繼承下來
let oneArcher = Archer()
// 可以直接以點語法來存取或設置一個父類別中定義過的屬性
oneArcher.attackSpeed = 1.8


class Hunter: Archer {
    // 新增一個方法 必殺技攻擊
    func fatalBlow() {
        print("施放必殺技攻擊！")
    }
}

let oneHunter = Hunter()
// 這個類別一樣可以使用 Archer 及 GameCharacter 定義過的屬性及方法
print("攻擊速度為 \(oneHunter.attackSpeed), 攻擊範圍為 \(oneHunter.attackRange)")
// 當然自己新增的方法也可以使用
oneHunter.fatalBlow()


// 使用並改寫前面定義的類別 Hunter
class OtherHunter: Archer {
    // 覆寫父類別的實體方法
    override func attack() {
        print("攻擊！這是獵人的攻擊！")
    }
    
    // 省略其他內容
}

let otherHunter = OtherHunter()
otherHunter.attack()
// 即會印出覆寫後的內容：攻擊！這是獵人的攻擊！


// 使用並改寫前面定義的類別 Hunter
class AnotherHunter: Archer {
    // 覆寫父類別的屬性 重新實作 getter 跟 setter
    override var attackSpeed: Double {
        get {
            return 2.4
        }
        set {
            print(newValue)
        }
    }
    
    // 省略其他內容
}


// 使用並改寫前面定義的類別 Archer
class OtherArcher: GameCharacter {
    // 覆寫一個屬性 重新實作 getter 跟 setter
    override var attackSpeed: Double {
        willSet {
            print("OtherArcher willSet")
        }
        didSet {
            print("OtherArcher didSet")
        }
    }
    
    // 省略其他內容
}

// 使用並改寫前面定義的類別 Hunter
class SomeHunter: OtherArcher {
    // 覆寫一個屬性 重新實作 getter 跟 setter
    override var attackSpeed: Double {
        willSet {
            print("SomeHunter willSet")
        }
        didSet {
            print("SomeHunter didSet")
        }
    }
    
    // 省略其他內容
}

let someHunter = SomeHunter()
// 設置新的值 會觸發 willSet 跟 didSet
someHunter.attackSpeed = 1.8
// 依序會印出：
// SomeHunter willSet
// OtherArcher willSet
// OtherArcher didSet
// SomeHunter didSet


// 使用並改寫前面定義的類別 Hunter
class GoodHunter: Archer {
    // 覆寫一個屬性 並使用父類別原先的屬性值
    override var description: String {
        return super.description + " 精通箭術的獵人"
    }
    
    // 省略其他內容
}

let goodHunter = GoodHunter()

// 印出：職業敘述 精通箭術的獵人
print(goodHunter.description)
