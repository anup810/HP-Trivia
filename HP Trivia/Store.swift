//
//  Store.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-18.
//

import Foundation
import StoreKit

// Enum representing the status of each book
enum BookStatus {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    @Published var products: [Product] = []
    private var productIDS = ["hp4", "hp5", "hp6", "hp7"]
    @Published var purchasedIDs = Set<String>()
    private var updates: Task<Void, Never>? = nil
    
    // Initializer to start watching for transaction updates
    init() {
        updates = watchForUpdates()
    }
    
    // Function to load products
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDS)
        } catch {
            print("Couldn't fetch the product: \(error)")
        }
    }
    
    // Function to handle the purchase of a product
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                case .verified(let signedType):
                    purchasedIDs.insert(signedType.productID)
                }
            case .userCancelled:
                // User cancelled the purchase
                break
            case .pending:
                // Waiting for approval
                break
            @unknown default:
                break
            }
        } catch {
            print("Couldn't purchase that product: \(error)")
        }
    }
    
    // Private function to check previously purchased products
    private func checkPurchased() async {
        for product in products {
            guard let state = await product.currentEntitlement else { return }
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType): \(verificationError)")
            case .verified(let signedType):
                if signedType.revocationDate == nil {
                    purchasedIDs.insert(signedType.productID)
                } else {
                    purchasedIDs.remove(signedType.productID)
                }
            }
        }
    }
    
    // Private function to watch for transaction updates and check purchase status from App store
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}
