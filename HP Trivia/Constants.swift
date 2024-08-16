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
