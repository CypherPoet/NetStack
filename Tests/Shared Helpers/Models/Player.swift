import Foundation


struct Player {
    var name: String
    var xp: Double
    var level: Int
}

extension Player: Codable {}
