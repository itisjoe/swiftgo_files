
struct Poker {
    
    enum Suit: String {
        case Spades = "黑桃", Hearts = "紅心", Diamonds = "方塊", Clubs = "梅花"
    }
    
    enum Rank: Int {
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
        case Jack, Queen, King, Ace
    }
    
    let rank: Rank, suit: Suit
    
    func description () {
        print("這張牌的花色是：\(suit.rawValue)，點數為：\(rank.rawValue)")
    }
    
}

let poker = Poker(rank: .King, suit: .Hearts)

// 印出：這張牌的花色是：紅心，點數為：13
poker.description()


let diamondsName = Poker.Suit.Diamonds

// 印出：方塊
print(diamondsName.rawValue)
