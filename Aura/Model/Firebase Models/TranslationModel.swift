//
//  TranslationModel.swift
//  simply-english
//
//  Created by Max Dolensky on 4/15/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import Foundation

struct TranslationModel: Codable {
    var nativeText: String
    var wordModelIDs: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case nativeText
        case wordModelIDs
    }
}
