//
//  SettingsView.swift
//  HP Trivia
//
//  Created by Anup Saud on 2024-08-16.
//

import SwiftUI

enum BookStatus{
    case active
    case inactive
    case locked
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dimiss
    @State private var books: [BookStatus] = [.active,.active,.inactive,.locked,.locked,.locked,.locked]
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            VStack{
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                ScrollView{
                    LazyVGrid(columns:[GridItem(),GridItem()]){
                        ForEach(0..<7){i in
                            if books[i] == .active{
                                ZStack(alignment:.bottomTrailing) {
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.green)
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    books[i] = .inactive
                                }
                            }
                            else if books[i] == .inactive{
                                ZStack(alignment:.bottomTrailing){
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.33))
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.green.opacity(0.5))
                                        .shadow(radius: 1)
                                        .padding(3)
                                    
                                }
                                .onTapGesture {
                                    books[i] = .active
                                }
                            }
                            else{
                                ZStack{
                                    Image(.hp3)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.6))
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .shadow(color: .white.opacity(0.75), radius: 3)
                                }
                            }
                        }
                    }
                    .padding()
                }
                Button("Done"){
                    dimiss()
                }
                .doneButton()
            }
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    SettingsView()
}
