
struct CharacterStats {
    var hp = 0.0
    var mp = 0.0
}

class GameCharacter {
    var stats = CharacterStats()
    var attackSpeed = 1.0
    var name: String?
}


let someStats = CharacterStats()
let someGameCharacter = GameCharacter()


// 這邊使用前面定義的 CharacterStats 結構 及生成的實體 someStats
// 因為沒有初始值 所以會使用預設值 這邊會印出：someStats 血量最大值為0.0
print("someStats 血量最大值為\(someStats.hp)")


// 這邊使用前面定義的 GameCharacter 類別 及其生成的實體 someGameCharacter
// 印出：someGameCharacter 血量最大值為0.0
print("someGameCharacter 血量最大值為\(someGameCharacter.stats.hp)")


// 將 someGameCharacter 的血量最大值指派為 500
someGameCharacter.stats.hp = 500
// 再次印出 即會變成：500.0
print(someGameCharacter.stats.hp)


// 這邊使用前面定義的 CharacterStats 結構 生成新的實體 someoneStats
let someoneStats = CharacterStats(hp: 120, mp: 100)

// 印出：120.0
print(someoneStats.hp)


// 這邊使用前面定義的 CharacterStats 結構
var oneStats = CharacterStats(hp: 120, mp: 100)
var anotherStats = oneStats

// 這時修改 anotherStats 的 hp 屬性
anotherStats.hp = 300
// 可以看出來已經改變了 印出：300.0
print(anotherStats.hp)

// 但 oneStats 的屬性不會改變
// 仍然是被生成實體時的初始值 印出：120.0
print(oneStats.hp)


// 這邊使用前面定義的 GameCharacter 類別
let archer = GameCharacter()
archer.attackSpeed = 1.5
archer.name = "弓箭手"

// 指派給一個新的常數
let superArcher = archer
// 並修改這個新實體的屬性 attackSpeed
superArcher.attackSpeed = 1.8

// 可以看到這邊印出的都為：1.8
print("archer 的攻速為 \(archer.attackSpeed)")
print("superArcher 的攻速為 \(superArcher.attackSpeed)")


// 使用前面宣告的兩個常數 archer 與 superArcher
if archer === superArcher {
    print("沒錯！！！是同一個類別實體")
}
