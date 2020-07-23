//
//  FirebaseManager.swift
//  simply-english
//
//  Created by Max Dolensky on 2/10/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseManager {
    
    let db = Firestore.firestore()
    static let shared = FirebaseManager()
    
    func writeEnglishWordData(wordModel: WordModel) {
        print("writing dict data")
        do {
            try db.collection(K.FBConstants.dictionaryCollectionName).document(wordModel.id).setData(from: wordModel)
        } catch let error {
            print("Error writing word to Firestore: \(error)")
        }
    }
    
    func writeNativeWordData(translationModel: TranslationModel, to collectionName: String) {
        print("writing dict data")
        do {
            try db.collection(collectionName).document(translationModel.nativeText).setData(from: translationModel)
        } catch let error {
            print("Error writing word to Firestore: \(error)")
        }
    }
    
    func readEnglishDocumentByWord(words: [String], completion: @escaping(_ result: [WordModel?]) -> Void) {
        
        var results = [WordModel?]()
        var finalResults = [WordModel?]()
        let lowerCaseWords = words.map { $0.lowercased() }
        let dispatchGroup = DispatchGroup()
        
        for word in lowerCaseWords {
            
            let docRef = db.collection(K.FBConstants.dictionaryCollectionName).document(word)
            dispatchGroup.enter()
            docRef.getDocument { (document, error) in

                let result = Result {
                    try document.flatMap {
                        try $0.data(as: WordModel.self)
                    }
                }
                switch result {
                case .success(let wordModel):
                    if let wordModel = wordModel {
                        results.append(wordModel)
                    } else {
                        results.append(nil)
                        print("Document does not exist")
                    }
                case .failure(let error):
                    results.append(nil)
                    print("Error decoding: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            for word in words {
                let temp = results.filter{$0?.id == word.lowercased()}
                if temp.count == 0 {finalResults.append(nil)}
                else {
                    finalResults.append(temp[0])
                }
                
            }
            completion(finalResults)
            print("Finished with \(results.count) WordModels")
        }
    }
    
    func readNativeDocument(text: String, collectionName: String, completion: @escaping(_ result: [Int]?) -> Void) {
        
        let docRef = db.collection(collectionName).document(text)
        docRef.getDocument { (document, error) in
            let result = Result {
                try document.flatMap {
                    try $0.data(as: TranslationModel.self)
                }
            }
            switch result {
            case .success(let translationModel):
                if let translationModel = translationModel {
                    completion(translationModel.wordModelIDs)
                } else {
                    print("Word not found in Firebase")
                    completion(nil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
