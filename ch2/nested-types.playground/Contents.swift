
struct Poker {
    
    enum Suit: String {
        case spades = "黑桃", hearts = "紅心"
        case diamonds = "方塊", clubs = "梅花"
    }
    
    enum Rank: Int {
        case two = 2, three, four, five, six
        case seven, eight, nine, ten
        case jack, queen, king, ace
    }
    
    let rank: Rank, suit: Suit
    
    func description () {
        print("這張牌的花色是：\(suit.rawValue)")
        print("點數為：\(rank.rawValue)")
    }
    
}

let poker = Poker(rank: .king, suit: .hearts)

// 印出：這張牌的花色是：紅心，點數為：13
poker.description()


let diamondsName = Poker.Suit.diamonds

// 印出：方塊
print(diamondsName.rawValue)
