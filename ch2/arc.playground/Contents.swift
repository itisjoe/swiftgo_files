
// 定義一個類別 SomePerson
class SomePerson {
    let name: String
    init (name: String) {
        self.name = name
    }
}

// 先宣告三個可選 SomePerson 的變數 會被自動初始化為 nil
// 這三個變數目前都尚未有實體的參考
var reference1: SomePerson?
var reference2: SomePerson?
var reference3: SomePerson?

// 先生成一個實體 並指派給其中一個變數 reference1
reference1 = SomePerson(name: "Jess")

// 目前這個實體就有了一個強參考 參考計數為 1
// 所以 ARC 會保留住這個實體使用的記憶體

// 接著再指派給另外兩個變數
reference2 = reference1
reference3 = reference1

// 這時這個實體多了 2 個強參考 總共為 3 個強參考
// 也就是目前的參考計數為 3

// 接著將其中兩個變數指派為 nil 斷開他們的強參考
reference1 = nil
reference2 = nil

// 目前還有 1 個強參考 參考計數為 1
// 所以 ARC 仍然會保留住記憶體

// 最後將第三個變數也指派為 nil 斷開強參考
reference3 = nil

// 這時這個實體已經沒有強參考了 參考計數為 0
// ARC 就會將記憶體釋放掉


// 定義一個類別 Person
// 有一個屬性為可選 Apartment 型別 因為人不一定住在公寓內
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
}

// 定義一個類別 Apartment
// 有一個屬性為可選 Person 型別 因為公寓不一定有住戶
class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person?
}

// 宣告一個變數為可選 Person 型別 並生成一個實體
var joe: Person? = Person(name: "Joe")
// 生成實體後 其內的 apartment 屬性沒有指派值 初始化為 nil
// 目前這個實體的強參考有 1 個 參考計數為 1

// 宣告一個變數為可選 Apartment 型別 並生成一個實體
var oneUnit: Apartment? = Apartment(unit: "5A")
// 生成實體後 其內的 tenant 屬性沒有指派值 初始化為 nil
// 目前這個實體的強參考有 1 個 參考計數為 1


joe!.apartment = oneUnit
oneUnit!.tenant = joe
// 這時這兩個實體 各別都有 2 個強參考

//如果此時將 2 個變數斷開強參考
joe = nil
oneUnit = nil

// 這時這 2 個實體 各別仍還是有 1 個指向對方的強參考
// 也就造成記憶體無法釋放


class AnotherPerson {
    let name: String
    init(name: String) { self.name = name }
    var apartment: AnotherApartment?
}

class AnotherApartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    
    // 將這個屬性定義為弱參考 使用 weak 關鍵字
    weak var tenant: AnotherPerson?
}

var joe2: AnotherPerson? = AnotherPerson(name: "Joe")
var oneUnit2: AnotherApartment? = AnotherApartment(unit: "5A")
joe2!.apartment = oneUnit2

// 因為是弱參考
// 所以這個指派為實體的屬性 不會增加 joe2 參考的實體的參考計數
oneUnit2!.tenant = joe2

// 當斷開這個變數的強參考時 目前該實體的參考計數會減為 0
// 所以會將這個實體釋放
// 而所有指向這個實體的弱參考 都會被設為 nil
joe2 = nil

// 隨著上面的 joe2 被釋放
// 目前 oneUnit2 參考的實體的參考計數減為 1
// 以下再將原本的強參考斷開 參考計數減為 0 則也會將此實體釋放
oneUnit2 = nil


// 定義一個類別 Customer
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
}

// 定義一個類別 CreditCard
class CreditCard {
    let number: Int
    
    // 定義一個無主參考 非可選型別 因為一定會有使用者(一定有值)
    unowned let customer: Customer
    
    init(number: Int, customer: Customer) {
        self.number = number
        self.customer = customer
    }
}

// 宣告一個可選 Customer 的變數
var jess: Customer? = Customer(name: "Jess")

// 接著生成一個 CreditCard 實體並指派給 jess 的 card 屬性
jess!.card = CreditCard(number: 123456789, customer: jess!)
// 這個 CreditCard 實體的 customer 屬性 則使用無主參考指向 jess

// 現在 jess 指向的實體 參考計數為 1 (即 jess 這個變數強參考指向的)
// jess 內的屬性 card 指向的實體 參考計數也為 1 (即這個 card 屬性強參考指向的)

// 而 CreditCard 實體的 customer 屬性 因為是無主參考指向 jess
// 所以不會增加參考計數

// 這時將 jess 指向的實體強參考斷開
jess = nil
// 這時這個實體的參考計數為 0 則實體會被釋放
// 指向 CreditCard 實體的強參考也會隨之斷開
// 因此也就被釋放了


class Country {
    let name: String
    
    // 定義為 隱式解析可選型別
    var capitalCity: City!
    
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    
    // 定義為 無主參考
    unowned let country: Country
    
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

var country = Country(name: "Japan", capitalName: "Tokyo")


class HTMLElement {
    let name: String
    let text: String?
    
    // 定義為 lazy 屬性 表示只有當初始化完成以及 self 確實存在後
    // 才能存取這個屬性
    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
}

// 宣告為可選 HTMLElement 型別 以便後面設為 nil
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "Hello, world")

// 初始化完成後 就可以存取這個屬性
print(paragraph!.asHTML())

// 這時 paragraph 指向的實體的參考計數為 2
// 一個是自己 一個是閉包

// 而這個實體也有一個強參考指向閉包

// 這時將變數指向的強參考斷開 參考計數減為 1
// 參考仍然不會被釋放 造成強參考循環
paragraph = nil


class NewHTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        // 這邊使用無主參考 unowned
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
}
