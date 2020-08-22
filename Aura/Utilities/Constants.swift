//
//  Constants.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//
import UIKit

struct K {
    
    struct FBConstants {
        static let dictionaryCollectionName = "Words"
        static let usersCollectionName = "Users"
    }
    
    struct Colors {
        static let red         = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        static let green       = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        static let blue        = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        static let lightGreen  = UIColor(red: 0.5843, green: 0.8275, blue: 0.3098, alpha: 1.0)
        static let seaBlue     = UIColor(red: 0.0, green: 0.5176, blue: 0.5843, alpha: 1.0)
        static let darkGreen   = UIColor(red: 0.0, green: 0.3450, blue: 0.0, alpha: 1.0)
        static let lightPink   = UIColor(red: 0.9647, green: 0.6196, blue: 0.8627, alpha: 1.0)
        static let orange      = UIColor(red: 1.0, green: 0.5137, blue: 0.1608, alpha: 1.0)
        static let pink        = UIColor(red: 1.0, green: 0.0588, blue: 0.7765, alpha: 1.0)
        static let purple      = UIColor(red: 0.8275, green: 0.0667, blue: 1.0, alpha: 1.0)
        static let lightBlue   = UIColor(red: 0.5176, green: 0.5176, blue: 1.0, alpha: 1.0)
        static let darkBlue    = UIColor(red: 0.0, green: 0.0, blue: 0.4863, alpha: 1.0)
        static let turquoise   = UIColor(red: 0.0, green: 1.0, blue: 0.7568, alpha: 1.0)
        
        static let brownPurple = UIColor(red: 0.4823, green: 0.1019, blue: 0.4117, alpha: 1.0)
        static let brownRed    = UIColor(red: 0.6196, green: 0.3098, blue: 0.2745, alpha: 1.0)
        static let tan         = UIColor(red: 1.0, green: 0.7568, blue: 0.5176, alpha: 1.0)
        static let brownYellow = UIColor(red: 0.7176, green: 0.6235, blue: 0.1922, alpha: 1.0)
        
        static let black       = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        static let darkGrey    = UIColor(red: 0.5215, green: 0.5215, blue: 0.5215, alpha: 1.0)
        static let lightGrey   = UIColor(red: 0.9215, green: 0.9215, blue: 0.9215, alpha: 1.0)
        static let yellow      = UIColor(red: 255.0/255.0, green: 222.0/255.0, blue: 3.0/255.0, alpha: 1.0)
        static let blueGrey    = UIColor(red: 0.7882, green: 0.9294, blue: 0.9333, alpha: 1.0)
        static let maroon      = UIColor(red: 0.6588, green: 0.0314, blue: 0.0, alpha: 1.0)
    }
    
    struct DesignColors {
        
        static let background   = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        static let primary      = UIColor(red: 98.0/255.0, green: 0.0, blue: 238.0/255.0, alpha: 1.0)
        static let darkVariant  = UIColor(red: 55.0/255.0, green: 0.0, blue: 179.0/255.0, alpha: 1.0)
        static let lightVariant = UIColor(red: 187.0/255.0, green: 134.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        static let error        = UIColor(red: 176.0/255.0, green: 0.0, blue: 32.0/255.0, alpha: 1.0)
    }
    
    struct Fonts {
        
        static let didot = "Didot"
        static let didotBold = "Didot-Bold"
        static let avenirBlack = "Avenir-Black"
        
    }
    
    struct Cells {
        static let prevSearchCell = "PrevSearchCell"
        static let supportedLanguageCell = "SupportedLanguageCell"
        static let deckCell = "DeckCell"
        static let flashcardCell = "FlashcardCell"
    }
    
    struct LanguageCodes {
        
        static let languageDict =  ["en" : "English",     "en-GB" : "English",      "en-AU" : "English",
                                    "en-CA" : "English",  "en-IN" : "English",      "fr" : "Français",
                                    "fr-CA" : "Français",   "es" : "Español",           "es-MX" : "Español",
                                    "pt" : "Português",     "pt-BR" : "Português",      "it" : "Italiano",
                                    "de" : "Deutsch",      "zh-Hans" : "简体中文",        "zh-Hant" : "繁體中文",
                                    "zh-HK" : "繁體中文",      "ja" : "日本語",                "nl" : "Nederlands",
                                    "ko" : "한국어",           "vi" : "Tiếng Việt",       "ru" : "Pусский",
                                    "sv" : "Svenska",       "da" : "Dansk",               "fi" : "Suomi",
                                    "nb" : "Norsk",         "tr" : "Türkçe",                "el" : "Eλληνικά",
                                    "id" : "Indonesia",    "ms" : "Melayu",             "th" : "ภาษาไทย",
                                    "hi" : "हिंदी",              "hu" : "Magyar",             "pl" : "Polski",
                                    "cs" : "čeština",       "sk" : "Slovenčina",         "uk" : "українська",
                                    "ca" : "Català",      "ro" : "Română",             "hr" : "Hrvatski",
                                    "he" : "עברית",           "ar" : "العربية"]
        
        static let iosToGoogleLangCode = ["en-GB" : "en", "en-AU" : "en", "en-CA" : "en",
                                          "en-IN" : "en", "fr-CA" : "fr", "es-MX" : "es",
                                          "pt-BR" : "pt","zh-Hans" : "zh-CN", "zh-Hant" : "zh-TW",
                                          "zh-HK" : "zh_TW", "nb" : "no"]
    }
    
    struct KeyInfo {
        
