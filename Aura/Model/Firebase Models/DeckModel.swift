//
//  DeckModel.swift
//  Aura
//
//  Created by Max Dolensky on 8/8/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import Foundation

struct DeckModel: Codable {
    
    var name: String
    var numberOfCards: Int
    var prevScore: Double
    var numRight: Int
    var numSeen: Int
    var cards: [FlashcardModel]
    
}

struct FlashcardModel: Codable {
    
    let wordArray: [String]
    let wordModelArray: [WordModel?]
    let ipaIndex: Int
    let bottomLabelText: String
    var score: Double
    var numRight: Int
    var numSeen: Int
    var cardIndex: Int
    
}
