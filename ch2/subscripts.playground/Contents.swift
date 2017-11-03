
// 宣告一個 [Int] 型別的陣列
var arr = [1,2,3,4,5,6,7]

// 印出其內第三個元素(請記得 陣列的索引值是從 0 開始算起)
print(arr[2])

// 修改第四個元素為 12
arr[3] = 12


// 宣告一個 [String:String] 型別的字典
var dict = ["name":"Kevin","city":"Taipei"]

// 印出鍵為 name 的值
print(dict["name"]!)

// 修改鍵為 city 的值為 New York
dict["city"] = "New York"


// 定義一個簡單數學算式功能的類別
class SimpleMath {
    // 一個數字屬性預設值
    var num = 500
    
    // 定義一個下標 為乘法
    subscript(times: String) -> Int {
        get {
            // 其內可以使用這個索引值
            print(times)
            
            // 會返回 數字屬性乘以 2 的數值
            return num * 2
        }
        set {
            // 將數字屬性乘以新的倍數
            num *= newValue
        }
    }
    
    // 定義另一個下標 為除法
    subscript(divided: Int) -> Int {
        return num / divided
    }
}

// 宣告一個類別 SimpleMath 的常數
let oneMath = SimpleMath()

// 印出：1000
print(oneMath["simple"])

// 傳入值為 3, 會將數字屬性乘以 3
oneMath["star"] = 3

// 這個下標例子中的字串索引值沒有被使用到
// 其實是可以依照傳入的索引值 來做不同的需求及返回值

// 印出：1500
print(oneMath.num)

// 使用到另一個下標 索引值型別為 Int
// 印出：15
print(oneMath[100])
