import Foundation

enum TabType: Int{
    case latest = 0
    case seasonItem = 1
    case furniture = 2
    case appliance = 3
    case audio = 4
    static let count = 5
    
    static func create(rawValue: Int) -> TabType {
        return self.init(rawValue: rawValue)!
    }
    
    func getTabName() -> String {
        switch self {
        case .latest:
            return "新着"
        case .seasonItem:
            return "季節物"
        case .furniture:
            return "家具"
        case .appliance:
            return "電化製品"
        case .audio:
            return "オーディオ"
        }
    }
    
}
