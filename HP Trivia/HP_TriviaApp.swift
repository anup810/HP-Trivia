//
//  HP_TriviaApp.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-15.
//

import SwiftUI

@main
struct HP_TriviaApp: App {
    @StateObject private var store = Store()
    @StateObject private var game = GameViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(game)
                .task {
                    await store.loadProdcuts()
                }
        }
    }
}
