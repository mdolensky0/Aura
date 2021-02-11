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
    
    //MARK: - INIT
    override init() {
        super.init()
    }
    
    func fetchProducts(productIdentifier: String) {
        let request = SKProductsRequest(productIdentifiers: [productIdentifier])
        request.delegate = self
        request.start()
    }
    
    func makePayment() {
        
        guard let myProduct = myProduct else {
            print("my product is nil")
            return
        }
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
        
    }
    
    func handlePurchase() {
        // Handle the purchase. Finish when everything is set  up
    }
    
}

//MARK: - Request Delegate
extension PurchasingManager: SKProductsRequestDelegate {
    
    // Called when the request returns
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        guard let product = response.products.first else {
            print("Unable to fetch product")
            return
        }
        
        myProduct = product
        print(product.productIdentifier)
        print(product.price)
        print(product.priceLocale)
        print(product.localizedTitle)
        print(product.localizedDescription)
        
    }
    
    // Called if request failed. Should inform user
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        guard request is SKProductsRequest else {
            return
        }
        
        print("Product fetch request failed")
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
