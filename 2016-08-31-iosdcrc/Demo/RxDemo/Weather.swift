import Foundation

enum Weather {
    case Sunny, Cloudy, Rainy

    var description: String {
        switch self {
        case .Sunny:   return "晴れ"
        case .Cloudy:  return "曇り"
        case .Rainy:   return "雨"
        }
    }
}

extension Weather {
    static var random: Weather {
        switch arc4random_uniform(3) {
        case 0: return .Sunny
        case 1: return .Cloudy
        case 2: return .Rainy

        default:
            fatalError()
        }
    }
}
