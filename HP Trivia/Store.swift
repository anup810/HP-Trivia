//
//  Store.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-18.
//

import Foundation
import StoreKit

enum BookStatus: Codable{
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject{
    @Published var books: [BookStatus] = [.active,.active,.inactive,.locked,.locked,.locked,.locked]
    @Published var products: [Product] = []
    private var productIDS = ["hp4","hp5","hp6","hp7"]
    @Published var purchasedIDs = Set<String>()
    private var updates: Task<Void ,Never>? = nil
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedBooksStatus")
    init(){
        updates = watchForUpdates()
        
    }
    
    func loadProdcuts() async{
        do{
            products = try await Product.products(for: productIDS)
        }catch{
            print("Couldn't fetch the product:\(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do{
            let result = try await product.purchase()
            switch result {
                // Purchase sucessful, but now we have to verify recipt
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                case .verified(let signedType):
                    purchasedIDs.insert(signedType.productID)
                }
                
                // User cancelled or parent disapproved child's purchase request
            case .userCancelled:
                break
                // Waiting for approval
            case .pending:
                break
            @unknown default:
                break
            }
        }catch{
            print("Couldn't purchase that product: \(error)")
        }
    }
    
    func saveStatus(){
        do{
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        }catch{
            print("Unable to save data.")
        }
    }
    func loadStatus(){
        do{
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
        }catch{
            print("Uable to load book statuses")
        }
    }
    
   private func checkPurchased() async{
        for product in products {
            guard let state = await product.currentEntitlement else {return}
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType): \(verificationError)")
            case .verified(let signedType):
                if signedType.revocationDate == nil{
                    purchasedIDs.insert(signedType.productID)
                }else {
                    purchasedIDs.remove(signedType.productID)
                }
            }
        }
    }
    private func watchForUpdates() -> Task<Void, Never>{
        Task(priority: .background) {
            for await _ in Transaction.updates{
                await checkPurchased()
            }
        }
    }
}
