//
//  Game.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/19/22.
//

import Foundation
import FirebaseFirestore

struct Game: Codable {
    
    var gameID: String
    var hostID: String
    var playerIDs: [String]
    var status: GameStatus
    var timer: Countdown?
    var question: String?
    var round: Int?
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case hostID = "host_id"
        case playerIDs = "player_ids"
        case status = "status"
        case timer = "timer"
        case question = "question"
        case round = "round"
    }
    
    var isHost: Bool {
        guard let uid = DatabaseManager().getUserID() else { return false }
        return self.hostID == uid
    }
    
    var host: User?
    var players: [String: User]?
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.timer = try values.decodeIfPresent(Countdown.self, forKey: .timer)
        self.gameID = try values.decode(String.self, forKey: .gameID)
        self.hostID = try values.decode(String.self, forKey: .hostID)
        self.playerIDs = try values.decode([String].self, forKey: .playerIDs)
        self.round = try values.decodeIfPresent(Int.self, forKey: .round)
        self.question = try values.decodeIfPresent(String.self, forKey: .question)
        self.status = try values.decode(GameStatus.self, forKey: .status)
    }

    init (from: [String: Any]) throws {
        var from = from
        
        if from["player_ids"] == nil {
            from["player_ids"] = []
        }
                
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let game = try decoder.decode(Self.self, from: data)
        self = game
    }
    
}

enum GameStatus: String, Codable {
    
    case waiting
    case ready
    case chat
    case eliminate
    
    var description: String {
        switch self {
            case .waiting: return "Game starting in"
            case .ready: return "Game starting in"
            case .chat: return "Respond in"
            case .eliminate: return "Eliminate a player"
        }
    }
}

extension Game: Fetchable {
    static var apiBase: String { return "games" }
}
