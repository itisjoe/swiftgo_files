
let b = 10
var a = 5
// 將 b 指派給左邊的 a
a = b
// 現在 a 等於 10

// 你也可以直接指派元組 會直接分解為多個常數或變數
let (x, y) = (1, 2)
// 現在 x 為 1, y 為 2


var c = 1 + 2 // c 等於 3
var d = 7 - 2 // d 等於 5
var e = 3 * 2 // e 等於 6
var f = 10.0 / 2.5 // f 等於 4.0


let firstString = "Hello, "
let secondString = "world."
let finalString = firstString + secondString

// 印出：Hello, world.
print(finalString)


var oneNumber = 9 % 4
print(oneNumber) // 餘數等於 1


let number1 = 3
var anotherNumber1 = -number1 // 為 -3
var finalNumber1 = -anotherNumber1 // 為 3


let number2 = -6
var anotherNumber2 = +number2 // 為 -6


var n = 3
n += 2 // 這行等同於 n = n + 2 的簡寫
print(n) // 現在 n 等於 5

// 其他運算子也是一樣
n -= 4 // n = n - 4 , 現在 n 等於 1
n *= 10 // n = n * 10 , 現在 n 等於 10
n /= 2 // n = n / 2 , 現在 n 等於 5
n %= 2 // n = n % 2 , 現在 n 等於 1


1 == 1 // 返回 true 因為 1 等於 1
2 != 1 // 返回 true 因為 2 不等於 1
2 > 1 // 返回 true 因為 2 大於 1
1 < 2 // 返回 true 因為 1 小於2
1 >= 1 // 返回 true 因為 1 大於等於 1
2 <= 1 // 返回 false 因為 2 不小於等於 1


var i = 1
if i == 1 {
    print("Yes, it is 1 .")
} else {
    print("No, it is not 1 .")
}


// true 因為 1 小於 2
(1, "zebra") < (2, "apple")

// true 因為 3 等於 3,但是 apple 小於 bird
(3, "apple") < (3, "bird")

// true 因為 4 等於 4,dog 等於 dog
(4, "dog") == (4, "dog")


var score = 25
if score < 60 {
    score = score + 50
} else {
    score = score + 20
}

print(score) // 現在 score 等於 75


var newScore = 25
newScore = newScore + (newScore < 60 ? 50 : 20)


let defaultColor = "red"
var userDefinedColor: String? // 未指派值 所以預設為 nil
var colorToUse = userDefinedColor ?? defaultColor
// 未指派值給 userDefinedColor ,所以會返回 defaultColor
// 這邊即印出：red
print(colorToUse)

// 反之如果有指派值
var userAnotherDefinedColor: String? = "green"
var anotherColorToUse = userAnotherDefinedColor ?? defaultColor
// 這邊即印出：green
print(anotherColorToUse)


// 1...5 代表的就是 1,2,3,4,5 這五個數字
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}
// 依序印出
// 1 * 5 = 5
// 2 * 5 = 10
// 3 * 5 = 15
// 4 * 5 = 20
// 5 * 5 = 25


// 1..<5 代表的就是 1,2,3,4 這四個數字 不包括 5
for index in 1..<5 {
    print("\(index) * 5 = \(index * 5)")
}
// 依序印出
// 1 * 5 = 5
// 2 * 5 = 10
// 3 * 5 = 15
// 4 * 5 = 20


let isOn = false
if !isOn {
    print("It is on .")
}


let isOpen = true
let isMorning = false
if isOpen && isMorning {
    print("Success !")
} else {
    print("Failure !")
}
// 因為其中一個為 false 所以會返回 false
// 即印出：Failure !


let isSunday = true
let isWeekday = false
if isSunday || isWeekday {
    print("Success !")
} else {
    print("Failure !")
}

// 因為其中一個為 true 就會返回 true
// 即印出：Success !


// 數值運算
var number = 3 + 2 * 5 // 先乘除後加減 所以 number 等於 13
var someNumber = (3 + 2) * 5 // 括號括起來的優先 所以 someNumber 等於 25

// 邏輯運算
let itIsOpen = false
let isWeekend = true
let isMonday = true

// 由左至右依序判斷
if itIsOpen && isWeekend || isMonday {
    print("Success !")
} else {
    print("Failure !")
}
// 先作"邏輯且"判斷 itIsOpen && isWeekend 會返回 false
// 再與後面的 isMonday 作"邏輯或"的判斷 會返回 true
// 所以這邊會印出：Success !

// 括號有優先權
if itIsOpen && (isWeekend || isMonday) {
    print("Success !")
} else {
    print("Failure !")
}
// 括號優先 所以先做"邏輯或"判斷 isWeekend || isMonday 會返回 true
// 再與前面的 itIsOpen 作"邏輯且"的判斷 會返回 false
// 所以這邊會印出：Failure !

