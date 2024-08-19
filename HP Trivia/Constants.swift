//
//  Constants.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-15.
//
import SwiftUI
import Foundation

enum Constants {
    static let hpFont = "PartyLetPlain"
    static let previewQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
}

struct InfoBackgroundImage: View{
    var body: some View{
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

extension Button{
    func doneButton()-> some View{
        self                  
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundStyle(.white)
        
    }
}
