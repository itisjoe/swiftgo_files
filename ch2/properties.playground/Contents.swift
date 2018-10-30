
// 定義一個遊戲角色的血量與法力最大值
struct CharacterStats {
    // 指定一個預設值
    var hpValueMax: Double = 300
    let mpValueMax: Double
}

// 或是在建構時設置屬性的值
var oneStats = CharacterStats(hpValueMax: 500, mpValueMax: 120)

// 生成實體後也可以再修改屬性的值
oneStats.hpValueMax = 200

// 但因為 mpValueMax 為一個結構裡的常數屬性 所以不能修改常數 下面這行會報錯誤
//oneStats.mpValueMax = 200


// 這邊使用前面定義的 CharacterStats 結構
// 生成一個 CharacterStats 結構的實體 並指派給一個常數 someStats
let someStats = CharacterStats(hpValueMax: 900, mpValueMax: 150)

// 這個實體 someStats 為一個常數 所以即使 hpValueMax 為一個變數屬性 仍然不能修改這個值 這行會報錯誤
//someStats.hpValueMax = 1200


// 首先定義一個類別 DataImporter
// 這個類別會導入外部檔案並執行一些操作 初始化可能會花費不少時間
class DataImporter {
    // 這邊簡化成一個檔案名稱 實際上可能會有很多操作
    var fileName = "data.txt"
}

// 接著定義另一個類別 DataManager
class DataManager {
    // 延遲儲存屬性
    lazy var importer = DataImporter()
    // 操作時需要用到的資料
    var data = [String]()
    
    // 簡化內部內容 可能還有許多操作資料的動作
}

// 生成一個類別 DataManager 的實體常數
let manager = DataManager()

// 添加一些資料
manager.data.append("Some data")
manager.data.append("Some more data")

// 到目前為止 manager 的 importer 都尚未被初始化

// 直到第一次使用這個屬性 才會被創建並初始化
print(manager.importer.fileName)


class GameCharacter {
    // 血量初始值
    var hpValue: Double = 100
    
    // 防禦力初始值
    var defenceValue: Double = 300
    
    // 總防禦力的 getter 跟 setter
    var totalDefence: Double {
        get {
            // 總防禦力的算法是 防禦力加上 10% 血量
            return (defenceValue + 0.1 * hpValue)
        }
        set(levelUp) {
            // 升級時 會將血量及防禦力乘上一個倍數
            hpValue = hpValue * (1 + levelUp)
            defenceValue = defenceValue * (1 + levelUp)
        }
    }
}

// 生成一個類別 GameCharacter 的實體常數 oneChar
let oneChar = GameCharacter();

// 取得目前角色的總防禦力
// 印出：310.0
print(oneChar.totalDefence)

// 升級時 角色狀態各數值會乘上的倍數 0.05
oneChar.totalDefence = 0.05

// 則現在角色的血量與防禦力會變成 105 跟 315
// 印出：血量：105.0, 防禦力：315.0
print("血量：\(oneChar.hpValue), 防禦力：\(oneChar.defenceValue)")


// 將原先的 levelUp 參數移除 這時會提供一個內建的參數名稱 newValue
/*
 set {
 // 升級時 會將血量及防禦力乘上一個倍數
 hpValue = hpValue * (1 + newValue)
 defenceValue = defenceValue * (1 + newValue)
 }
*/


// 定義一個遊戲角色的狀態
class AnotherGameCharacter {
    // 血量初始值
    var hpValue: Double = 100
    
    // 防禦力初始值
    var defenceValue: Double = 300
    
    // 總防禦力只有 getter
    var totalDefence: Double {
        // 總防禦力的算法是 防禦力加上 10% 血量
        return (defenceValue + 0.1 * hpValue)
    }
    
}


// 定義一個遊戲角色的狀態
class SomeGameCharacter {
    // 血量初始值
    var hpValue: Double = 100 {
        willSet (hpChange) {
            // 改變血量前
            print("新的血量為\(hpChange)")
        }
        didSet {
            // 改變血量後
            if oldValue > hpValue {
                // 原血量較高 所以是受到攻擊 損血
                print("我損血了！哦阿！")
            } else {
                print("我補血了！耶！")
            }
        }
    }
}

// 生成一個類別 SomeGameCharacter 的實體常數 anotherChar
let anotherChar = SomeGameCharacter();

// 角色受到攻擊 血量降低
// 因為有 willSet 所以會印出：新的血量為90.0
anotherChar.hpValue = 90

// 設置完新的血量後 因為有 didSet 所以會印出：我損血了！哦阿！


struct SomeStructure {
    static var storedTypeProperty = "Some value in structure."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value in enumeration."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value in class."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}


// 這邊使用前面定義的結構 SomeStructure, 列舉 SomeEnumeration, 類別 SomeClass

// 印出：Some value in structure.
print(SomeStructure.storedTypeProperty)

// 設置一個型別屬性
SomeStructure.storedTypeProperty = "Another value."
// 印出：Another value.
print(SomeStructure.storedTypeProperty)

// 印出：6
print(SomeEnumeration.computedTypeProperty)

// 印出：27
print(SomeClass.computedTypeProperty)
