//
//  TranslationManager.swift
//  simply-english
//
//  Created by Max Dolensky on 4/9/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import Foundation

enum TranslationAPI {
    case detectLanguage
    case translate
    case supportedLanguages
    
    func getURL() -> String {
        var urlString = ""
        
        switch self {
        case .detectLanguage:
            urlString = "https://translation.googleapis.com/language/translate/v2/detect"
            
        case .translate:
            urlString = "https://translation.googleapis.com/language/translate/v2"
            
        case .supportedLanguages:
            urlString = "https://translation.googleapis.com/language/translate/v2/languages"
        }
        
        return urlString
    }
    
    func getHTTPMethod() -> String {
        if self == .supportedLanguages {
            return "GET"
        } else {
            return "POST"
        }
    }
}

struct TranslationLanguage {
    var code: String?
    var name: String?
}

// The shared property will let us use TranslationManager as a singleton class,
// or in simple words, we’ll be using the shared instance throughout the project
// instead of initializing new TranslationManager instances wherever and whenever
// we need to use it.

class TranslationManager: NSObject {
    
    static let shared = TranslationManager()
    private let apiKey = "AIzaSyBirAtubkd-R8rTzQZZb1kJ06BTc-4xlYE"
    var sourceLanguageCode: String? = nil
    var textToTranslate: String?
    var targetLanguageCode: String? = "en"
    var supportedLanguages = [TranslationLanguage]()
    
    
    override init() {
        super.init()
    }
    
    // The completion handler will pass the fetched results to the method that calls this one,
    // or it will simply return a nil value if no results have been fetched.
    private func makeRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String], completion: @escaping (_ results: [String: Any]?) -> Void) {
        
        if var components = URLComponents(string: api.getURL()) {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in urlParams {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            
            if let url = components.url {
                var request = URLRequest(url: url)
                request.httpMethod = api.getHTTPMethod()
                
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: request) { (results, response, error) in
                    
                    if let error = error {
                        print("Unable to perform request: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        if let response = response as? HTTPURLResponse, let results = results {
                            if response.statusCode == 200 || response.statusCode == 201 {
                                do {
                                    if let resultsDict = try JSONSerialization.jsonObject(with: results, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] {
                                        completion(resultsDict)
                                    }
                                } catch {
                                    print("2:",error.localizedDescription)
                                }
                            }
                        } else {
                            completion(nil)
                        }
                    }
                }
                
                task.resume()
            }
        }
    }
    
    func detectLanguage(forText text: String, completion: @escaping (_ language: String?) -> Void) {
        
        let urlParams = ["key": apiKey, "q": text]
        
        makeRequest(usingTranslationAPI: .detectLanguage, urlParams: urlParams) { (results) in
            guard let results = results else { completion(nil); return }
            
            if let data = results["data"] as? [String: Any], let detections = data["detections"] as? [[[String: Any]]] {
                var detectedLanguages = [String]()
                
                for detection in detections {
                    for currentDetection in detection {
                        if let language = currentDetection["language"] as? String {
                            detectedLanguages.append(language)
                        }
                    }
                }
                
                if detectedLanguages.count > 0 {
                    self.sourceLanguageCode = detectedLanguages[0]
                    completion(detectedLanguages[0])
                } else {
                    completion(nil)
                }
                
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchSupportedLanguages(completion: @escaping (_ success: Bool) -> Void) {
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["target"] = Locale.current.languageCode ?? "en"
        
        makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: urlParams) { (results) in
            guard let results = results else { completion(false); return }
            
            if let data = results["data"] as? [String: Any], let languages = data["languages"] as? [[String: Any]] {
                
                for lang in languages {
                    var languageCode: String?
                    var languageName: String?
                    
                    if let code = lang["language"] as? String {
                        languageCode = code
                    }
                    if let name = lang["name"] as? String {
                        languageName = name
                    }
                    
                    self.supportedLanguages.append(TranslationLanguage(code: languageCode, name: languageName))
                }
                
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
    
    // Through the completion handler of that method we’ll return either the translated text,
    // or nil if for some reason no translation was returned or parsed.
    func translate(completion: @escaping (_ translations: [String]?) -> Void) {
        guard let textToTranslate = textToTranslate, let targetLanguage = targetLanguageCode else { completion(nil); return }
        
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["q"] = textToTranslate
        urlParams["target"] = targetLanguage
        urlParams["format"] = "text"
        
        if let sourceLanguage = sourceLanguageCode {
            urlParams["source"] = sourceLanguage
        }
        
        makeRequest(usingTranslationAPI: .translate, urlParams: urlParams) { (results) in
            guard let results = results else { completion(nil); return }
            
            if let data = results["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] {
                var allTranslations = [String]()
                for translation in translations {
                    if let translatedText = translation["translatedText"] as? String {
                        allTranslations.append(translatedText)
                    }
                }
                
                if allTranslations.count > 0 {
                    completion(allTranslations)
                } else {
                    completion(nil)
                }
                
                
            } else {
                completion(nil)
            }
            
        }
    }
}

