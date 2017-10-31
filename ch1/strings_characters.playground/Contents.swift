
// 將一個字串字面量指派給一個常數
let someString = "Some string literal value"


// 顯示多行字串字面量
let someMultiLineString = """
多行文字
也就是多行字串字面量
可以一併顯示
"""


// 這兩個是一樣的意思
var emptyString = ""
var anotherEmptyString = String()


var variableString = "Cat"
variableString = "Book"
// variableString 現在為 Book

let constantString = "Sun"
//constantString = "Moon" // 這行會報錯誤 因為常數不能被修改


for character in "Dog!" {
    print(character)
}
// 依序印出
// D
// o
// g
// !


let str = "Hello"
let secondStr = ", world ."
var anotherStr = str + secondStr
// 印出：Hello, world .
print(anotherStr)

anotherStr += " Have a nice day ."
// 印出：Hello, world . Have a nice day .
print(anotherStr)


let str1 = "Sunday"
var anotherStr1 = "It is \(str1) ."
// 印出：It is Sunday .
print(anotherStr1)

// 表達式也可以
// 印出：I have 13 cars .
print("I have \(1 + 2 * 6) cars .")


// 印出 "Imagination is more important than knowledge" - Einstein
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"

let dollarSign = "\u{24}"        // $,  Unicode 純量 U+0024
let blackHeart = "\u{2665}"      // ♥,  Unicode 純量 U+2665


let str2 = "What a lovely day !"

// 印出字元數量：19
print(str2.count)


let str3 = "It is Sunday ."
let str4 = "It is Sunday ."
let str5 = "It is Saturday ."

// 兩個字串相同 所以成立
if str3 == str4 {
    print("Success")
}
// 印出：Success

// str4 有前綴字串 It is 所以成立
if str4.hasPrefix("It is") {
    print("Success")
}
// 印出：Success

// str5 沒有後綴字串 Sunday . 所以不成立
if str5.hasSuffix("Sunday .") {
    print("Success")
} else {
    print("Failure")
}
// 印出：Failure
