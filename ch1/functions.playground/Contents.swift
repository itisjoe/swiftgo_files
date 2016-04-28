
// 建立一個函式
func simpleOne() {
    print("It is a simple function .")
}

// 呼叫函式
simpleOne()
// 這樣就會執行函式內的程式 這邊是一個簡單的功能
// 印出：It is a simple function .


// 建立函式 有一個型別為 Int 的參數
// 函式的功能是將帶入的參數加一 並印出來
func addOne(number: Int) {
    // number 即為被指派參數的常數 只能在函式內部範圍內使用
    print(number + 1)
}

// 呼叫函式 傳入整數 12
// 印出：13
addOne(12)


// 建立一個有兩個參數的函式 參數的型別分別為 String 及 Int
func hello(name: String, age: Int) {
    print("\(name) is \(age) years old .")
}

// 呼叫函式
hello("Jack", age: 25)


func hello2(name n: String, age a: Int) {
    // n 跟 a 為內部參數名稱 在函式內部使用
    print("\(n) is \(a) years old .")
}

// name 跟 age 為外部參數名稱 呼叫函式時要標註在參數之前
hello2(name: "Jack", age: 25)


// 第二個參數的外部參數名稱 使用下底線 _ 替換
func hello3(name: String, _ age: Int) {
    print("\(name) is \(age) years old .")
}

// 呼叫函式時 第二個參數就可以不用寫外部參數名稱
hello3("Jack", 33)


// 第一個參數不需要外部參數名稱
// 第二個及之後的參數 可以使用其內部參數名稱作為外部參數名稱 這邊就是 age
func hello4(name: String, age: Int) {
    print("\(name) is \(age) years old .")
}

// 呼叫函式時 第二個參數的外部參數名稱是 age 而內部參數名稱也是 age
hello4("Jack", age: 25)


func sayHello(to name: String, and name2: String) {
    print("Hello \(name) and \(name2) !")
}
// 外部參數名稱設為 to 跟 and
// 這行看起來就像個完整的英文句子 可以明顯的知道這個函式要幹嘛
sayHello(to: "Joe", and: "Amy")


func someFunction(number: Int = 12) {
    print(number)
}

// 印出：6
someFunction(6)

// 沒有傳入值 則會使用預設值 印出：12
someFunction()


func arithmeticMean(numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5) // 返回 3.0
arithmeticMean(3, 8, 19) // 返回 10.0


// 定義一個[有一個輸入輸出參數]的函式 參數前要加上 inout
func newNumber(inout number: Int) {
    number *= 2
}

var n = 10
print(n) // 這時 n 為 10

// 傳入的參數在函式結束後 改變仍然存在
newNumber(&n)

print(n) // 所以這時再印出 就會是 20


// 定義函式 有一個型別為 Int 的參數以及一個型別為 Int 的返回值
// 函式的功能是將帶入的參數加十 並返回
func addTen(number: Int) -> Int {
    let n = number + 10
    // 使用 return 來返回值 這個返回值的型別要與上面標註的相同
    return n
}

// 呼叫函式 傳入整數 12 會返回 22
let newNumber = addTen(12)

// 印出：22
print(newNumber)


// 定義函式 有一個型別為 Int 的參數, 返回兩個型別為 Int 的值
func findNumbers(number: Int) -> (Int, Int) {
    let n = number + 10
    // 返回一個元組
    return (number, n)
    
    // 合併成一行直接返回也是可以
    // return (number, number + 10)
}

// 呼叫函式 傳入整數 12 會返回 (12, 22)
let numbers = findNumbers(12)
// numbers 為一個元組 可以自 0 開始算 依序取得其內的值
// 印出：12 and 22
print("\(numbers.0) and \(numbers.1)")


// 定義另一個函式 將上面函式中返回的元組內的值加上名稱
func findNumbers2(number: Int) -> (oldNumber: Int, newNumber: Int) {
    let n = number + 10
    return (number, n)
}

// 呼叫函式 傳入整數 24 會返回 (24, 34)
let numbers2 = findNumbers2(24)
// 這邊即可使用定義函式時 返回元組內的值設定的名稱
// 印出：24 and 34
print("\(numbers2.oldNumber) and \(numbers2.newNumber)")


// 定義函式 參數為一個型別為 [Int] 的陣列
// 返回值為 包含兩個型別為 Int 的元組 或是 nil
func findNumbers3(arr: [Int]) -> (Int, Int)? {
    // 檢查傳入的陣列 如果其內沒有值的話 就直接返回 nil
    if arr.isEmpty {
        return nil
    }
    let n = arr[0] + 10
    let n2 = arr[0] + 100
    return (n, n2)
}

// 呼叫函式
// 因為返回的是一個可選型別 這邊先做可選綁定的動作 確定有值後再印出來
if let numbers = findNumbers3([11,22,33]) {
    print("\(numbers.0) and \(numbers.1)")
}
// 如果傳入的陣列 內部沒有值
if let numbers = findNumbers3([]) {
    print("這裡不會被印出來")
}


func hello5() {
    print("Hello !")
}


var mathFunction: (Int) -> Int = addTen


// 定義一個將兩個整數相加的函式
func addTwoInts(number1: Int, number2: Int) -> Int {
    return number1 + number2
}

// 定義另一個函式，有三個參數依序為
// 型別為 (Int, Int) -> Int 的函式, Int, Int
func printMathResult(mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}

// 將一個函式 addTwoInts 傳入函式 printMathResult
printMathResult(addTwoInts, 3, 5)


// 定義一個將傳入的參數加一的函式
func stepForward(input: Int) -> Int {
    return input + 1
}

// 定義一個將傳入的參數減一的函式
func stepBackward(input: Int) -> Int {
    return input - 1
}

// 建立一個參數為布林值的函式 會返回一個函式
// 根據布林值返回上述兩個函式的其中一個
func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
    return backwards ? stepBackward : stepForward
}

// 宣告一個整數常數
let number = 3
// 宣告一個函式常數
let someFunction2 = chooseStepFunction(number > 0)
// 根據 chooseStepFunction 函式的內容 傳入 true 時 會返回 stepBackward 函式
// 所以 someFunction2 會被指派為 stepBackward

someFunction2(10) // 返回 9


// 改寫前面的內容 將兩個函式建立在這個函式內
// 同樣是依據傳入的布林值 返回不同的函式
func anotherChooseStepFunction(backwards: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int {
        return input + 1
    }
    
    func stepBackward(input: Int) -> Int {
        return input - 1
    }
    
    return backwards ? stepBackward : stepForward
}

let number2 = -35
let someFunction3 = anotherChooseStepFunction(number2 > 0)

someFunction3(10) // 返回 11
