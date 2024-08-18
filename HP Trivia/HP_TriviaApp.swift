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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
