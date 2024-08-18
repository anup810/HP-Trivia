//
//  Store.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-18.
//

import Foundation
import StoreKit

enum BookStatus{
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject{
    @Published var books: [BookStatus] = [.active,.active,.inactive,.locked,.locked,.locked,.locked]
    @Published var products: [Product] = []
    private var productIDS = ["hp4","hp5","hp6","hp7"]
    
    func loadProdcuts() async{
        do{
            products = try await Product.products(for: productIDS)
        }catch{
            print("Couldn't fetch the product:\(error)")
        }
    }
}