        // Info for vowelKey cards
        static let vowelSoundAndColor = [("BOT", K.Colors.green), ("BAT", K.Colors.red), ("BOUT", K.Colors.blue),
                              ("BOOT", K.Colors.lightGreen), ("BUT", K.Colors.lightPink), ("BOOK", K.Colors.lightBlue),
                              ("BEAT", K.Colors.seaBlue), ("BIT", K.Colors.orange), ("BET", K.Colors.darkGreen),
                              ("BAIT", K.Colors.pink), ("BITE", K.Colors.darkBlue), ("BOAT", K.Colors.purple),
                              ("BOYD", K.Colors.turquoise)]
        
        // Info for fluidConsonantsKey cards
        static let fluidSoundAndColor = [("VISION", K.Colors.brownPurple), ("JOKE", K.Colors.brownYellow),
                              ("CHOKE", K.Colors.brownRed), ("MISSION", K.Colors.tan),
                              ("Y", K.Colors.blueGrey)]
        
        // Info for trueConsonantsKey cards
        static let trueSoundAndText = [("B", "b"), ("K", "c"), ("D", "d"), ("F", "f"), ("G", "g"), ("H", "h"), ("K", "k"),
                                ("L", "l"), ("M", "m"), ("N", "n"), ("P", "p"), ("R", "r"), ("S", "s"), ("T", "t"),
                                ("V", "v"), ("W", "w"), ("KS", "x"), ("Z", "z"), ("Q", "qu"), ("TH", "th")]
        
        // Info for flipConsonantsKey cards
        static let flipSoundAndText = [("S", "c"), ("T", "d"), ("V", "f"), ("DarkL", "l"), ("NSoft", "n"), ("DarkR", "r"),
                                ("Z", "s"), ("D", "t"), ("GZ", "x"), ("S", "z"), ("THunvoiced", "th")]
        
        // Might Use to give the full key view sound options
        static let colorToSoundDictionary = [K.Colors.green: "BOT", K.Colors.red: "BAT", K.Colors.blue: "BOUT",
                                             K.Colors.lightGreen: "BOOT", K.Colors.lightPink: "BUT", K.Colors.lightBlue: "BOOK",
                                             K.Colors.seaBlue: "BEAT", K.Colors.orange: "BIT", K.Colors.darkGreen: "BET",
                                             K.Colors.pink: "BAIT", K.Colors.darkBlue: "BITE", K.Colors.purple: "BOAT",
                                             K.Colors.turquoise: "BOYD", K.Colors.brownPurple: "VISION", K.Colors.brownYellow: "JOKE",
                                             K.Colors.brownRed: "CHOKE", K.Colors.tan: "MISSION", K.Colors.blueGrey: "Y"]
        
    }
    
    static let linkToWildCardDictionary: [String: NSMutableAttributedString] = {
        
        var dictionary = [String: NSMutableAttributedString]()
        
        let wild1 = NSMutableAttributedString(string: "z")
        dictionary["1"] = wild1
        
        let wild2 = NSMutableAttributedString(string: "ya")
        wild2.addAttribute(.foregroundColor, value: K.Colors.lightPink, range: NSRange(location: 1, length: 1))
        dictionary["2"] = wild2
        
        let wild3 = NSMutableAttributedString(string: "yu")
        wild3.addAttribute(.foregroundColor, value: K.Colors.lightPink, range: NSRange(location: 1, length: 1))
        dictionary["3"] = wild3
        
        let wild4 = NSMutableAttributedString(string: "yew")
        wild4.addAttribute(.foregroundColor, value: K.Colors.lightGreen, range: NSRange(location: 1, length: 2))
        dictionary["4"] = wild4
        
        
        let wild5 = NSMutableAttributedString(string: "yu")
        wild5.addAttribute(.foregroundColor, value: K.Colors.lightGreen, range: NSRange(location: 1, length: 1))
        dictionary["5"] = wild5
        
        let wild6 = NSMutableAttributedString(string: "ksh")
        wild6.addAttribute(.foregroundColor, value: K.Colors.tan, range: NSRange(location: 1, length: 2))
        dictionary["6"] = wild6
        
        let wild7 = NSMutableAttributedString(string: "wa")
        wild7.addAttribute(.foregroundColor, value: K.Colors.pink, range: NSRange(location: 1, length: 1))
        dictionary["7"] = wild7
        
        let wild8 = NSMutableAttributedString(string: "wo")
        wild8.addAttribute(.foregroundColor, value: K.Colors.lightPink, range: NSRange(location: 1, length: 1))
        dictionary["8"] = wild8
        
        let wild9 = NSMutableAttributedString(string: "wa")
        wild9.addAttribute(.foregroundColor, value: K.Colors.orange, range: NSRange(location: 1, length: 1))
        dictionary["9"] = wild9
        

        let wild10 = NSMutableAttributedString(string: "f")
        dictionary["10"] = wild10
        
        let wild11 = NSMutableAttributedString(string: "h")
        dictionary["11"] = wild11
        
        let wild12 = NSMutableAttributedString(string: "k")
        dictionary["12"] = wild12
        
        let wild13 = NSMutableAttributedString(string: "w")
        dictionary["13"] = wild13
        
        let wild14 = NSMutableAttributedString(string: "t")
        dictionary["14"] = wild14
        
        let wild15 = NSMutableAttributedString(string: "v")
        dictionary["15"] = wild15
        
        let wild16 = NSMutableAttributedString(string: "r")
        wild16.addAttribute(.foregroundColor, value: K.Colors.darkGrey, range: NSRange(location: 0, length: 1))
        dictionary["16"] = wild16
        
        let wild17 = NSMutableAttributedString(string: "g")
        dictionary["17"] = wild17
        
        return dictionary
        
    }()
}

