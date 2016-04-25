
// 宣告一個整數變數
var number: Int

// 宣告一個字串常數
let str: String = "It is a string ."


let oneNumber = 12
var anotherNumber = -240


let piValue = 3.1415926
var height = 178.25

// 宣告浮點數時 如果沒有型別標註 通常會將他判斷為 Double
let oneHeight = 165.25 // 型別為 Double
let anotherHeight: Float = 175.5 // 除非型別標註填寫為 Float


// 型別為整數 Int
let number1 = 3

// 型別為浮點數 Double
let number2 = 0.1415926

// 相加前 需要將 Int 轉換成 Double 否則會報錯誤
let pi = Double(number1) + number2

// 這個值的型別也就是 Double
// 印出：3.1415926
print(pi)


let integerPi = Int(pi)

// 型別為 Int 小數點後的數字被截斷
// 所以只會印出：3
print(integerPi)


let storeOpen = true
let forFree = false


let firstString = "Nice to meet you."
let secondString = "Nice to meet you,too."

// 宣告字串時 不論字數多少 都會判斷為 String
let str1 = "It is a string ." // 型別為 String
let str2 = "b" // 型別仍然是 String
let str3: Character = "c" // 除非型別標註填寫為 Character


let score = 80
let string = "My score is \(score) ."
// 印出：My score is 80 .
print(string)


// 宣告一個元組並填值進去 依序是字串、整數、浮點數
let myInfo = ("Kevin Chang", 25, 178.25)


// 取得前面宣告的 myInfo 的第三個值 因為是從 0 開始算 所以是 2
let myHeight = myInfo.2

// 印出：My height is 178.25
print("My height is \(myHeight)")


// 將前面宣告的 myInfo 分解成三個常數
let (myName, myAge, myRealHeight) = myInfo

// 印出：My name is Kevin Chang .
print("My name is \(myName) .")

// 印出：I am 25 years old .
print("I am \(myAge) years old .")


let (_, _, myTrueHeight) = myInfo

// 印出：My height is 178.25 .
print("My height is \(myHeight) .")


let herInfo = (name:"Jess", age:24, height:160.5)

// 除了用順序取得外 如果有設定名稱 也可以直接取用
// 印出：Her name is Jess .
print("Her name is \(herInfo.name) . ")


// 將 Int 型別定義一個新的名字 MyType
typealias MyType = Int

// 這時就可以宣告一個 MyType 變數 其實也就是 Int 變數
var someNumber: MyType = 123


// 在宣告變數時 型別標註後面加上一個問號 ?
var someScore: Int? // 因為目前尚未指派 所以目前 score 會被設置成 nil 也就是沒有值的狀態
// 設值為 100
someScore = 100
// 再將變數設為 nil 目前又是沒有值的狀態
someScore = nil

// 但如果沒有加上 ? 則是尚未指派的狀態 這時如果直接使用會報錯誤
var totalScore: Int
// 也不能設成 nil 這行同樣也會報錯誤
//totalScore = nil

// 宣告常數也是一樣 在型別標註後面加上一個問號 ?
let someName: String?


// 宣告一個字串常數
let numberValue = "5566"

// 嘗試將這個字串轉換成整數
let newNumber = Int(numberValue)


// 宣告一個整數常數 並賦值
let number3: Int? = 500
// 以這個例子來說 常數確實有值
// 所以加上驚嘆號 表示這個可選型別有值 可以直接使用
print(number3!)


// 尚未賦值 所以目前是 nil
var number4: Int?
// 仍然要使用的話 下面這行則會報錯誤
//print(number4!)


// 可選型別
let oneString: String? = "Good morning ."
// 需要驚嘆號來取值
let anotherString: String = oneString!

// 如果改成隱式解析可選型別
let twoString: String! = "Good night ."
// 則可以直接使用 不用加上驚嘆號
let finalString: String = twoString

