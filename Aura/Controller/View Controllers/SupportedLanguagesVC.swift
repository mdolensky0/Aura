//
//  SupportedLanguagesVC.swift
//  Aura
//
//  Created by Max Dolensky on 7/20/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

protocol SupportedLanguagesDelegate {
    func updateLanguageButton(selectedLanguage: TranslationLanguage)
}

class SupportedLanguagesVC: UIViewController {

    var supportedLangs = [TranslationLanguage]()
    var tableView = UITableView()
    var delegate: SupportedLanguagesDelegate?
    var searchType: SearchType = .nativeToEnglish
    
    var searchBar: UISearchBar = {
        
        let searchBar = UISearchBar()
        searchBar.isTranslucent = false
        return searchBar
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    

    func setup() {
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.anchor(top: view.topAnchor,
                         bottom: nil,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         height: nil,
                         width: nil)
        
        tableView.anchor(top: searchBar.bottomAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         height: nil,
                         width: nil)
        
        setupToHideKeyboardOnTapOnView()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SupportedLanguageCell.self, forCellReuseIdentifier: K.Cells.supportedLanguageCell)
        
        // Change to a loading screen later
        if TranslationManager.shared.supportedLanguages.count == 0 {
            TranslationManager.shared.fetchSupportedLanguages { (success) in
                if success {
                    self.supportedLangs = TranslationManager.shared.supportedLanguages
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        else {
            supportedLangs = TranslationManager.shared.supportedLanguages
            tableView.reloadData()
        }
        
    }
    
}

//MARK: - TableView DataSource

extension SupportedLanguagesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return supportedLangs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.supportedLanguageCell, for: indexPath) as! SupportedLanguageCell
        
        let language = supportedLangs[indexPath.row]
        cell.label.text = language.name
        return cell
        
    }
    
}

//MARK: - TableView Delegate

extension SupportedLanguagesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedLanguage = supportedLangs[indexPath.row]
        
        switch searchType {
            
        case .englishToNative:
            TranslationManager.shared.targetLanguageCode = selectedLanguage.code
            TranslationManager.shared.targetLanguageName = selectedLanguage.name
            
        case .nativeToEnglish:
            TranslationManager.shared.sourceLanguageCode = selectedLanguage.code
            TranslationManager.shared.sourceLanguageName = selectedLanguage.name
            
        }
        
        self.delegate?.updateLanguageButton(selectedLanguage: selectedLanguage)
        dismiss(animated: true, completion: nil)
        
    }
    
}

//MARK: - SearchBar Delegate Methods

extension SupportedLanguagesVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != nil && searchBar.text!.count > 0 {
            supportedLangs = TranslationManager.shared.supportedLanguages.filter({ (language: TranslationLanguage) -> Bool in
                return language.name!.lowercased().contains(searchBar.text!.lowercased())
            })
        }
        else {
            supportedLangs = TranslationManager.shared.supportedLanguages
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != nil && searchBar.text!.count > 0 {
            supportedLangs = TranslationManager.shared.supportedLanguages.filter({ (language: TranslationLanguage) -> Bool in
                return language.name!.lowercased().contains(searchBar.text!.lowercased())
            })
        }
        else {
            supportedLangs = TranslationManager.shared.supportedLanguages
        }
        tableView.reloadData()
    }
}
