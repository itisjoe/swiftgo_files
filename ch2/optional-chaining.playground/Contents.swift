
// 定義一個類別 Person
class Person {
    // residence 屬性為可選的 Residence 型別
    var residence: Residence?
}

// 定義一個類別 Residence
class Residence {
    // numberOfRooms 屬性為 Int 型別
    var numberOfRooms = 1
}

// 首先生成一個實體
let joe = Person()

// 這時 joe 實體內的可選屬性 residence 沒有設置值 所以會初始化為 nil
// 如果強制解析的話 會發生錯誤 如以下這行
//let roomCount = joe.residence!.numberOfRooms

// 所以這時可使用可選鏈來呼叫
if let roomCount = joe.residence?.numberOfRooms {
    print("Joe 有 \(roomCount) 間房間")
} else {
    print("無法取得房間數量")
}

// 上述 if 語句目前會印出：無法取得房間數量
// 接著為 joe.residence 設置一個 Residence 實體
joe.residence = Residence()

// 這時就會返回 1
// 記得這是返回一個可選型別 Int?
//print(joe.residence?.numberOfRooms)


// 與先前的類別 Person 相同
class NewPerson {
    var residence: NewResidence?
}

// 定義一個類別 Room
class Room {
    // name 屬性為 String 型別
    let name: String
    
    // 生成實體時同時設置屬性 name 的值
    init(name: String) { self.name = name }
}

// 重新定義類別 Residence
class NewResidence {
    // rooms 屬性為一個陣列 型別為 [Room] 預設值是空陣列
    var rooms = [Room]()
    
    // 將 numberOfRooms 改為一個計算屬性 並返回 rooms 的數量
    var numberOfRooms: Int {
        return rooms.count
    }
    
    // 新增一個下標 可以依索引值取得 rooms 陣列內的值
    // 或是依索引值修改 rooms 陣列內的值
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    
    // 新增一個方法 簡單的印出房間數量
    func printNumberOfRooms() {
        print("有 \(numberOfRooms) 間房間")
    }
    
}


// 使用上面生成的實體 joe 設置新的值
joe.residence?.numberOfRooms = 12


let kevin = NewPerson()
kevin.residence = NewResidence()

// 可以依據是否返回 nil 來判斷可選鏈是否成功
if kevin.residence?.printNumberOfRooms() != nil {
    kevin.residence?.printNumberOfRooms()
} else {
    print("無法呼叫函式")
}

// 這時因為都有值且有預設值 所以會印出：有 0 間房間


// 先生成一個實體
let jack = NewPerson()

// 這邊嘗試存取放在陣列中第一個房間的名稱
if let firstRoomName = jack.residence?[0].name {
    print("第一個房間的名稱為 \(firstRoomName).")
} else {
    print("無法取得第一個房間的名稱")
}

// 這邊嘗試用下標指派一個值
jack.residence?[0] = Room(name: "臥房")

// 上面兩個返回的都是 nil 因為目前 jack.residence 尚未有值

// 先生成一個 NewResidence 實體
let jackHouse = NewResidence()

// 接著為其內型別為 [Room] 的陣列屬性加上值
jackHouse.rooms.append(Room(name: "廚房"))
jackHouse.rooms.append(Room(name: "浴室"))

// 最後將其設置為 jack.residence
jack.residence = jackHouse

// 這時再存取 即會有值 這邊會印出：第一個房間名稱為 廚房
if let firstRoomName = jack.residence?[0].name {
    print("第一個房間名稱為 \(firstRoomName)")
} else {
    print("無法取得第一個房間的名稱")
}


// 宣告一個字典的變數
var testScores = [
    "Dave": [86, 82, 84],
    "Bev": [79, 94, 81]
]

// 為下標設置新的值
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1

// 因為沒有 Brian 這個鍵 會是 nil
// 所以指派值會失敗 底下這行不會有任何事情發生
testScores["Brian"]?[0] = 72

