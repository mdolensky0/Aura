//
//  PurchasingManager.swift
//  Aura
//
//  Created by Maxwell Dolensky on 1/20/21.
//  Copyright © 2021 Max Dolensky. All rights reserved.
//

import UIKit
import StoreKit

class PurchasingManager: NSObject {
    
   
    //MARK: - Variables
    static let shared = PurchasingManager()
    
    var myProduct: SKProduct?
    var parentVC: UIViewController? 
    
    //MARK: - INIT
    override init() {
        super.init()
    }
    
    // Call this to get the product with the specific identifier
    func fetchProducts(productIdentifier: String, parentVC: UIViewController?) {
        self.parentVC = parentVC
        
        let request = SKProductsRequest(productIdentifiers: [productIdentifier])
        request.delegate = self
        request.start()
    }
    
    // This is the function to call to perform the purchase
    func makePayment() {
        
        guard let myProduct = myProduct else {
            print("my product is nil")
            parentVC?.endLoadingScreen()
            return
        }
        
        if SKPaymentQueue.canMakePayments() {
            parentVC?.endLoadingScreen()
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
        
    }
    
    func handlePurchase() {
        AdManager.shared.funnelProgress = .completedVideo2Bought
        Utilities.shared.user?.purchases["EHDMasterCourse"] = true
        if let user = Utilities.shared.user {
            FirebaseManager.shared.updateUser(user: user)
        }
        AdManager.shared.removeBuyButton()
        if let window = UIApplication.shared.keyWindow {
            window.displayCheck(text: "Success!")
        }
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Unable To Process this Purchase", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (action) in }
        alert.addAction(action)
        DispatchQueue.main.async {
            self.parentVC?.present(alert, animated: true, completion: nil)
        }
    }
    
}

//MARK: - Request Delegate
extension PurchasingManager: SKProductsRequestDelegate {
    
    // Called when the request returns
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        guard let product = response.products.first else {
            print("Unable to fetch product")
            DispatchQueue.main.async {
                self.parentVC?.endLoadingScreen()
            }
            showError(error: "Unable to fetch product. Please try again later")
            return
        }
        
        myProduct = product
        print(product.productIdentifier)
        print(product.price)
        print(product.priceLocale)
        print(product.localizedTitle)
        print(product.localizedDescription)
        
        makePayment()
        
    }
    
    // Called if request failed. Should inform user
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        guard request is SKProductsRequest else {
            return
        }
        
        print("Product fetch request failed")
        DispatchQueue.main.async {
            self.parentVC?.endLoadingScreen()
            self.showError(error: "Unable to fetch product. Please try again later")
        }
    }
    
}

//MARK: - Transaction Observer
extension PurchasingManager: SKPaymentTransactionObserver {
    
    // Called when you initiate a transaction
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            // Make sure the transaction is the same as the myProduct otherwise continue
            if transaction.payment.productIdentifier != myProduct?.productIdentifier {
                continue
            }
            
            switch transaction.transactionState {
            case.purchasing:
                
                break
            
            case .purchased, .restored:
                
                // Unlock their in app purchase
                handlePurchase()
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            
            case .failed, .deferred:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            
            default:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
}
