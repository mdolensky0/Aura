//
//  SearchInfo.swift
//  Aura
//
//  Created by Max Dolensky on 7/23/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import Foundation

struct SearchInfo {
    
    var searchType = SearchType.nativeToEnglish
    var sourceLanguageCode: String
    var sourceLanguageName: String
    var targetLanguageCode: String = "en"
    var targetLanguageName: String = "English"
    
}
